const PegCalc=require("./PegCalc.js");
const JisonCalc=require("./JisonCalc.js");

var testExpr = "-1.25 + 23.56*10*(10 + 4/(2-1.5)) + 9/3.2*8"; // 4262.5
var testTimes = 100000;

// 解析结果验证
JisonCalc.parse(testExpr); // 4262.5
PegCalc.parse(testExpr);   // 4262.5
eval(testExpr);            // 4262.5

// jison测试
console.log("jison测试:")
console.time();
for(var i = 0; i < testTimes; i ++) {
  JisonCalc.parse(testExpr);
};
console.timeEnd(); // 2456.34814453125ms

// PEG.js测试
console.log("PEG.js测试:")
console.time();
for(var i = 0; i < testTimes; i ++) {
  PegCalc.parse(testExpr);
};
console.timeEnd(); // 1191.030029296875ms
