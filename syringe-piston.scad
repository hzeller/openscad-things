$fn=90;

piston_dia=16;
hole_dia=5;
piston_len=10;

inner_piston_dia=8;
total_piston_len=55;

outer_sphere=20;
inner_sphere=15;  // thumb;
ring=2;

difference() {
  cylinder(r=piston_dia/2, h=piston_len);
  cylinder(r=hole_dia/2, h=5);
  for (angle = [0:120:360]) {
    rotate([0, 0, angle]) cube([1.5, 16, 10], center=true);
  }
}

if (true) difference() {
  translate([0, 0, total_piston_len-7]) union() {
    cylinder(r1=inner_piston_dia/2, r2=(outer_sphere + ring)/2, h=8);
    translate([0, 0, 8]) cylinder(r=(outer_sphere + ring)/2, h=ring/2);
  }
  translate([0, 0, total_piston_len+5+outer_sphere/2+5]) sphere(r=outer_sphere);
}

if (true) translate([0, 0, total_piston_len+ring]) rotate_extrude() translate([outer_sphere/2, 0, 0]) circle(r=ring/2);

translate([0, 0, piston_len]) {
  cylinder(r1=piston_dia/2, r2=inner_piston_dia/2, h=5);
  cylinder(r=inner_piston_dia/2, h=total_piston_len-piston_len);
}
