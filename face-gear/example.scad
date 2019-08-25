use <../lib/BOSL/involute_gears.scad>
use <face-gear.scad>

// 66c2a5 fc8d62 8da0cb e78ac3 a6d854 ffd92f e5c494 b3b3b3

$fn = $preview ? 40 : 100;

// common
m = 1;
pressureAngle = 30;
clearance = 0.2;

// face gear
innerRadius = 37;
n1 = 2 * innerRadius / m;
teethLength = 8;

outerRadius = innerRadius + teethLength;
outerModule = 2 * outerRadius / n1;


color("#8da0cb")
rotate($t * 360 / n1, [0, 0, 1])
union() {
  faceGear(m, pressureAngle, n1, teethLength, clearance = 0);

  translate([0, 0, -2])
  union() {
    rotate_extrude(angle = 360)
    translate([innerRadius, 0])
    square([teethLength, 2]);

    linear_extrude(2)
    union() {
      difference() {
        circle(8);
        circle(2);
      }
      
      for (i = [0:2]) {
        rotate(i * 360 / 3, [0, 0, 1])
        translate([-2, 2])
        square([4, innerRadius]);
      }
    }
  }
}

// pinion
pinionRadius = 8;
n2 = 2 * pinionRadius / m;
mountingDistance = pinionRadius + adendum(outerModule) + clearance;

color("#b3b3b3")
translate([0, innerRadius + teethLength / 2, mountingDistance])
rotate(270, [1, 0, 0])
rotate($t * 360 / n2, [0, 0, 1])
rotate(360 / n2 / 2, [0, 0, 1])
difference() {
  gear(
    mm_per_tooth = PI * m,
    number_of_teeth = n2,
    thickness = teethLength,
    pressure_angle = pressureAngle,
    hole_diameter = 0
  );
  
  translate([0, 0, teethLength / 4])
  cube([pinionRadius / 2, pinionRadius / 2, teethLength / 2], center = true);
}


jointWidth = pinionRadius / 2 - clearance;
shaftLength = 20;
shaftRadius = jointWidth / 2;
jointLength = teethLength / 2 - clearance;

color("#a6d854")
translate([0, 0, -4])
union() {
  linear_extrude(2 - clearance)
  union() {
    circle(8);
    
    translate([-4, 0])
    square([8, outerRadius + 5]);
  }
  
  linear_extrude(4)
  circle(2 - clearance / 2);
  
  translate([0, outerRadius + 5, 0])
  difference() {
    linear_extrude(mountingDistance + pinionRadius + 4)
    translate([-4, 0])
    square([8, 6]);

    translate([0, 0, mountingDistance + 4])
    rotate(90, [1, 0, 0])
    cylinder(h = shaftLength, r = shaftRadius + clearance / 2, center = true);
  }
}

translate([0, outerRadius - pinionRadius / 4 + clearance, mountingDistance])
rotate(360 / n2 / 2, [0, 1, 0])
union(){
  cube([pinionRadius / 2 - clearance, jointLength, pinionRadius / 2 - clearance], center = true);

  translate([0, shaftLength / 2 + jointLength / 2, 0])
  rotate(90, [1, 0, 0])
  cylinder(h = shaftLength, r = shaftRadius, center = true);
}
