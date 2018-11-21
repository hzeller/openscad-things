$fn=60;
e=0.01;  // epsilon, used to poke through things thorougly.

turns=0.75;
step_oversize_factor=1.2;
steps=12;
step_height=180;
step_width=600;   // millimeter
step_thick=40;
step_separation=10;
center_radius=60;
pole_radius=40;

top_height=step_height * steps;

module step() {
     angle = step_oversize_factor * turns * 360 / steps ;
     color("brown") difference() {
	  hull() {
	       // The arc of the step
	       rotate_extrude(angle=angle) square([step_width, step_thick]);
	       cylinder(r=center_radius, h=step_thick);  // Center pole collar
	  }

	  // Punch hole for the pole.
	  translate([0,0,-e]) cylinder(r=pole_radius, h=step_thick + 2*e);
     }
}

// Derive animation phase from $t, which goes from 0..1
anim_phase
     = $t < 0.2 ? 0                  // First phase: stay on top
     : $t < 0.5 ? ($t - 0.2) * 3.33  // second phase: unroll
     : $t < 0.7 ? 1                  // third: stay on bottom
     : 1 - ($t - 0.7) * 3.33;        // last: roll up again.

start_distance=step_thick + step_separation;
angle = anim_phase * turns * 360 / steps;
for (i = [0:steps-e]) {
     rotate([0, 0, 360 - i*angle])
	  translate([0, 0, top_height - i * (anim_phase * (step_height-start_distance) + start_distance)])
	  step();
}
color("silver") cylinder(r=pole_radius, h=top_height + 100);
