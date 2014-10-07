include <../MCAD/motors.scad>  // github.com:elmom/MCAD

$fn=64;
epsilon=0.02;
hose_diameter=6;
pump_radius=5 * hose_diameter;
case_thick=3;
base_thick=2;
top_rim=1;
pump_angle=270;

module pump_case() {
    translate([0,0,-hose_diameter/2]) difference() {
	translate([0,0,-base_thick])
	   cylinder(r=pump_radius + hose_diameter/2 + case_thick,
	            h=hose_diameter + base_thick + top_rim);
	cylinder(r=pump_radius+hose_diameter/2, h=hose_diameter+top_rim+epsilon);
    }
}

module hose() {
    rotate_extrude(convexity=10) translate([pump_radius, 0, 0]) circle(r=hose_diameter/2);
    translate([pump_radius, 0, 0]) rotate([90, 0, 0]) cylinder(r=hose_diameter/2, h=25);
    translate([cos(pump_angle) * pump_radius, sin(pump_angle) * pump_radius, 0])
       rotate([90, 0, pump_angle+180]) cylinder(r=hose_diameter/2, h=25);
}

module pump() {
    difference() {
	pump_case();
	#hose();
	#translate([0,0,-hose_diameter/2-base_thick-epsilon]) linear_extrude(height=10) stepper_motor_mount(nema_standard=17);
    }
}

pump();

