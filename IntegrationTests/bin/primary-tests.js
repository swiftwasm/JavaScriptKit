global.globalObject1 = {
  "prop_1": {
    "nested_prop": 1,
  },
  "prop_2": 2,
  "prop_3": true,
  "prop_4": [
    3, 4, "str_elm_1", null, undefined, 5,
  ],
  "prop_5": {
    "func1": function () { return },
    "func2": function () { return 1 },
    "func3": function (n) { return n * 2},
    "func4": function (a, b, c) { return a + b + c },
    "func5": function (x) { return "Hello, " + x },
    "func6": function (c, a, b) {
      if (c) { return a } else { return b }
    },
  },
  "prop_6": {
    "call_host_1": () => {
      return global.globalObject1.prop_6.host_func_1()
    }
  },
  "prop_7": 3.14,
  "prop_8": [0, , 2, 3, , , 6],
}

global.Animal = function(name, age, isCat) {
  this.name = name
  this.age = age
  this.bark = () => {
    return isCat ? "nyan" : "wan"
  }
  this.isCat = isCat
  this.getIsCat = function() {
    return this.isCat
  }
}

const { startWasiTask } = require("../lib")

startWasiTask("./dist/PrimaryTests.wasm").catch(err => {
  console.log(err)
  process.exit(1)
});
