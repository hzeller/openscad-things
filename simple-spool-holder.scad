// Stack of spool holders.
$fn=128;

epsilon=0.1;

spring_extra=3;    // How much diameter the spring adds

// Diameters of each spool holder in the stack. You want the biggest first :)
diameters=[55 - spring_extra,
          32 - spring_extra];

holder_height=14;      // height of each stack.
transition=4;          // transitioning between two stacks

bottom_width=diameters[0] + 20;
wall_thickness=1;
foot_thickness=5;
mount_hole=3;

spring_width=8;
spring_springiness_thick=0.5;
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
	    for (a = [0:mount_angle:360]) {
		rotate([0, 0, a + angle_offset]) translate([hole_diameter/2 - holder_height + spring_extra/2, 0, holder_height/2])
		spring(holder_height-0.2);
	    }
	}

	// bore hole.
	//translate([0,0,-epsilon]) cylinder(r=hole_diameter/2 - wall_thickness, h=holder_height + 2 * epsilon);

	// Get rid spring stuff where we don't need it.
	rotate([180,0,0]) cylinder(r=hole_diameter, h=3*holder_height);
	translate([0,0,holder_height]) cylinder(r=hole_diameter, h=3*holder_height);
    }
}

module holder_stack() {
    for (i=[0:len(diameters)-1]) {
	color("blue") translate([0, 0, (holder_height + transition) * i])
	    holder(diameters[i], holder_height, (i % 2) * 60);
	if (i > 0) {
	    translate([0,0, holder_height + (i-1) * (holder_height + transition)]) cylinder(r1=diameters[i-1]/2, r2=diameters[i]/2, h=transition);
	}
    }
}

module hollow_stack() {
    difference() {
	holder_stack();
	// Hollow out with a cone on the inside.
	cylinder(r1=diameters[0] / 2 - wall_thickness,
	         r2=diameters[len(diameters)-1]/2 - wall_thickness,
		 h=(len(diameters)-1) * (holder_height + 5));

	// The last element in the stack has constant diameter.
	translate([0, 0, (len(diameters)-1) * (holder_height + 5) - epsilon])
	  cylinder(r=diameters[len(diameters)-1]/2 - wall_thickness,
	           h = holder_height + 2 * epsilon);
    }
}

module print() {
    // Bottom plate with mounting hole.
    difference() {
        union() {
           translate([0, 0, foot_thickness - epsilon]) hollow_stack();
	   color("red") cylinder(r=bottom_width/2, h=foot_thickness);
        }
	translate([0,0,-epsilon]) cylinder(r=mount_hole/2, h=foot_thickness + 2 * epsilon);
    }    
}

//holder(30, 14, 0);
print();


