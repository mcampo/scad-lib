module example() {
  m = 1;
  pressureAngle = 28;

  R1 = 20;
  n1 = 2 * R1 / m;
  teethLength = 5;

  faceGear(m, pressureAngle, n1, teethLength);
}
example();

module faceGear(m, pressureAngle, numberOfTeeth, teethLength, clearance = undef, backlash = 0.0) {
  innerRadius = numberOfTeeth * m / 2;
  outerRadius = innerRadius + teethLength;
  outerModule = 2 * outerRadius / numberOfTeeth;

  for (i = [0:numberOfTeeth-1]) {
    rotate(i * 360 / numberOfTeeth, [0, 0, 1])
    translate([0, innerRadius, 0])
    faceTooth(m, outerModule, pressureAngle, teethLength, clearance, backlash);
  }  
}

module faceTooth(m, outerModule, pressureAngle, toothLength, clearance = undef, backlash = 0.0) {
  hull(){
    rotate(90, [1, 0, 0])
    linear_extrude(0.01)
    innerToothProfile(m, pressureAngle, clearance, backlash);

    translate([0, toothLength, 0])
    rotate(90, [1, 0, 0])
    linear_extrude(0.01)
    outerToothProfile(m, outerModule, pressureAngle, clearance, backlash);
  }
}

module innerToothProfile(m, pressureAngle, clearance = undef, backlash = 0.0) {  
  pitch = PI * m;
  a = adendum(m);
  d = dedendum(m, clearance);
  th = a + d;
  xa = a * sin(pressureAngle);
  xd = d * sin(pressureAngle);

  polygon(
    points=[
      [-pitch * 0.25 + backlash - xd, 0],
      [-pitch * 0.25 + backlash + xa, th],
      [pitch * 0.25 - backlash - xa, th],
      [pitch * 0.25 - backlash + xd, 0]
    ]
  );
}

module outerToothProfile(m, outerModule, pressureAngle, clearance = undef, backlash = 0.0) {  
  pitch = PI * outerModule;
  a = adendum(m);
  d = dedendum(m, clearance);
  th = a + d;

  polygon(
    points=[
      [-pitch * 0.5 + backlash, 0],
      [0, th],
      [pitch * 0.5 - backlash, 0]
    ]
  );
}

function adendum(m) = m;
function dedendum(m, clearance = undef) = (clearance==undef)? (1.25 * m) : (m + clearance);
