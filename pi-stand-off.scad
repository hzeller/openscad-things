$fn=40;
e=0.01;

hole_dia=3.2;
outer=5.5;

module t(h=3.2) {
  difference() {
    cylinder(r=outer/2, h=h);
    translate([0, 0, -e]) cylinder(r=hole_dia/2, h=h+2*e);
  }
}

w=8;
translate([w, 0, 0]) t();
translate([-w, 0, 0]) t();
translate([0, w, 0]) t();
translate([0, -w, 0]) t();
