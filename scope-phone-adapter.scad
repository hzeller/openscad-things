$fn=128;

epsilon=0.05;
slack=0.7;

ocular_outer=37 + slack;
ocular_inner=33;
ocular_ring_thick=6 + slack;
eye_distance=15;

phone_inner=11.3;
phone_outer=7;
phone_wide=65 + slack;
phone_lens_radius=12/2;
cam_center=21;
phone_hood=cam_center + 4;

module ocular() {
        cylinder(r=ocular_inner/2, h=12);
	cylinder(r=ocular_outer/2, h=ocular_ring_thick);
	translate([0, -ocular_outer/2, 0]) cube([30, ocular_outer, 12 + ocular_ring_thick]);
	//translate([0, -ocular_outer/2, 0]) cube([30, ocular_outer, ocular_ring_thick]);
	
}

module tube() {
    cylinder(r1=phone_lens_radius, r2=ocular_inner/2, h=eye_distance + epsilon);
    translate([0, 0, eye_distance - 1]) cylinder(r=ocular_outer/2 + 2, h=ocular_ring_thick + 2);
}

module tube_hole() {
    translate([0, 0, -1]) cylinder(r=phone_lens_radius - 1, h=eye_distance);
    translate([0, 0, 1]) cylinder(r1=phone_lens_radius, r2=ocular_inner/2, h=eye_distance);
    translate([0, 0, eye_distance + epsilon]) cylinder(r=ocular_inner/2, h=ocular_ring_thick * 2);
}

module phone(rim=0) {
    hull() {
	translate([-cam_center, -phone_wide/2 - rim, 0]) cube([phone_hood, phone_wide + 2 * rim, phone_outer]);
	translate([-cam_center, -phone_wide/4 - rim, 0]) cube([phone_hood, phone_wide/2 + 2 * rim, phone_inner]);
    }
}


module phone_holder(rim=1) {
    difference() {
	translate([-rim, 0, rim]) phone(1);
	translate([0, 0, 0]) phone();
    }

    // cover for screen and cutout for the center.
    difference() {
	translate([-cam_center - rim, -phone_wide/2 - rim, 0]) cube([phone_hood, phone_wide + 2 * rim, rim]);
	translate([-phone_hood/2 + 4, 0, 0]) cube([phone_hood, phone_wide - 8, 5], center=true);
    }
}

module adapter() {
    difference() {
	union() {
	    // support material, essentially.
	    //translate([1, -8, 0]) cube([cam_center, 16, phone_outer + eye_distance]);
	    translate([1, -19.5, 0]) cube([cam_center, 1, eye_distance + ocular_ring_thick]);
	    translate([1, -8, 0]) cube([cam_center, 1, eye_distance]);
	    translate([1, 8, 0]) cube([cam_center, 1, eye_distance]);
	    translate([1, 19.5 - 1, 0]) cube([cam_center, 1, eye_distance + ocular_ring_thick]);
	    
	    
	    rotate([0, 0, 180]) translate([0, 0, -phone_inner]) phone_holder();
	    tube();
	}
	translate([0, 0, eye_distance]) ocular();
	tube_hole();
    }
}

translate([0, 0, cam_center + 1]) rotate([0, 90, 0]) adapter();
