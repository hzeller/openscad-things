$fn=60;
e=0.01;

clearance=0.25;
wide=15;
outer_wide=wide + 5;
long=15;
thick=4;
hole_dia=thick * 0.7;

module hinge_part(clearance=0, flat_front=false) {
  w = wide + 2*clearance;
  t = thick + 2*clearance;
  translate([0, 0, -clearance]) difference() {
    hull() {
      cylinder(r=t/2, h=wide+2*clearance);
      translate([long, -t/2, 0]) cube([e, t, w]);
      if (flat_front) {
	translate([-t/2, -t/2, 0]) cube([e, t, w]);
      }
    }
    translate([0, 0, -e]) cylinder(r=hole_dia/2-clearance, h=w+2*e);
  }
}

module assembly() {
  if (true) difference() {
      color("red") translate([-long+2, -thick/2+e, -(outer_wide-wide)/2]) cube([long, thick-2*e, outer_wide]);
      hinge_part(clearance=clearance, flat_front=true);
    }

  rotate([0, 0, 0]) hinge_part();
}

module xray() {
  difference() {
    assembly();
    translate([-5, -10, 6]) cube([100, 100, 100]);
  }
}

assembly();
