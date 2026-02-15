$fn=90;
e=0.01;
include <threads-inc.scad>

wall=1;
pitch=2;
tooth_angle=60;  // so that it can be easily printed.

container_outer=22;
container_h=20;
container_lid=8;

container_inner=container_outer - 2*wall - 1;
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

// Cone to create a champfer
module cone(r, flip=false) {
  // Make it ~45 degrees.
  scale([1, 1, flip ? -1 : 1]) {
    cylinder(r1=r, r2=2*r, h=r);
    translate([0, 0, r]) cylinder(r=2*r, h=5*r);
  }
}

module container_lid() {
  ScrewHole(outer_diam=container_inner, height=container_lid-wall, pitch=pitch,
	    tooth_angle=tooth_angle, tolerance=screw_tolerance) {
    intersection() {
      linear_extrude(height=container_lid) wobble_grip(inner=container_outer/2);
      // Round over the edges.
      cone(container_outer/2);
      translate([0, 0, container_lid]) cone(container_outer/2, flip=true);
    }
  }
}

module container_base() {
  difference() {
    intersection() {
      union() {
	cylinder(r=container_outer/2, h=container_h-container_lid);
	translate([0, 0, container_h-container_lid]) {
	  ScrewThread(outer_diam=container_inner, height=container_lid-wall, pitch=pitch, tooth_angle=tooth_angle, tolerance=screw_tolerance);
	}
      }
      translate([0, 0, container_h-wall]) cone(r=container_inner/2-1, true);
    }
    translate([0, 0, wall]) cylinder(r=container_inner/2 - 2*wall, h=container_h);
  }
}

container_base();
rotate([180, 0, 0]) translate([-container_outer-5, 0, -container_lid]) container_lid();
