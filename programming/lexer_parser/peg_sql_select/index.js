const selectParser=require("./sql_select.js");
const sqls=[
      'select * from user;',
      'select name from user;',
      'select id from user;'
].join("")
console.log(selectParser.parse(sqls))
