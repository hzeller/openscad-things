
plate_thick=1.6;
snap_thick=0.6;
snap_wide=5;
snap_len=5;
snap_space=0.8;
plate_width=15;
epsilon=0.1;

module baseplate() {
    translate([0, 0, plate_thick/2]) cube([1.5 * plate_width + 4, plate_width, plate_thick], center=true);
}

module wedge(w=1, d=1, h=1) {
    polyhedron(points = [
	    [0, 0, 0], [w, 0, 0], [w, d, 0], [0, d, 0],
	    [0, 0, h], [0, d, h], 
	],
	faces = [[0, 3, 1], [1, 3, 2],  // bottom
	[0, 1, 4], [2, 3, 5],  // sides
	[0, 4, 3], [3, 4, 5],  // back to the left
	[1, 5, 4], [1, 2, 5]  // wedge part.
	]);
}

module snap_spring(d=2, w=0, thick=1, h=1) {
    // Straight parts
    translate([-w, -d/2, 0]) cube([w - thick, d, thick]);
    translate([0, -d/2, 2 * thick]) cube([thick, d, h - 2 * thick]);

    // Rounding
    difference() {
	translate([-thick, d/2, 2 * thick]) rotate([90, 0, 0]) cylinder(r=2 * thick, h=d, $fn=30);
	translate([-thick, d/2 + epsilon, 2 * thick]) rotate([90, 0, 0]) cylinder(r=thick, h=d + 2 * epsilon, $fn=30);
	translate([-3 * thick, -d/2 - epsilon, thick]) cube([2 * thick, d + 2 * epsilon, 3 * thick]);
	translate([-3 * thick, -d/2 - epsilon, 2 * thick]) cube([3 * thick, d + 2 * epsilon, 2 * thick]);
    }

    // hook.
    translate([thick, d/2, h]) rotate([0, 0, 180]) wedge(w=3*thick, d=d, h=thick);
    translate([thick, d/2, h]) rotate([0, 90, 180]) wedge(w=3 * thick, d=d, h = 3 * thick);
}

module snap_space(d=2, w=0, thick=1, h=1) {
}
    
module sample_mount() {
    // Make space
    difference() {
	baseplate();
	cube([15, 3, 10], center=true);
    }
}

module hook_plate(snap_wide) {
    difference() {
	baseplate();
	translate([plate_width/2 - snap_len/2 + snap_space, 0, plate_thick/2]) cube([snap_len + 2 * snap_space, snap_wide + 2 * snap_space, plate_thick + 2 * epsilon], center=true);
	rotate([0, 0, 180]) translate([plate_width/2 - snap_len/2 + snap_space, 0, plate_thick/2]) cube([snap_len + 2 * snap_space, snap_wide + 2 * snap_space, plate_thick + 2 * epsilon], center=true);
    }

    translate([plate_width/2, 0, 0]) snap_spring(w=snap_len + epsilon, d=snap_wide, thick=snap_thick, h=2 * plate_thick);
    rotate([0, 0, 180]) translate([plate_width/2, 0, 0]) snap_spring(w=snap_len + epsilon, d=snap_wide, thick=snap_thick, h=2 * plate_thick);
}

module snap_plate() {
    difference() {
	scale([1, 1.3, 1]) baseplate();
	rotate([0, 0, 90]) translate([plate_width/2 - snap_len/2 + 4.2 * snap_space, 0, plate_thick/2]) cube([3 * snap_space, snap_wide + 2 * snap_space, plate_thick + 2 * epsilon], center=true);
	rotate([0, 0, -90]) translate([plate_width/2 - snap_len/2 + 4.2 * snap_space, 0, plate_thick/2]) cube([3 * snap_space, snap_wide + 2 * snap_space, plate_thick + 2 * epsilon], center=true);
#	translate([0, 0, -plate_thick]) rotate([0, 0, 90]) hook_plate(snap_wide + 2 * snap_space);
    }
}

hook_plate(snap_wide);
translate([0, plate_width + 5, 0]) snap_plate();
//snap_spring(w=2, thick=0.5, h=3);
