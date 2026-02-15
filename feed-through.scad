// A screwable feed-through grommet

$fn=90;
e=0.01;

include <threads-inc.scad>

through_radius=8;    // curvature to minimize rubbing
through_hole=11;     // center hole to feed through cable
wall_thickness=1.8;  // wall we want to go through
drill_hole=26;       // drill hole through the wall.
wobbles=5;

// Reduce roundness at the bottom of the print.
flat_part=0.5;       // for printing upside down.

// Screw-thread parameters
pitch=2;
tooth_angle=60;  // so that it can be easily printed.
screw_tolerance=0.15;

module wobble_grip(wobbles=8, inner=50, wobble_thick=1) {
  wobble_resolution=18;
  f=wobble_thick/2;
  segment_angle=360/wobbles;
  points = [
	    for (w = [0 : segment_angle : 360-segment_angle])
	      for (i = [0 : 1/wobble_resolution : 1+e])
		[
		 (inner + f*(sin(i*360)+1)) * cos(w+segment_angle*i),
		 (inner + f*(sin(i*360)+1)) * sin(w+segment_angle*i)
		 ]
	    ];
  polygon(points);
}

module base_doughnut() {
  intersection() {
    rotate_extrude() translate([through_hole/2+through_radius, 0, 0]) circle(r=through_radius);
    translate([0, 0, -through_radius]) linear_extrude(h=2*through_radius) wobble_grip(wobbles=wobbles, wobble_thick=4, inner=through_hole/2+through_radius+3);
  }
}

module doughnut_in_wall() {
  translate([0, 0, -wall_thickness/2]) difference() {
    base_doughnut();
    feed_wall();
  }
}
module feed_wall() {
  w=through_hole+4*through_radius;
  difference() {
    cube([w, w, wall_thickness], center=true);
    translate([0, 0, -wall_thickness/2-e]) {
      cylinder(r=drill_hole/2, h=wall_thickness+2*e);
    }
  }
}

module tube(outer=20, inner=10, h=5, tolerance_extra=0) {
  difference() {
    //cylinder(r=outer/2, h=h);
    ScrewThread(outer_diam=outer, height=h, pitch=pitch, tooth_angle=tooth_angle, tolerance=screw_tolerance+tolerance_extra);
    translate([0, 0, -e]) cylinder(r=inner/2, h=h+2*e);
  }
}

module feed_part(lower=true, extra=0) {
  module block(bs=100) {
    translate([-bs/2, -bs/2, 0]) cube([bs, bs, bs]);
  }

  if (lower) {
    difference()  {
      doughnut_in_wall();
      block();
      translate([-50, -50, -100-through_radius-wall_thickness/2+flat_part]) cube([100, 100, 100]);
    }
    translate([0, 0, 0]) tube(outer=drill_hole-2+extra, inner=drill_hole-2-6-extra, h=through_radius-wall_thickness-2+extra, tolerance_extra=extra);  // fudge
  } else {
    intersection() {
      doughnut_in_wall();
      block();
    }
  }
}

module with_hole() {
  difference() {
    feed_part(lower=false);
    feed_part(lower=true, extra=0.15);
  }
}

module assemble() {
  difference() {
    union() {
      feed_part(lower=true);
      translate([0, 0, 0]) color("red") render() with_hole();
    }
    translate([0, -100, -40]) cube([100, 100, 100]);
  }
  translate([0, 0, -wall_thickness/2]) color("#ffffff50") feed_wall();
}
//tube(ouer=drill_hole, inner=drill_hole-3);

module print() {
  translate([through_hole+4*through_radius, 0, through_radius+wall_thickness/2-flat_part]) {
    feed_part(lower=true);
  }
  with_hole();
}

//print();
rotate([20, 0, 10]) assemble();  // little angle so that image looks better
