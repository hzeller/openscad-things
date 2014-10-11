/* Solenoid valve.
 * Input switched to output (down) or exhaust (up)
 */
$fn=48;
clearance=0.3;
epsilon=0.02;

wall_thick_under_o_ring=0.5;
wall_thick_to_channel=1;

block_thickness=2;

slit=1;
slit_rim=0.2;              // rim around slit to next o-ring.
o_ring_thick=2;            // diameter of rubber
o_ring_radius=7/2;         // inner radius of the o-ring.

pipe_dia=2*o_ring_radius + o_ring_thick;

pipe_with_o_ring_radius=(pipe_dia + o_ring_thick)/2;

end_len=o_ring_thick/2 + 0.5;

channel_thick=1.5;

// The area that is active is two half o-rings + slit.
hub=o_ring_thick + slit + 2*slit_rim;
dead_zone=0*hub;            // dead zone is full hub or less if overlap is allowed

travel=hub + dead_zone;

// The hollow pipe needs to be thick enough to allow to be indented by the
// o-ring.
hollow_dia=pipe_dia - o_ring_thick - 2*wall_thick_under_o_ring;

block_size=2*(pipe_with_o_ring_radius + wall_thick_to_channel + channel_thick) + block_thickness;
pipe_high=end_len + hub + travel + 2*dead_zone + end_len;
block_high = pipe_high + travel;
breakout_size=20;  // breaking out of block.

inlet_pos=o_ring_thick/2;
outlet_pos=o_ring_thick/2 + travel;

magnet_diameter=4;
magnet_length=12.6;
magnet_hull=0.4;  // should be a single shell

coil_length=magnet_length + travel;  // Good value. Can be shorter if needed.
coil_transition=2;
coil_diameter=12;
coil_wall=0.5;

// We want the magnet transition so that the magnet is centered in the
// coil at half travel.
magnet_transition=(coil_length - magnet_length)/2 + coil_transition + travel/2;

magnet_holder_start=pipe_high - end_len;
magnet_start=magnet_holder_start + magnet_transition;

module o_ring() {
    color("gray") rotate_extrude(convexity=10) translate([o_ring_radius+o_ring_thick/2, 0, 0]) circle(r=o_ring_thick/2);
}

module magnet(extra=0) {
    color("silver") translate([0,0,-extra]) cylinder(r=magnet_diameter/2+extra,h=magnet_length+2*extra);
}

module magnet_holder(){ 
    // The part holding the magnet.
    magnet_coverage = magnet_length/2;   // no reason to fully cover it.
    difference() {
	cylinder(r=magnet_diameter/2 + clearance + magnet_hull,
	         h=magnet_coverage + magnet_transition);
	translate([0,0,magnet_transition]) magnet(extra=clearance);
    }
}

module coil_holder() {
    // Transition to coil and coil holder
    difference() {
	union() {
	    // transition.
	    cylinder(r1=block_size/2,r2=coil_diameter/2,h=coil_transition);

	    // winding cylinder
	    cylinder(r=magnet_diameter/2 + magnet_hull + 2*clearance + coil_wall,
		     h=coil_length+coil_transition);
	}
	translate([0,0,-epsilon])
	   cylinder(r=magnet_diameter/2 + magnet_hull + 2*clearance,
	    h=coil_transition+coil_length+2*epsilon);
    }    
}

module coil() {
    translate([0,0,coil_transition]) {
	difference() {
	    color("DarkGoldenrod") cylinder(r=coil_diameter/2, h=coil_length);
	    cylinder(r=magnet_diameter/2 + magnet_hull + 2*clearance + coil_wall,
		h=coil_length);
	}
    }
}

module o_rings() {    
    o_ring();                         // start of inlet
    translate([0,0,hub+travel]) o_ring();  // end.
}

module inner_shifter() {
    difference() {
	translate([0,0,-end_len]) cylinder(r=pipe_dia/2, h=pipe_high);
	o_rings();
    }
    translate([0,0,magnet_holder_start]) magnet_holder();
}

module valve_block() {
    difference() {
	translate([0,0,-end_len]) difference() {
	    hull() {
		cylinder(r=block_size/2, h=block_high, $fn=128);
		translate([block_size/2-2, -block_size/2, 0]) cube([2,block_size,block_high]);
	    }
	    
	    // Hole:
	    translate([0,0,-epsilon]) cylinder(r=pipe_with_o_ring_radius,h=block_high + 2*epsilon);
	}
	union() {
	    translate([0,0,inlet_pos]) channel();
	    translate([0,0,outlet_pos]) channel();
	}
    }

    // Add solenoid on top
    translate([0,0,block_high-end_len]) coil_holder();
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
    translate([0,0,slit_rim]) linear_extrude(height=slit) channel2d();
}


module assembly(display_shifter=0) {
    translate([0,0,display_shifter]) {
	inner_shifter();
	o_rings();
	
	translate([0,0,magnet_start]) magnet();
    }
    
    valve_block();
    translate([0,0,block_high-end_len]) coil();
}

module xray() {
    difference() {
	assembly(display_shifter=($t < 0.5) ? (2 * $t * travel) : (2 * (1-$t) * travel));
	rotate([0,0,90]) translate([0,0,-end_len-epsilon]) cube([breakout_size,breakout_size,3*block_high+coil_length+2*epsilon]);
    }
}

xray();
//inner_shifter();