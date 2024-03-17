$fn=240;
e=0.01;

top_high=16;

wall=2;

// Gaggia
outer=70.5;
inner=58;
bar_width=25;  // Screw nupsi
bar_count=2;
bottom_high=12;

// Some other filter.
//outer=62.8;
//inner=53.7;
//bar_width=21;
//bar_count=3;
//bottom_high=8;

bar_angle = 360 / bar_count;

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

  for (a = [0:bar_angle:360]) rotate([0, 0, a]) {
      hull() {
	translate([outer/2, 0, -bottom_high-e]) cube([outer/2, bar_width+3, e], center=true);
	translate([outer/2, 0, 0]) cube([outer/2, bar_width, e], center=true);
      }
    }
  donut();
}
