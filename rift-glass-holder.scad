// Some experiments making a holder for lenses inside the rift.
$fn=180;

tight_fit=0.15;  // What to add to get a snug fit.

// Glass parameters. Assuming to be round.
glass_dia=26;
glass_thick=3.5;
frame_dia=glass_dia + 2;
nose_space_width=26;

eye_dist=64;   // eye distance. The Oculus is set to 64.

// The rift eye lenses.
rift_eye_dia=39;   // Diameter
rift_eye_rim=6;    // Rim distance so that center does not scratch.
rift_rim_thick=1.6;
rift_hook_len=15;

module rift_connect_hook() {
    intersection() {
	difference() {
	    union() {
		translate([rift_eye_dia/2-0.5, -2.5, 0]) rotate([0, -66, 0]) cube([rift_hook_len, 5, rift_rim_thick]);
		cylinder(r=rift_eye_dia/2, h=rift_eye_rim);
	    }
	    translate([0, 0, -1]) cylinder(r=rift_eye_dia/2-rift_rim_thick, h=2 * rift_eye_rim);
	}
	translate([0, -4, 0]) cube([rift_eye_dia/2 + 20, 8, rift_hook_len]);
    }
    translate([0, -4, 0]) cube([rift_eye_dia/2-0.5, 8, rift_rim_thick]);
}

module rift_connect() {
    for (i=[0:2]) {
	rotate([0, 0, 360/3 * i]) rift_connect_hook();
    }
}
  
module glass_punch() {
    cylinder(r=glass_dia/2+tight_fit, h=12);
}

module view_punch() {
    cylinder(r=(glass_dia-1)/2, h=12);
}


module glass_holder() {
    difference() {
	union() {
	    rift_connect();
	    cylinder(r=frame_dia/2, h=glass_thick);
	}
	translate([0, 0, -1]) view_punch();
	translate([0, 0, 1]) glass_punch();
    }
}

module bridge_arch() {
    difference() {
	translate([0, 0, -eye_dist+5]) rotate([-90, 0, 0]) cylinder(r=eye_dist, h=40);
	translate([0, -1, -eye_dist+5]) rotate([-90, 0, 0]) cylinder(r=eye_dist-2, h=42);
    }
}
    
module bridge() {
    difference() {
	intersection() {
	    translate([0, -37, 0]) cylinder(r=50, h=10);
	    translate([-eye_dist/2, 0, 0]) cube([eye_dist, 30, 20]);
	    bridge_arch();
	}
	translate([0, -4, -1]) cylinder(r=nose_space_width/2, h=20);
	translate([11, -2, 9]) rotate([0, 0, 60]) cube([8, 8, 20], center=true);
	translate([-11, -2, 9]) rotate([0, 0, -60]) cube([8, 8, 20], center=true);
    }
}

module frame() {
    translate([-eye_dist/2, 0, 0]) rotate([0, 0, 19]) glass_holder();
    translate([eye_dist/2, 0, 0]) rotate([0, 0, 180-19]) glass_holder();
    bridge();
}

module glasses() {
    difference() {
	frame();

	translate([-eye_dist/2, 0, 1]) glass_punch();
	translate([-eye_dist/2, 0, -1]) view_punch();
	translate([eye_dist/2, 0, 1]) glass_punch();
	translate([eye_dist/2, 0, -1]) view_punch();
    }
}

//bridge();
//bridge_arch();
//glasses();   // turns out to be not that useful with bridge

// Two of these is nicer.
glass_holder();
