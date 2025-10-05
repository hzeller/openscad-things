$fn=90;
e=0.01;

wall=1;
front_nozzle=30.75;
front_thick=4;

module nozzle(len=35, wall = wall, punch=false) {
  cone_factor = 1.5 / 30;
  module cyl(extra=0) {
    cylinder(r1=(front_nozzle + (len * cone_factor))/2 + extra,
	     r2=front_nozzle/2 + extra,
	     h=len);
  }

  translate([0, 0, -len]) if (punch) {
    cyl();
  } else {
    difference() {
      cyl(wall);
      translate([0, 0, len+e]) nozzle(len+2*e, wall, punch=true);
    }
  }
}


module front(extra=0, thick=front_thick, angle=15) {
  wide = front_nozzle+15;
  front_extend=8;
  elongate=2;
  hull() {
    translate([0, 0, 0]) cylinder(r=front_nozzle/2, h=e);
    translate([0, 0, -15]) cylinder(r=front_nozzle/2, h=e);
    rotate([angle, 0, 0]) {
      translate([0, -5, thick]) cylinder(r=front_nozzle/2-5, h=e);
      translate([-wide/2, -front_nozzle/2-extra+e-elongate, 0]) cube([wide, e+extra, thick]);
    }
  }

  if (true) hull() {
    rotate([angle, 0, 0]) {
      translate([0, -5, thick]) cylinder(r=front_nozzle/2-5, h=e);
      translate([-wide/2, -front_nozzle/2-front_extend-extra-elongate, 0]) cube([wide, front_extend+extra, thick]);
    }
  }
}

module inner() {
  nozzle(punch=true);
  front(extra=1);
}

module outer() {
  nozzle(punch=false);
  minkowski() {
    sphere(r=wall);
    render() front();
  }
}

if (true) difference() {
  outer();
  inner();
}

//front();
