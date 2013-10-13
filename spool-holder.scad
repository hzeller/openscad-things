// (c) h.zeller@acm.org Creative Commons license BY-SA
// Spool holder.
//
// Spools have a hole to be placed on some axis. Usually the hole
// is bigger than the axis; this spool holder is a spacer between axis and spool.

// For printing
//   - use perimeter (vertical shells) 2
//   - layer thickness: 0.2
//   - horizontal shells: 0
//   - fill density 0

// While developing, we want to see approximately how the final shape looks
// like, while for printing (developer_view=false), we get a solid for which
// the slicer generates a perimeter.
developer_view=false;

// User parameters (just mm)
spool_hole_diameter = 55;       // The diameter of the hole in the spool
axis_diameter = 25;             // Diameter of the axis we want to put it on.
                                //   (plus like 2mm to account for less accuracy)
spool_material_thickness = 3;   // The thickness of the spool material.
print_thickness = 1.2;          // Printed thickness of the walls,
                                // as determined by the perimeters (see slicer)			
arm_count = 8;                  // Number of arms in this star shape.

// Probably nothing to change here.
holder_height = spool_material_thickness + 8; // The total height of the holder.
flare_angle=35;                // 0..40: Angle of the flare from the middle.
outer_flare = (holder_height - spool_material_thickness)/ (2 * tan(90 - flare_angle));


// -- local settings
$fn=48;  // Resolution of round faces. More is more smooth but blows up file-size.
inner_r=axis_diameter / 2;
outer_r=spool_hole_diameter / 2;
outer_rings_height=(holder_height - spool_material_thickness)/2;

// The width of the arm is chosen in a way that they
// intersect at the inner radius of our holder.
// This is the side-length of the regular arm_count-polygon whose
// circumcicle is the axis.
arm_r=sin(180 / arm_count) * (inner_r + print_thickness/2);

// Just for visual reference: the axis and the spool.
module reference_view() {
    cylinder(r=inner_r, h=2*holder_height, center=true);
    difference() {
	cylinder(r=outer_r + 10, h=spool_material_thickness, center=true);
	cylinder(r=outer_r, h=spool_material_thickness+0.1, center=true);
    }
}

// A cone, off-center on the z-axis.
module offset_cone(z_offset, narrow_r, wide_r) {
    translate([0, 0, z_offset])
       cylinder(r1=narrow_r, r2=wide_r,
	        h=holder_height/2 - z_offset);
}

// The arm that is a bit wider on the outside.
module flare_arm(x) {
    hull() {
	offset_cone(spool_material_thickness/2, 0, arm_r);  // center cone.
	translate([x, 0, 0]) offset_cone(spool_material_thickness/2,
	                                 arm_r, arm_r + outer_flare);
    }
}

// Draws an arm. Parameter: distance from center.
module star_arm(x_distance) {
    flare_arm(x_distance);                    // top
    mirror([0, 0, 1]) flare_arm(x_distance);  // bottom
    hull() {
	cylinder(r=arm_r, h=holder_height, center=true);
	translate([x_distance, 0, 0]) cylinder(r=arm_r, h=holder_height, center=true);
    }
}

module solid_cross() {
    for (i = [0:arm_count-1]) {
	rotate([0, 0, (360/arm_count) * i]) star_arm(outer_r - arm_r);
    }
}

// How this looks 'assembled'
%reference_view();

if (developer_view) {
    assign(approximate_factor=(spool_hole_diameter - 2 * print_thickness) / spool_hole_diameter) {
	difference() {
	    solid_cross();
	    scale([approximate_factor,approximate_factor,1.01]) solid_cross();
	}
    }
} else {
    // We create a solid. It is simpler for the slicer to create a shell.
    solid_cross();
}
