$fn=360;
e=0.02;

inner=8*25.4;
extra=30;

height=20;
finger_r=7;

module wedge(height=height) {
  angle=40;
  r=inner/2+extra;
  intersection() {
    linear_extrude(height=height) polygon([[0, 0], [r, 0], [r, tan(angle)*r]]);
    translate([inner/2+extra, inner/4, 0])  cylinder(r=inner/4, h=30);
    difference() {
      cylinder(r=inner/2+extra, h=height);
      translate([extra-2, 0, -e]) cylinder(r=inner/2, h=50);
    }
  }
  round_r=5.08;
  r2=inner/2+extra-round_r;
  translate([cos(angle)*r2, sin(angle)*r2, 0]) cylinder(r=round_r, h=height);
}



difference() {
  wedge();
  translate([0, 0, finger_r+(height-(2*finger_r))/2])
    rotate([0, 0, 35]) rotate([0, 90, 0])
    cylinder(r=finger_r, h=2*inner);
}
translate([inner/2+extra, 0, 0]) cylinder(r=5, h=0.4);
