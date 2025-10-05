$fn=2400;
e=0.01;

outer=43;

module funnel() {
  cylinder(r1=30/2, r2=120/2, h=80);
}

module ring() {
  translate([0, 0, -9]) difference() {
    union() {
      translate([0, 0, 7]) cylinder(r=outer/2 + 5, h=2);
      cylinder(r=outer/2, h=7);
    }
    translate([0, 0, -0.5]) cylinder(r=outer/2 - 7, h=20);
  }
}

module foo() {
  difference() {
    ring();
    translate([0, 0, 0]) for (a = [0, 120, 240]) {
      rotate([0, 0, a]) hull() {
	translate([outer/2-2, 0, 0]) cylinder(r=2, h=1);
	translate([outer/2-5, 0, -10]) cylinder(r=2, h=1);
	translate([0, 0, -10-e]) cylinder(r=10, h=30);
      }
    }
    translate([0, 0, -9]) funnel();
  }
}

if (false) difference() {
  foo();
  rotate([0, 0, 30]) translate([0, 0, -50]) cube([100, 100, 100]);
}

foo();
