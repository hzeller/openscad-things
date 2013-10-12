
thickness=1;
arm_length=100;
arm_width=10;

cube([arm_length, arm_width, thickness]);
translate([arm_width, 0, 0]) rotate([0, 0, 90]) cube([arm_length, arm_width, thickness]);

// X axis marker
color("blue") translate([0.9 * arm_length, 3, 0.8]) cube([4, 4, 0.5]);

// y axis marker
color("red") translate([5, 0.9 * arm_length, 0.8]) cylinder(r=2, h=0.5);
