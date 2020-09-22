import { setFailed, startGroup, endGroup, debug } from '@actions/core';
import { GitHub, context } from '@actions/github';
import { exec } from '@actions/exec';
import { getInput, runBenchmark, averageBenchmarks, toDiff, diffTable, toBool } from './utils.js';

async function run(octokit, context, token) {
	const { number: pull_number } = context.issue;

	const pr = context.payload.pull_request;
	try {
		debug('pr' + JSON.stringify(pr, null, 2));
	} catch (e) { }
	if (!pr) {
		throw Error('Could not retrieve PR information. Only "pull_request" triggered workflows are currently supported.');
	}

	console.log(`PR #${pull_number} is targetted at ${pr.base.ref} (${pr.base.sha})`);

	const buildScript = getInput('build-script');
	startGroup(`[current] Build using '${buildScript}'`);
	await exec(buildScript);
	endGroup();

	startGroup(`[current] Running benchmark`);
	const newBenchmarks = await Promise.all([runBenchmark(), runBenchmark()]).then(averageBenchmarks);
	endGroup();

	startGroup(`[base] Checkout target branch`);
	let baseRef;
	try {
		baseRef = context.payload.base.ref;
		if (!baseRef) throw Error('missing context.payload.pull_request.base.ref');
		await exec(`git fetch -n origin ${context.payload.pull_request.base.ref}`);
		console.log('successfully fetched base.ref');
	} catch (e) {
		console.log('fetching base.ref failed', e.message);
		try {
			await exec(`git fetch -n origin ${pr.base.sha}`);
			console.log('successfully fetched base.sha');
		} catch (e) {
			console.log('fetching base.sha failed', e.message);
			try {
				await exec(`git fetch -n`);
			} catch (e) {
				console.log('fetch failed', e.message);
			}
		}
	}

	console.log('checking out and building base commit');
	try {
		if (!baseRef) throw Error('missing context.payload.base.ref');
		await exec(`git reset --hard ${baseRef}`);
	}
	catch (e) {
		await exec(`git reset --hard ${pr.base.sha}`);
	}
	endGroup();

	startGroup(`[base] Build using '${buildScript}'`);
	await exec(buildScript);
	endGroup();

	startGroup(`[base] Running benchmark`);
	const oldBenchmarks = await Promise.all([runBenchmark(), runBenchmark()]).then(averageBenchmarks);
	endGroup();

	const diff = toDiff(oldBenchmarks, newBenchmarks);

	const markdownDiff = diffTable(diff, {
		collapseUnchanged: true,
		omitUnchanged: false,
		showTotal: true,
		minimumChangeThreshold: parseInt(getInput('minimum-change-threshold'), 10)
	});

	let outputRawMarkdown = false;

	const commentInfo = {
		...context.repo,
		issue_number: pull_number
	};

	const comment = {
		...commentInfo,
		body: markdownDiff + '\n\n<a href="https://github.com/j-f1/performance-action"><sub>performance-action</sub></a>'
	};

	if (toBool(getInput('use-check'))) {
		if (token) {
			const finish = await createCheck(octokit, context);
			await finish({
				conclusion: 'success',
				output: {
					title: `Compressed Size Action`,
					summary: markdownDiff
				}
			});
		}
		else {
			outputRawMarkdown = true;
		}
	}
	else {
		startGroup(`Updating stats PR comment`);
		let commentId;
		try {
			const comments = (await octokit.issues.listComments(commentInfo)).data;
			for (let i = comments.length; i--;) {
				const c = comments[i];
				if (c.user.type === 'Bot' && /<sub>[\s\n]*performance-action/.test(c.body)) {
					commentId = c.id;
					break;
				}
			}
		}
		catch (e) {
			console.log('Error checking for previous comments: ' + e.message);
		}

		if (commentId) {
			console.log(`Updating previous comment #${commentId}`)
			try {
				await octokit.issues.updateComment({
					...context.repo,
					comment_id: commentId,
					body: comment.body
				});
			}
			catch (e) {
				console.log('Error editing previous comment: ' + e.message);
				commentId = null;
			}
		}

		// no previous or edit failed
		if (!commentId) {
			console.log('Creating new comment');
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
						event: 'COMMENT',
						body: comment.body
					});
				} catch (e) {
					console.log('Error creating PR review.');
					outputRawMarkdown = true;
				}
			}
		}
		endGroup();
	}

	if (outputRawMarkdown) {
		console.log(`
			Error: performance-action was unable to comment on your PR.
			This can happen for PR's originating from a fork without write permissions.
			You can copy the size table directly into a comment using the markdown below:
			\n\n${comment.body}\n\n
		`.replace(/^(\t|  )+/gm, ''));
	}

	console.log('All done!');
}


// create a check and return a function that updates (completes) it
async function createCheck(octokit, context) {
	const check = await octokit.checks.create({
		...context.repo,
		name: 'Compressed Size',
		head_sha: context.payload.pull_request.head.sha,
		status: 'in_progress',
	});

	return async details => {
		await octokit.checks.update({
			...context.repo,
			check_run_id: check.data.id,
			completed_at: new Date().toISOString(),
			status: 'completed',
			...details
		});
	};
}

(async () => {
	try {
		const token = getInput('repo-token', { required: true });
		const octokit = new GitHub(token);
		await run(octokit, context, token);
	} catch (e) {
		setFailed(e.message);
	}
})();
