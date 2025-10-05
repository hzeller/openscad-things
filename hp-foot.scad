$fn=80;
e=0.01;

// mount hole
hole_dist=25.4 * 0.75;
hole_dia=25.4/4;
bottom_foot_dia=25;
poke_deep=4;

height=146 - 126;

module mount_pins(r=hole_dia/2, h=poke_deep) {
  translate([0, 2, 0]) {
    translate([-hole_dist/2, -hole_dist/2, 0]) cylinder(r=r, h=h);
    translate([+hole_dist/2, -hole_dist/2, 0]) cylinder(r=r, h=h);
    translate([0, hole_dist/2, 0]) cylinder(r=r, h=h);
  }
}


hull() {
  mount_pins(r=hole_dia/2+2, h=e);
  translate([0, 0, height]) cylinder(r=bottom_foot_dia/2, h=e);
}
translate([0, 0, -poke_deep+e]) mount_pins();
