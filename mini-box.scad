$fn=90;
e=0.01;

module rbox(x, y, z, r=4) {
  hull() {
    for (t = [[-x/2,-y/2],[-x/2,y/2],[x/2,-y/2],[x/2,y/2]]) {
      translate(t) cylinder(r=r/2, h=z);
    }
  }
}

module open_box(wall=2) {
  difference() {
    minkowski() {
      rbox(20, 20, 10);
      cylinder(r=wall/2, h=e);
    }
    translate([0, 0, 2]) rbox(20, 20, 10);
  }
}

open_box();
