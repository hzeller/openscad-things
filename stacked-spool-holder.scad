// Stacked spool holders to hold filament spools horizontally. Allows
// for various sizes.
//
// Provides a bushing that can be firmly screwed down and allows to rotate
// around.
//
// To hold the spools, it can have as well a little 'spring' holding it, but
// real live shows that this is not really needed (if you want it, set
// the "spring_extra" variable.
//
// (c) h.zeller@acm.org Creative Commons license BY-SA

$fn=128;

epsilon=0.1;
clearance=0.6;     // Spacing around the screwed down part to allow free rotation

// sprint is overrated :)
spring_extra=0;    // How much diameter the spring provides; 0 for no spring.


// Diameters of each spool holder in the stack. Enter all the different spool
// sizes you have here. You want the biggest first :)
diameters=[51 - spring_extra,
           32 - spring_extra];

holder_height=12;      // height of each stack.
transition=-1;          // transitioning between two stacks

bottom_width=diameters[0] + 25;
wall_thickness=1;
foot_thickness=4;    // Should be high enough to have the spool over over the Type-A mount screws
mount_hole=3 + 0.2;  // M3 + fudge

mount_peg_top=diameters[len(diameters)-1] - 3;
mount_peg_bottom=mount_peg_top - 2*mount_hole;

spring_width=8;
spring_springiness_thick=0.8;
mount_angle=120;     // Spring every n of these.

module spring(spring_r) {
    translate([0, spring_width/2, 0]) rotate([90, 0, 0])
    difference() {
	cylinder(r=spring_r, h=spring_width);
	translate([0, 0, -epsilon]) cylinder(r=spring_r - spring_springiness_thick, h=spring_width + 2*epsilon);
	translate([-spring_r-epsilon, -spring_r-epsilon, -epsilon]) cube([spring_r + epsilon, 2 * (spring_r + epsilon), spring_width + 2 * epsilon, ]);
    }
}

// This fits into the hole of the spool.
module holder(hole_diameter, holder_height, angle_offset) {
    difference() {
	union() {
	    cylinder(r=hole_diameter/2, h=holder_height);
	    if (spring_extra > 0) {
		for (a = [0:mount_angle:360]) {
		    rotate([0, 0, a + angle_offset]) translate([hole_diameter/2 - holder_height + spring_extra/2, 0, holder_height/2])
		    spring(holder_height-0.2);
		}
	    }
	}

	// Get rid spring stuff where we don't need it.
	rotate([180,0,0]) cylinder(r=hole_diameter, h=3*holder_height);
	translate([0,0,holder_height]) cylinder(r=hole_diameter, h=3*holder_height);
	// And remove the inner volume.
	translate([0,0,-epsilon]) cylinder(r=hole_diameter/2 - wall_thickness, h=holder_height + 2*epsilon);
    }
}

module holder_stack() {
    for (i=[0:len(diameters)-1]) {
	color("blue") translate([0, 0, (holder_height + transition) * i])
	    holder(diameters[i], holder_height, (i % 2) * 60);
	if (i > 0) {
	    difference() {
		translate([0,0, (i-1) * (holder_height + transition)]) cylinder(r1=diameters[i-1]/2, r2=diameters[i]/2, h=holder_height + transition);
		translate([0,0, (i-1) * (holder_height + transition) - epsilon]) cylinder(r1=diameters[i-1]/2 - wall_thickness, r2=diameters[i]/2 - wall_thickness, h=holder_height + transition + 2 * epsilon);
	    }
	}
    }
}

module mount_peg(with_clearance=0) {
    cylinder(r=mount_peg_bottom/2 + with_clearance, h=2*foot_thickness/3 + epsilon);
    translate([0,0,2 * foot_thickness/3]) cylinder(r=mount_peg_top/2 + with_clearance, h=1*foot_thickness/3 + clearance);
}

module drilled_mount_peg() {
    difference() {
	mount_peg();
	translate([0,0,-epsilon]) cylinder(r=mount_hole/2, h=foot_thickness + clearance + 2*epsilon);
    }
}

// Bottom plate with mounting hole.
module bottom_plate() {
    // plate.
    difference() {
	cylinder(r=bottom_width/2, h=foot_thickness);
	translate([0,0,-clearance]) mount_peg(clearance);
	translate([0,0,+epsilon]) mount_peg(clearance);
    }
}

module print() {
    color("red") bottom_plate();
    translate([0, 0, foot_thickness - epsilon]) holder_stack();
    translate([bottom_width/2 + mount_peg_top/2 + 5,0,foot_thickness + clearance]) rotate([0,180,0]) drilled_mount_peg();
}

module xray() {
    difference() {
	union() {
	    color("red") bottom_plate();
	    translate([0, 0, foot_thickness - epsilon]) holder_stack();
	    drilled_mount_peg();
	}
	translate([0,0,-epsilon]) cube([60, 60, 100]);
    }
}

//xray();
print();
