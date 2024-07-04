Error.stackTraceLimit = Infinity;

import { startWasiTask } from "../IntegrationTests/lib.js";

if (process.env["JAVASCRIPTKIT_WASI_BACKEND"] === "MicroWASI") {
  console.log("Skipping XCTest tests for MicroWASI because it is not supported yet.");
  process.exit(0);
}

const handleExitOrError = (error) => {
  console.log(error);
  process.exit(1);
}

Error.stackTraceLimit = Infinity;

startWasiTask(process.argv[2]).catch(handleExitOrError);
