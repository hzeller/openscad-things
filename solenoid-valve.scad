/*
 2 inlets: vacuum, pressure
 outlets: needle.
 
 0) vacuum -> exhaust; pressure -> exhaust
 1) vaccum -> needle; pressure -> exhaust
 2) vaccum -> exhaust; pressure -> needle;
*/

/*
  o d e     i         i=inlet, e=exhaust, d=dead, o=outlet
  - - -     -
     |-|===|-----|   (pos 1)
   |-|===|-----|     (pos 1.5 moving)
 |-|===|-----|       (pos 2)
*/

$fn=48;
wall_thick_under_o_ring=0.5;
wall_thick_to_channel=1;

block_thickness=2;
epsilon=0.02;
slit=1;
pipe_dia=6;
o_ring_thick=2;            // diameter of rubber
o_ring_radius=pipe_dia/2;  // To the middle of the rubber 'torus'
pipe_with_o_ring_radius=(pipe_dia + o_ring_thick)/2;

channel_thick=1.5;

// The area that is active is two half o-rings + slit.
hub=o_ring_thick + slit;
dead_zone=0*hub;            // dead zone is full hub or less if overlap is allowed

travel=hub + dead_zone;

// The hollow pipe needs to be thick enough to allow to be indented by the
// o-ring.
hollow_dia=2*(o_ring_radius - o_ring_thick/2) - 2*wall_thick_under_o_ring;

end_len=2;
block_size=2*(pipe_with_o_ring_radius + wall_thick_to_channel + channel_thick) + block_thickness;
pipe_high=end_len + 4*hub + 2*dead_zone + end_len;
block_high = pipe_high + travel;
breakout_size=20;  // breaking out of block.

inlet_pos=o_ring_thick/2 + travel + 2*hub+dead_zone;
exhaust_pos=o_ring_thick/2 + travel;
outlet_pos=o_ring_thick/2;

	
module o_ring() {
    color("gray") rotate_extrude(convexity=3) translate([o_ring_radius, 0, 0]) circle(r=o_ring_thick/2);
}

module pipe() {
    difference() {
	cylinder(r=pipe_dia/2, h=pipe_high);
	translate([0,0,end_len]) cylinder(r=hollow_dia/2, pipe_high - 2*end_len);
    }
}

module o_rings() {    
    o_ring();                         // start of outlet
    translate([0,0,hub]) o_ring();    // end of outlet

    translate([0,0,hub+dead_zone+hub]) o_ring();  // start inlet
    translate([0,0,(hub+dead_zone+hub) + (2*hub+dead_zone)]) o_ring(); // ..end
}

module inner_shifter() {
    difference() {
	translate([0,0,-end_len]) pipe();
	o_rings();
	translate([0,0,inlet_pos]) channel();
	translate([0,0,outlet_pos]) channel();	
    }
}

module valve_block() {
    difference() {
	translate([0,0,-end_len]) difference() {
	    hull() {
		cylinder(r=block_size/2, h=block_high);
		translate([block_size/2-2, -block_size/2, 0]) cube([2,block_size,block_high]);
	    }
	    
	    // Hole:
	    translate([0,0,-epsilon]) cylinder(r=pipe_with_o_ring_radius,h=block_high + 2*epsilon);
	}
	translate([0,0,inlet_pos]) channel();
	translate([0,0,exhaust_pos]) channel();	
	translate([0,0,outlet_pos]) channel();
    }
}

module channel2d() {
    // Outer ring
    difference() {
	circle(r=pipe_with_o_ring_radius + wall_thick_to_channel + channel_thick);
	circle(r=pipe_with_o_ring_radius + wall_thick_to_channel);
    }
    
    // Inner cross
    square([channel_thick, 2 * (pipe_with_o_ring_radius + wall_thick_to_channel + epsilon)], center=true);
    square([2 * (pipe_with_o_ring_radius + wall_thick_to_channel + epsilon), channel_thick], center=true);
    
    // Channel out
    translate([-breakout_size/2,0,0]) square([breakout_size, channel_thick], center=true);
}

module channel() {
    // TODO: differentiate slit from padding around slit. Right now only
    // epsilon.
    translate([0,0,epsilon]) linear_extrude(height=slit-2*epsilon) channel2d();
}


module assembly(display_shifter=0) {
    translate([0,0,display_shifter]) {
	inner_shifter();
	o_rings();
    }
    valve_block();
}

module xray() {
    difference() {
	assembly(display_shifter=($t < 0.5) ? (2 * $t * travel) : (2 * (1-$t) * travel));
	translate([0,0,-end_len-epsilon]) cube([breakout_size,breakout_size,block_high+2*epsilon]);
    }
}

xray();