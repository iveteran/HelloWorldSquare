//var math = require('mathjs');
//
function great_circle(lon1, lat1, lon2, lat2) {
    let radius = 3956.0;
    let pi = 3.14159265;
    let x = pi/180.0;
    let a,b,theta,c;

    a = (90.0-lat1)*(x);
    b = (90.0-lat2)*(x);
    theta = (lon2-lon1)*(x);
    c = Math.acos((Math.cos(a)*Math.cos(b)) + (Math.sin(a)*Math.sin(b)*Math.cos(theta)));
    return radius*c;
}

var NUM = 500000;
var x = 0;
for (var i=0; i <= NUM; i++)
    x = great_circle(-72.345, 34.323, -61.823, 54.826);

//console.log(x);
