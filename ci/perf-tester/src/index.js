/*
Adapted from preactjs/compressed-size-action, which is available under this license:

MIT License
Copyright (c) 2020 Preact
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

const { setFailed, startGroup, endGroup, debug } = require("@actions/core");
const { GitHub, context } = require("@actions/github");
const { exec } = require("@actions/exec");
const {
    getInput,
    runBenchmark,
    averageBenchmarks,
    toDiff,
    diffTable,
    toBool,
} = require("./utils.js");

const benchmarkParallel = 2;
const benchmarkSerial = 2;
const runBenchmarks = async () => {
    let results = [];
    for (let i = 0; i < benchmarkSerial; i++) {
        results = results.concat(
            await Promise.all(Array(benchmarkParallel).fill().map(runBenchmark))
        );
    }
    return averageBenchmarks(results);
};

async function run(octokit, context, token) {
    const { number: pull_number } = context.issue;

    const pr = context.payload.pull_request;
    try {
        debug("pr" + JSON.stringify(pr, null, 2));
    } catch (e) {}
    if (!pr) {
        throw Error(
            'Could not retrieve PR information. Only "pull_request" triggered workflows are currently supported.'
        );
    }

    console.log(
        `PR #${pull_number} is targetted at ${pr.base.ref} (${pr.base.sha})`
    );

    const buildScript = getInput("build-script");
    startGroup(`[current] Build using '${buildScript}'`);
    await exec(buildScript);
    endGroup();

    startGroup(`[current] Running benchmark`);
    const newBenchmarks = await runBenchmarks();
    endGroup();

    startGroup(`[base] Checkout target branch`);
    let baseRef;
    try {
        baseRef = context.payload.base.ref;
        if (!baseRef)
            throw Error("missing context.payload.pull_request.base.ref");
        await exec(
            `git fetch -n origin ${context.payload.pull_request.base.ref}`
        );
        console.log("successfully fetched base.ref");
    } catch (e) {
        console.log("fetching base.ref failed", e.message);
        try {
            await exec(`git fetch -n origin ${pr.base.sha}`);
            console.log("successfully fetched base.sha");
        } catch (e) {
            console.log("fetching base.sha failed", e.message);
            try {
                await exec(`git fetch -n`);
            } catch (e) {
                console.log("fetch failed", e.message);
            }
        }
    }

    console.log("checking out and building base commit");
    try {
        if (!baseRef) throw Error("missing context.payload.base.ref");
        await exec(`git reset --hard ${baseRef}`);
    } catch (e) {
        await exec(`git reset --hard ${pr.base.sha}`);
    }
    endGroup();

    startGroup(`[base] Build using '${buildScript}'`);
    await exec(buildScript);
    endGroup();

    startGroup(`[base] Running benchmark`);
    const oldBenchmarks = await runBenchmarks();
    endGroup();

    const diff = toDiff(oldBenchmarks, newBenchmarks);

    const markdownDiff = diffTable(diff, {
        collapseUnchanged: true,
        omitUnchanged: false,
        showTotal: true,
        minimumChangeThreshold: parseInt(
            getInput("minimum-change-threshold"),
            10
        ),
    });

    let outputRawMarkdown = false;

    const commentInfo = {
        ...context.repo,
        issue_number: pull_number,
    };

    const comment = {
        ...commentInfo,
        body: markdownDiff,
    };

    if (toBool(getInput("use-check"))) {
        if (token) {
            const finish = await createCheck(octokit, context);
            await finish({
                conclusion: "success",
                output: {
                    title: `Compressed Size Action`,
                    summary: markdownDiff,
                },
            });
        } else {
            outputRawMarkdown = true;
        }
    } else {
        startGroup(`Updating stats PR comment`);
        let commentId;
        try {
            const comments = (await octokit.issues.listComments(commentInfo))
                .data;
            for (let i = comments.length; i--; ) {
                const c = comments[i];
                if (
                    c.user.type === "Bot" &&
                    /<sub>[\s\n]*performance-action/.test(c.body)
                ) {
                    commentId = c.id;
                    break;
                }
            }
        } catch (e) {
            console.log("Error checking for previous comments: " + e.message);
        }

        if (commentId) {
            console.log(`Updating previous comment #${commentId}`);
            try {
                await octokit.issues.updateComment({
                    ...context.repo,
                    comment_id: commentId,
                    body: comment.body,
                });
            } catch (e) {
                console.log("Error editing previous comment: " + e.message);
                commentId = null;
            }
        }

        // no previous or edit failed
        if (!commentId) {
            console.log("Creating new comment");
            try {
                await octokit.issues.createComment(comment);
            } catch (e) {
                console.log(`Error creating comment: ${e.message}`);
                console.log(`Submitting a PR review comment instead...`);
                try {
                    const issue = context.issue || pr;
                    await octokit.pulls.createReview({
                        owner: issue.owner,
                        repo: issue.repo,
                        pull_number: issue.number,
                        event: "COMMENT",
                        body: comment.body,
                    });
                } catch (e) {
                    console.log("Error creating PR review.");
                    outputRawMarkdown = true;
                }
            }
        }
        endGroup();
    }

    if (outputRawMarkdown) {
        console.log(
            `
			Error: performance-action was unable to comment on your PR.
			This can happen for PR's originating from a fork without write permissions.
			You can copy the size table directly into a comment using the markdown below:
			\n\n${comment.body}\n\n
		`.replace(/^(\t|  )+/gm, "")
        );
    }

    console.log("All done!");
}

// create a check and return a function that updates (completes) it
async function createCheck(octokit, context) {
    const check = await octokit.checks.create({
        ...context.repo,
        name: "Compressed Size",
        head_sha: context.payload.pull_request.head.sha,
        status: "in_progress",
    });

    return async (details) => {
        await octokit.checks.update({
            ...context.repo,
            check_run_id: check.data.id,
            completed_at: new Date().toISOString(),
            status: "completed",
            ...details,
        });
    };
}

(async () => {
    try {
        const token = getInput("repo-token", { required: true });
        const octokit = new GitHub(token);
        await run(octokit, context, token);
    } catch (e) {
        setFailed(e.message);
    }
})();
