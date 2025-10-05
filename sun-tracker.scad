use <gears.scad>

$fn=150;
e=0.02;
modul=1.5;
acrylic_thick=3;

ball_dia=3;

bearing_axle=8;
timer_ratio=4;
second_ratio=24 / timer_ratio;
gt2_ratio=24 / timer_ratio;
gt2_small=20;

timer_height=19;
timer_shoulder=2;
small_gear=15;
big_gear=timer_ratio * small_gear;
helix_angle=0;   // zero, so that we can lasercut.

inner_small=15;
plate_teeth=second_ratio * inner_small;
plate_rim=15;

plate_outer=176;

plate_distance=0.5 * (plate_teeth - inner_small) * modul;
pickup_distance=0.5 * (small_gear + big_gear) * modul;


module timer_poke(h=10) {
  cylinder(r=4.1/2, h=h);
  w=1.65;
  long=14;
  translate([-w/2, -long/2, 0]) cube([w, long, h]);

  w2=2.2;
  translate([-w2/2, -long/2, 0]) cube([w2, long, 1]);
}

module timer(h=timer_height) {
  color("silver") cylinder(r=52/2, h=h);
  color("black") timer_poke(h=h+5);
}

module timer_gear(h=5, shoulder=timer_shoulder) {
  render() translate([0, 0, shoulder]) difference() {
    union() {
      rotate([0, 0, 180/small_gear]) spur_gear(modul=modul, tooth_number=small_gear, width=h, bore=4, optimized=false, helix_angle=helix_angle);
      translate([0, 0, -shoulder]) cylinder(r=10, h=h+shoulder);
    }
    translate([0, 0, -shoulder-e]) timer_poke();
  }
}

module timer_pickup() {
  render() difference() {
    spur_gear(modul=modul, tooth_number=big_gear, width=5, bore=3.2, optimized=false, helix_angle=-helix_angle);
    cube([2, 8, 12], center=true);
  }
}

module plate_drive(h=5) {
  render() spur_gear(modul=modul, tooth_number=inner_small, width=h, bore=bearing_axle, optimized=false, helix_angle=helix_angle);
}

module plate_gear(h=acrylic_thick) {
  //cylinder(r=4, h=10); // axle indicator
  color("orange") render() {
    translate([0, 0, -e]) ring_gear(modul=modul, tooth_number=plate_teeth, width=h+2*e, rim_width=plate_rim, helix_angle=helix_angle);
    ring(inner=plate_outer-2*5.5, width=5.5, h=h);
  }
}

module ring(inner=100, outer=-1, width=5, h=acrylic_thick, punch=false) {
  offset = (outer < inner) ? width : outer - inner;
  if (punch) {
    center=(inner + offset)/2;
    for (a=[0:120:359]) rotate([0, 0, a]) translate([center, 0, -h]) cylinder(r=1, h=3*h);
  }
  else difference() {
      cylinder(r=inner/2 + offset, h=h);
      translate([0, 0, -e]) cylinder(r=inner/2, h=h+2*e);
      ring(inner, outer, width, h, true);
    }
}

module mount_plate(h=acrylic_thick) {
  module mount_hole() { cylinder(r=3.2/2, h=5); }
  mx = 30;
  my = 45;
  color("#f0f0ff", alpha=0.3) difference() {
    cylinder(r=plate_outer/2, h=h);
    translate([0, 0, -e]) cylinder(r=8/2, h=h+2*e);
    translate([mx, my, -e]) mount_hole();
    translate([mx, -my, -e]) mount_hole();
    translate([-mx, my, -e]) mount_hole();
    translate([-mx, -my, -e]) mount_hole();
    ring(inner=plate_outer-2*5.5, width=5.5, h=h, punch=true);
  }
}

module assembly() {
  translate([0, 0, timer_height]) timer_gear();
  translate([pickup_distance, 0, timer_height + timer_shoulder]) timer_pickup();
  translate([pickup_distance, 0, timer_height + timer_shoulder+5]) plate_drive();
  timer();
  translate([pickup_distance - plate_distance, 0, timer_height + timer_shoulder+5]) {
    plate_gear();
    //translate([0, 0, acrylic_thick]) mount_plate();
  }
}

module laser_cut() {
  plate_gear();
  timer_pickup();
  translate([plate_outer + 1, 0, 0]) mount_plate();
  translate([plate_outer + 1, plate_outer + 1, 0]) {
    ball_race();
    guide_ring();
  }
}
//assembly();
//timer_gear();
//timer_poke();

module ball_race() {
  union() {
    inner=plate_teeth * modul + modul*2;
    ring(inner, width=5);
    ring(inner+10+2*ball_dia, width=5);
    //translate([0, 0, -e]) ring(plate_teeth * modul + modul*2 + (plate_rim+ball_dia)/2, width=ball_dia, h=acrylic_thick+2*e);
  }
}

module guide_ring() {
  ring(inner=plate_outer-2*5.5, width=5.5);
}

//color("green") ball_race();

//translate([0, 0, -5]) plate_gear();

//projection() laser_cut();
assembly();
