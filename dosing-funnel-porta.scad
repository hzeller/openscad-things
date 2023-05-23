$fn=240;
e=0.01;

top_high=16;
bottom_high=12;

wall=2;
outer=70.5;
inner=58;
donut_thick=(outer-inner) / 2;

module donut() {
  difference() {
    rotate_extrude() translate([inner/2+donut_thick/2, 0]) circle(r=donut_thick/2);
    translate([0, 0, -5]) cylinder(r=outer, h=5);
  }
}

difference() {
  translate([0, 0, -bottom_high]) cylinder(r=outer/2+wall, h=top_high+bottom_high);
  translate([0, 0, -bottom_high-e]) cylinder(r=outer/2, h=bottom_high+2*e);
  translate([0, 0, -e]) cylinder(r1=inner/2+donut_thick/4, r2=outer/2, h=top_high+2*e);

  hull() {
    translate([0, 0, -bottom_high-e]) cube([outer+5, 28, e], center=true);
    translate([0, 0, 0]) cube([outer+5, 25, e], center=true);
  }
  donut();
}
