// Little hood for the Logitec C920 webcam.
$fn=128;
wall_width=1.6;

bracket_depth=5 + wall_width/2;
bracket_width=45;
bracket_height=30;  // should be 29, but tolerances don't seem to work out.
bracket_angle=4.7;

hood_height=25;
hood_aspect=1920/1080;
hood_proximal_radius=4;
hood_distal_radius=bracket_height * 0.6;

snap_fit_gap=0.15;          // necessary gap to have things fit smootly together.
snap_width=wall_width/2;   // Wall width where things are snapped together.
snap_thickness=wall_width - 0.25;

// The inclination is (width of the image)/(distance from image)
image_width_inclination=109 / 80;  // actual measurement: 109 cm at 80cm distance
image_height_inclination=1080/1920 * image_width_inclination;

// The free space at the bottom in the bracket to slide the hood in. It needs to be wide
// enough, so that the hood, approached from bracket_depth below will fit in the hole.
// So the hole needs to be a bit wider by the following margin.
mounting_margin=image_width_inclination * bracket_depth;
mounting_space=2 * (hood_proximal_radius * hood_aspect + wall_width * image_width_inclination) + 2 * mounting_margin;
mounting_plate_width = bracket_width - 2;
mounting_plate_height = bracket_height - 2;

cut_radius=2 * hood_distal_radius;

// Model to play with.
module camera() {
    // Camera body
    hull() {
	translate([0, 0, -12.5]) cube([60, bracket_height, 25], center=true);
	translate([38, bracket_height/2, -16]) rotate([90, 0, 0]) cylinder(h=bracket_height, r=5);
	translate([-38, bracket_height/2, -16]) rotate([90, 0, 0]) cylinder(h=bracket_height, r=5);
    }
    // The imaging area that needs to be free.
    d = 1.5 * hood_height;
    w = image_width_inclination * d / 2;
    h = image_height_inclination * d / 2;
    image_plane  = -7;
    translate([0, 0, image_plane]) polyhedron(points = [ [0, 0, 0],
	    [-w, -h, d], [w, -h, d], [w, h, d], [-w, h, d] ],
	triangles = [ [ 0, 1, 2], [0, 2, 3], [0, 3, 4], [0, 4, 1],
	[1, 2, 3], [1, 3, 4] ]);
}

module base_bracket() {
    // The body.
    translate([0, 0, wall_width/2]) cube([bracket_width, bracket_height + wall_width, wall_width], center=true);
    // 'knee'
    translate([-bracket_width/2, bracket_height/2+wall_width/2, wall_width/2])
      rotate([0, 90, 0])
        cylinder(h=bracket_width, r=wall_width/2);
    
    translate([0, bracket_height/2+wall_width/2, wall_width/2])
      rotate([-bracket_angle, 0, 0])
        translate([0, 0, -bracket_depth/2])
          cube([bracket_width, wall_width, bracket_depth], center=true);

    translate([-bracket_width/2, -bracket_height/2-wall_width/2, wall_width/2])
      rotate([0, 90, 0])
        cylinder(h=bracket_width, r=wall_width/2);
    translate([0, -bracket_height/2-wall_width/2, wall_width/2])
      rotate([bracket_angle, 0, 0])
        translate([0, 0, -bracket_depth/2])
           cube([bracket_width, wall_width, bracket_depth], center=true);
}

// Mounting bracket, that has some space in the front to ease mounting.
module bracket() {
    difference() {
	base_bracket();
	// Punch out the access area.
	translate([0, -bracket_height/2, 0]) cube([mounting_space + 2 * snap_fit_gap, bracket_height, 2 * bracket_depth], center=true);
	scale([1, 1/hood_aspect, 1]) cylinder(r=mounting_space/2 + snap_fit_gap, h=3 * wall_width, center=true);
    }
}

// Something that punches a hole wherever the hood is.
module outer_hood_volume() {
    translate([0, 0, -wall_width - 0.1]) scale([hood_aspect, 1, 1]) cylinder(h=hood_height, r1=hood_proximal_radius, r2=hood_distal_radius);
}

// This is more or less a funnel. The curved_hood() below makes this looks a bit nicer.
module straight_hood() {
    difference() {
	difference() {
	    outer_hood_volume();
	    translate([0, 0, wall_width]) outer_hood_volume();
	}
	camera(); // We're a bit below. Flatten that.
    }
}

// Let's curve the top off a bit. We are mostly interested in blocking light from the top.
module curved_hood() {
    intersection() {
	straight_hood();
	// Make it more like a cape; cut the hoodwi
	translate([-bracket_width, bracket_height/2, -(cut_radius-hood_height+wall_width)]) rotate([0, 90, 0]) cylinder(h=2 * bracket_width, r=cut_radius);
    }
}

// We mount the hood on a base-plate, that will snap into the bracket.
// The snap_adjust is the addional amount it the holes should be sized.
module hood_baseplate(snap_adjust=0) {
    difference() {
	union() {
	    // Plate we 'mount' the hood on. This is thinner (only snap-width) than the usual wall width, because
	    // we want to snap to halfs together.
	    translate([0, 0, snap_width/2]) cube([mounting_plate_width - 2 * snap_adjust, mounting_plate_height - 2 * snap_adjust, snap_width], center=true);
	    
	    // In the mounting space area, we have a thicker part of the plate, so that after mounting, things are flush.
	    translate([0, -bracket_height/4, wall_width/2]) cube([mounting_space, bracket_height/2+wall_width, wall_width], center=true);
	    scale([1, 1/hood_aspect, 1]) cylinder(r=mounting_space/2, h=wall_width);

	    // rounded front.
	    translate([-mounting_space/2, -(bracket_height + wall_width)/2, wall_width/2]) rotate([0, 90, 0]) cylinder(r=wall_width/2, h=mounting_space);
	}
	// mounting holes.
	translate([mounting_plate_width/2 - 2.5 - 2, mounting_plate_height/2 - 4.5, -1]) cylinder(r=2.5 + snap_adjust, h=wall_width + 2);
	translate([-(mounting_plate_width/2 - 2.5 - 2), mounting_plate_height/2 - 4.5, -1]) cylinder(r=2.5 + snap_adjust, h=wall_width + 2);

	// and squares.
	translate([(mounting_plate_width + mounting_space) / 4, -mounting_plate_height/4, 0]) cube([2 + 2*snap_adjust, 6 +2* snap_adjust, 10], center=true);
	translate([-(mounting_plate_width + mounting_space) / 4, -mounting_plate_height/4, 0]) cube([2 + 2*snap_adjust, 6 + 2*snap_adjust, 10], center=true);
    }
}

module mounted_hood() {
    difference() {
	hood_baseplate();
	outer_hood_volume();
    }
    curved_hood();
}

module clickable_bracket() {
    difference() {
	bracket();
	hood_baseplate(-snap_fit_gap);
	translate([0, 0, -0.1]) hood_baseplate(-snap_fit_gap); // properly punch
    }
}

// Now, let's print these components next to each other. We essentially take
// them from the mounted position and unfold them by turning the bracket 180 degrees
// on its back.
print_offset_y=bracket_height/2 + wall_width + 1;
module print_hood() {
    // The hood is already flush with the bottom.
    translate([0, print_offset_y, 0]) mounted_hood();
}

module print_bracket() {
    // The hood needs to be turned around to be printed flat on its back.
    rotate([180, 0, 0]) translate([0, print_offset_y, -wall_width]) clickable_bracket();
}

module print() {
    print_hood();
    print_bracket();
}

// How it looks while attempting to mount to see that there is enough space.
module mounting_animation() {
    // Two 'scenes': approach and marry.
    if ($t < 0.5) {
	assign(scene_t = 2 * (0.5 - $t)) {  // 1..0
	    translate([0, scene_t * (bracket_height + 5), scene_t * hood_height/5 + (bracket_depth + wall_width/2)]) rotate([scene_t * 20, 0, 0]) clickable_bracket();
	}
    } else {
	assign(scene_t = 1 - 2 * ($t - 0.5)) {  // 1..0
	    translate([0, 0, scene_t * (bracket_depth + wall_width/2)]) clickable_bracket();
	}
    }
    color("lightgreen") mounted_hood();
}

module complete_mount() {
    color("red") clickable_bracket();
    mounted_hood();
    %camera();
}

//complete_mount();
//mounting_animation();
print();

