Error.stackTraceLimit = Infinity;

const { startWasiTask, WASI } = require("../IntegrationTests/lib");

const handleExitOrError = (error) => {
  console.log(error);
  process.exit(1);
}

startWasiTask(process.argv[2]).catch(handleExitOrError);
