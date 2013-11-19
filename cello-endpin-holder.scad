$fn=96;
epsilon=0.02;
m4_hex_dia = 8.1;
m4_hex_thick=3.2;
m8_hex_dia = 15.6;
m8_hex_thick=6.3;
m8_washer_thickness=1.5;

pin_wall_thick=2;

// mine.
pin_r=3.2;  // Radius of the pin measured.
pin_straight_len = 9;
pin_tip_len = 4;

// vadda
/**/
pin_r = 8.5/2;
pin_straight_len = 12;
pin_tip_len = 7;
/**/

hinge_wall=2.5;      // min. wall around hinge.
hinge_axis_r=4.1;    // Axis of the hinge axle.
hinge_axis_len = 32; // screw

// We need at least this much height to roll securely
// around the axis.
hinge_rotate_block_height=2 * (hinge_axis_r + hinge_wall);

// The depth is at least the height, but also influenced by
// the thickness of what sits above.
hinge_rotate_block_depth=max(hinge_rotate_block_height, 2 * (pin_r + pin_wall_thick));
hinge_rotate_block_width=2*(pin_r + pin_wall_thick);

hinge_rotate_block_radius=sqrt(hinge_rotate_block_height*hinge_rotate_block_height
                      + hinge_rotate_block_depth*hinge_rotate_block_depth)/2;
hinge_center_z = hinge_rotate_block_radius + 2;
		  
hinge_mount_block_thick=(hinge_axis_len + m8_hex_thick - 2 * m8_washer_thickness - hinge_rotate_block_width)/2;

base_thick = 1.5;
base_dia = hinge_axis_len + m8_hex_thick + 10;

// securing screw.
screw_length = 9;
screw_wall_thick = 0.5;
screw_offset = 3;

module m_screw(radius, hex_radius, hex_thick, head_diameter, slen, extension) {
    cylinder(r=radius, h=slen + epsilon);
    translate([0, 0, slen]) cylinder(r=head_diameter, h=hex_thick + extension);
    translate([0, 0, -extension]) cylinder(r=hex_radius, h=hex_thick + extension, $fn=6);
}

module screw_m4(slen, extension=0) {
    m_screw(4.4/2, m4_hex_dia/2, 2, 7/2, slen, extension);
}

module screw_m8(slen, extension=0) {
    m_screw(8.4/2, m8_hex_dia/2, 6, 16.5/2, slen, extension);
}

module pin(d=2 * pin_r) {
    translate([0, 0, pin_tip_len-epsilon]) cylinder(r=d/2, h=pin_straight_len + 2 * epsilon);
    cylinder(r1=0, r2=d/2, h=pin_tip_len);  // pin.
    translate([0, 0, pin_tip_len + pin_straight_len - epsilon]) cylinder(r=3 * d, h=4);
}

module pin_holder(r=pin_r) {
    assign(block_h = hinge_rotate_block_height,
	   block_d = hinge_rotate_block_depth,
	   pin_outer_radius = r + pin_wall_thick,
           pin_height = pin_straight_len + pin_tip_len + pin_wall_thick) {
	difference() {
	    union() {
		translate([-(block_d)/2, -pin_outer_radius, 0]) cube([block_d, 2 * pin_outer_radius, block_h]); // hinge block
		translate([0, 0, block_h]) cylinder(h=pin_height - pin_outer_radius, r=pin_outer_radius);  // main cylinde
		translate([0, 0, block_h + pin_height - pin_outer_radius]) sphere(r=pin_outer_radius);
		translate([0, 0, block_h + pin_tip_len + screw_offset]) rotate([0, 90, 0]) cylinder(r=m4_hex_dia/2 + screw_wall_thick, h=screw_length + pin_r);
	    }
	    translate([0, 0, block_h]) pin(d=2*r);  // make space for the pin
	    #translate([pin_r, 0, block_h + pin_tip_len + screw_offset]) rotate([0, 90, 0]) screw_m4(screw_length, 3); // space for screw
	    translate([0, 30, block_h/2]) rotate([90, 0, 0]) cylinder(r=hinge_axis_r, h=60); // hinge hole
	}
    }
}

module baseplate(dist=hinge_rotate_block_width + 2*m8_washer_thickness) {
    difference() {
	hull() {
	    // We want the mount blocks blend in with the base-plate
	    cylinder(r=base_dia/2 , h=base_thick);
	    translate([dist/2, 0, hinge_center_z + base_thick]) rotate([0, 90, 0]) cylinder(r=m8_hex_dia/2 + hinge_wall, h=hinge_mount_block_thick);
	    translate([-dist/2, 0, hinge_center_z + base_thick]) rotate([0, -90, 0]) cylinder(r=m8_hex_dia/2 + hinge_wall, h=hinge_mount_block_thick);
	}

	// We substract the space the rotating block would need.
	translate([-dist/2, 0, hinge_center_z + base_thick]) scale([1, 1.8, 1]) rotate([0, 90, 0]) cylinder(r=hinge_center_z, h=dist);

	// .. also the space above the axis should generally be free.
	translate([-dist/2, -base_dia/2, hinge_center_z + base_thick - hinge_axis_r]) cube([dist, base_dia, base_dia]);


	// On the side with the screwhead, we want to have one washer
	#translate([-(hinge_axis_len + 1 * m8_hex_thick + 1 * m8_washer_thickness)/2, 0, base_thick + hinge_center_z]) rotate([0, 90, 0]) screw_m8(hinge_axis_len, 10);
    }    
}

module display_mount() {
    baseplate();
    color("red") translate([0, 0, base_thick + hinge_center_z - hinge_rotate_block_height/2]) rotate([0, 0, 90]) pin_holder();
}

module print_endpin_holder() {
    baseplate();
    translate([0, base_dia/2 + 10, 0]) rotate([0, 0, -90]) pin_holder(r=pin_r);
}

module xray() {
    difference() {
	baseplate();
	translate([0, 0, 18]) cube([50, 50, 10], center=true);
    }
}

//xray();
//baseplate();
//display_mount();
//print_endpin_holder();
pin_holder(r=pin_r);
//screw_m4(screw_length);
//translate([pin_r, 0, 0]) rotate([0, 90, 0]) screw_m4(screw_length);