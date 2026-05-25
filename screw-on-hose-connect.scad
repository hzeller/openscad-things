// Requires https://github.com/adrianschlatter/threadlib
use <threadlib/threadlib.scad>

$fn=90;
e=0.01;

bsp_type="G1/2";   // Adapt bsp_outer accordingly
bsp_outer_r=13;
bsp_thread_h=10;

transition=10;  // between BSP and barb connector

barb_narrow=10;
barb_step=2;
barb_long_transition=5;

wall=1.2;

module barb(d=barb_narrow, w=barb_step, h=barb_long_transition, count=4) {
  for (i=[0:count-1]) {
    translate([0, 0, i*h]) cylinder(d2=d, d1=d+w, h=h);
  }
}

module outlet() {
  translate([0, 0, bsp_thread_h+transition]) barb();
  translate([0, 0, bsp_thread_h]) cylinder(r1=bsp_outer_r, d2=barb_narrow+barb_step, h=transition+e);
}

module outlet_hollow() {
  translate([0, 0, bsp_thread_h]) {
    cylinder(d=10-2*wall, h=40);
    cylinder(r1=bsp_outer_r- wall-2, d2=12-2*wall-2, h=transition+e);
  }
}

module all() {
  difference() {
    outlet();
    outlet_hollow();
  }

  difference() {
    cylinder(r=bsp_outer_r, h=bsp_thread_h);
    tap(bsp_type, turns=10);
  }
}

all();
