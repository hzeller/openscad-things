$fn=96;
epsilon=0.02;

hinge_axle_use_dowel=true;       // Use dowel instead of screw ?
hinge_axle_dowel_diameter = 10;  // used when dowel; otherwise screw m8 is used.
pin_secure_screw=true;
base_plate_addon_dia = 5;

m3_hex_dia = 6.3 + 1;
m3_head_dia = m3_hex_dia;
m3_hex_thick=2.3;
m3_head_thick=m3_hex_thick;

m8_hex_dia = 15.6;
m8_head_dia = m8_hex_dia;
m8_hex_thick=6.3 + 0.2;
m8_head_thick=m8_hex_thick;
m8_washer_thickness=1.65;
m8_washer_thickness=0.8;   // thinner test.

pin_wall_thick=2;  // Wall around pin.

// cello pin #1
pin_r=3.2;  // Radius of the pin measured.
pin_straight_len = 9;
pin_tip_len = 4;
pin_collar_r=6+0.5;
screw_offset = 4;

// cello pin #2
/*
pin_r = 8.6/2 + 0.2;  // add some fudge.
pin_straight_len = 13;
pin_tip_len = 8.5;
pin_collar_r=7+0.5;
screw_offset = 6;
*/

hinge_wall=2.6;      // min. wall around hinge.
hinge_axle_mount_hiding = 0.5;  // hiding screws with at least this amount overhang.

hinge_axle_len = hinge_axle_use_dowel ? 25 : 33; // dowel
hinge_axle_r = (hinge_axle_use_dowel ? hinge_axle_dowel_diameter/2 : 8/2) + 0.15;

// Radius of the ring holding the axle (also the radius of the end-spheres).
// For screws, we need to house the head and nut at the end. The Dowel needs
// much less space.
hinge_axle_end_support = (hinge_axle_use_dowel
    ? hinge_axle_r + hinge_wall
    : m8_head_dia/2 + hinge_wall);

// We need at least this much height to roll securely
// around the axle.
hinge_rotate_block_height=2 * (hinge_axle_r + hinge_wall);

// The depth is at least the height, but also influenced by
// the thickness of what sits above.
hinge_rotate_block_depth=max(hinge_rotate_block_height, 2 * (pin_r + pin_wall_thick), 2 * pin_collar_r);
hinge_rotate_block_width=max(2*(pin_r + pin_wall_thick), 2 * pin_collar_r);

// The radius the square rotate block consumes when rotating around
// its axle.
hinge_rotate_block_radius=sqrt(hinge_rotate_block_height*hinge_rotate_block_height
    + hinge_rotate_block_depth*hinge_rotate_block_depth)/2;
// The axle is high enough to let a bit room to rotate.
hinge_center_z = hinge_rotate_block_radius + 2;

// We keep the mount block a bit smaller, because we do have a sphere end-cap
hinge_mount_block_factor = 0.5;
hinge_mount_block_thick=hinge_mount_block_factor * ((hinge_axle_len + m8_head_thick - 2 * m8_washer_thickness - hinge_rotate_block_width)/2 + hinge_axle_mount_hiding);

base_thick = 2;
// The axle_end_support are the spheres at the end.
base_dia = hinge_axle_len + max(hinge_axle_mount_hiding, 2 * hinge_axle_end_support) + base_plate_addon_dia;

// pin-securing screw.
screw_length = 5;
screw_wall_thick = 1.2;

module m_screw(radius, hex_dia, hex_thick, head_dia, head_thick, slen, extension) {
    cylinder(r=radius, h=slen + epsilon);
    cylinder(r=hex_dia/2, h=hex_thick, $fn=6);  // nut.
    translate([0, 0, slen]) cylinder(r=head_dia/2, h=head_thick); // head

    // If we draw the extensions as seprate objects, we see the separating
    // lines in the '#' view
    color("green") {
	translate([0, 0, slen + head_thick - epsilon]) cylinder(r=head_dia/2, h=extension);
	translate([0, 0, -extension]) cylinder(r=hex_dia/2, h=extension + epsilon, $fn=6);
    }
}

module screw_m3(slen, extension=0) {
    m_screw(3.4/2, m3_hex_dia, m3_hex_thick, m3_head_dia, m3_head_thick, slen, extension);
}

module axle_space(slen, extension=0) {
    if (hinge_axle_use_dowel) {
	cylinder(r=hinge_axle_dowel_diameter/2, h=slen + extension);
    } else {
	m_screw(8.4/2, m8_hex_dia, m8_hex_thick, m8_head_dia, m8_head_thick, slen, extension);
	color("green") translate([0, 0, slen-m8_washer_thickness+epsilon]) cylinder(r=m8_head_dia/2, h=m8_washer_thickness);

    }
}

module pin(d=2 * pin_r) {
    translate([0, 0, pin_tip_len-epsilon]) cylinder(r=d/2, h=3 * pin_straight_len);
    cylinder(r1=0, r2=d/2, h=pin_tip_len);  // pin.
    // collar:
    translate([0, 0, pin_tip_len + pin_straight_len - epsilon]) cylinder(r=pin_collar_r + epsilon, h=4);
}

module pin_holder(r=pin_r) {
    assign(block_h = hinge_rotate_block_height,
	   block_d = hinge_rotate_block_depth,
	   pin_outer_radius = r + pin_wall_thick,
           pin_height = pin_straight_len + pin_tip_len) {
	difference() {
	    union() {
		translate([-(block_d)/2, -hinge_rotate_block_width/2, 0]) cube([block_d, hinge_rotate_block_width, block_h]); // hinge block
		hull() {
		    // The first two blocks outline the real hinge block, so that we get a smooth
		    // transition to the top part with the hull, but still have square flat sides.
		    translate([-(block_d)/2, -hinge_rotate_block_width/2, block_h-1]) cube([block_d, hinge_rotate_block_width, 1]);
		    translate([(block_d)/2-epsilon, -hinge_rotate_block_width/2, 0]) cube([epsilon, hinge_rotate_block_width, block_h]);

		    translate([0, 0, block_h]) cylinder(h=pin_height, r=pin_outer_radius);  // main cylinder
		    translate([0, 0, block_h + pin_height - 2]) cylinder(h=2, r=pin_collar_r);
		    if (pin_secure_screw) {
			translate([0, 0, block_h + pin_tip_len + screw_offset]) rotate([0, 90, 0]) cylinder(r=m3_head_dia/2 + screw_wall_thick, h=screw_length + pin_r);
		    }
		}
	    }
	    translate([0, 0, block_h]) pin(d=2*r);  // make space for the pin
	    if (pin_secure_screw) {
		translate([pin_r, 0, block_h + pin_tip_len + screw_offset]) rotate([0, 90, 0]) screw_m3(screw_length, 5); // space for screw
	    }
	    translate([0, 30, block_h/2]) rotate([90, 0, 0]) cylinder(r=hinge_axle_r, h=60); // hinge hole
	}
    }
}

module baseplate(dist=hinge_rotate_block_width + 2*m8_washer_thickness) {
    difference() {
	hull() {
	    // hull: We want the mount blocks blend in with the base-plate
	    translate([0, 5, 0]) scale([1, 1.2, 1]) cylinder(r=base_dia/2 , h=base_thick);  // base plate.
	    // TODO: make these end-parts separate modules.
	    translate([dist/2, 0, hinge_center_z + base_thick]) rotate([0, 90, 0]) union() { cylinder(r=hinge_axle_end_support, h=hinge_mount_block_thick);
         translate([0, 0, hinge_mount_block_thick]) sphere(r=hinge_axle_end_support);
	}
	    translate([-dist/2, 0, hinge_center_z + base_thick]) rotate([0, -90, 0]) union() { cylinder(r=hinge_axle_end_support, h=hinge_mount_block_thick);
	      translate([0, 0, hinge_mount_block_thick]) sphere(r=hinge_axle_end_support);
	  }
	}

	// We substract the space the rotating block would need. And make it
	// a bit more oval to look pleasing.
	translate([-dist/2, 0, hinge_center_z + base_thick]) scale([1, 1.2, 1]) rotate([0, 90, 0]) cylinder(r=hinge_center_z, h=dist);

	// .. also the space above the axle towards te cello-player should
	// generally be free.
	translate([-dist/2, -base_dia, hinge_center_z + base_thick - hinge_axle_r]) cube([dist, base_dia, base_dia]);
	// ... the other side has more space.
	translate([-dist/2, 0, hinge_center_z + base_thick - hinge_axle_r + 3.2]) cube([dist, base_dia, base_dia]);


	// On the side with the screwhead, we want to have one washer
	#translate([-(hinge_axle_len + m8_head_thick)/2, 0, base_thick + hinge_center_z]) rotate([0, 90, 0]) axle_space(hinge_axle_len, 16);
    }    
}

module display_mount(display_angle) {
    baseplate();
    
    color("red") translate([0, 0, base_thick + hinge_center_z]) rotate([0, display_angle, -90]) translate([0, 0, -hinge_rotate_block_height/2]) pin_holder();
}

module print_endpin_holder() {
    baseplate();
    translate([0, -base_dia/2 - 10, 0]) rotate([0, 0, -90]) pin_holder(r=pin_r);
}

module xray() {
    difference() {
	baseplate();
	translate([0, 0, 22]) cube([50, 50, 20], center=true);
    }
}


/// --------
/// uncomment one of these. For printing, print_endpin_holder() is
/// what you want.
/// --------

// -- show how the dowel is in place
//xray();

//-- separate baseplate and pin
//baseplate();
//pin_holder();

// -- print the hole thing.
print_endpin_holder();

// In openSCAD: show how it looks mounted.
//display_mount(25);
