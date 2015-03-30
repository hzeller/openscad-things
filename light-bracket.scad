$fs=0.1;
$fa=1;
epsilon=0.05;
above_eyes=50;
working_distance=300;
forehead_angle=22;   // empirical
angle=forehead_angle + atan(above_eyes/working_distance);

echo("Angle: ", angle);

module pcb() {
    translate([0,0,6]) cube([50,25,14], center=true);
}

module bracket(hole_x=12.7, hole_y=5.5,thick=1.5) {
    difference() {
	union() {
	    hull() {
		rotate([0,0,angle]) cube([25.4,11,thick]);
		cube([25.4,0.1,thick]);
	    }
	    rotate([90,0,0]) cube([25.4,3+thick,thick]);
	}
	translate([hole_x,hole_y,-1]) cylinder(r=3/2,h=5);
    }
}

module bracket2(hole_x=12.7, hole_y=5.5,thick=1.5,wider=2) {
    difference() {
	translate([0,3,0]) rotate([0,0,-angle]) difference() {
	    union() {
		hull() {
		    rotate([0,0,angle]) translate([wider,-7,0]) cube([25.4,11,thick]);
		    translate([0,11,0]) cube([25.4 + 2 * wider,3,thick]);
		    translate([3,35,0]) cylinder(r=3,h=thick);
		    translate([25.4 + 2*wider - 3,35,0]) cylinder(r=3,h=thick);
		}
		rotate([90,0,angle]) translate([wider,0,7]) cube([25.4,3+thick,thick]);
	    }
	    translate([wider,15,-0.1]) cube([25.4,2,5]);
	    translate([wider,23,-0.1]) cube([25.4,2,5]);
	    translate([wider,31,-0.1]) cube([25.4,2,5]);
	}

	translate([wider,0,0]) translate([hole_x,hole_y-4,-1]) cylinder(r=3/2,h=5);
    }
}
    
module fin(length=25.4, height=3, width=1.8) {
    translate([-width/2,-1, -epsilon]) cube([width,length+2,height]);
}
module heatsink(base=25.4,fin_height=3) {
    // ruler and squint measurement :)
    color("silver") translate([-145/2,-base/2,0]) union() {
	translate([0,0,0]) fin(base, fin_height);
	translate([25.4/3,0,0]) fin(base, fin_height);
	translate([25.4,0,0]) fin(base, fin_height);
	translate([34,0,0]) fin(base, fin_height);
	translate([42.5,0,0]) fin(base, fin_height);
	translate([42.5,0,0]) fin(base, fin_height);
	translate([51,0,0]) fin(base, fin_height);
	translate([59.2,0,0]) fin(base, fin_height);
	translate([68,0,0]) fin(base, fin_height);
	translate([84.5,0,0]) fin(base, fin_height);
	translate([93,0,0]) fin(base, fin_height);
	translate([101.5,0,0]) fin(base, fin_height);
	translate([110,0,0]) fin(base, fin_height);
	translate([126.8,0,0]) fin(base, fin_height);
	translate([135.2,0,0]) fin(base, fin_height);
	translate([144,0,0]) fin(base, fin_height);
	translate([-7,-base/2,-20+epsilon]) cube([160,2*base,20]);
    }
}

module foam_finold(base=25.4,r=2.5,h2=12,thick=1) {
    rotate([0,-90,0]) translate([2*r,0,0]) hull() {
	translate([0,base/2-r,0]) cylinder(r=r,h=thick);
	translate([0,-base/2+r,0]) cylinder(r=r,h=thick);
	translate([h2,-base/2+r,0]) cylinder(r=r,h=thick);
    }
}

module rounded_rectangle(base=25.4,r=2.5,h=12,thick=1) {
    rotate([0,-90,0]) translate([r,0,0]) hull() {
	translate([-10,base/2-r,-thick/2]) cylinder(r=r,h=thick);
	translate([0,-base/2+r,-thick/2]) cylinder(r=r,h=thick);
	translate([h,-base/2+r,-thick/2]) cylinder(r=r,h=thick);
	translate([h,base/2-r,-thick/2]) cylinder(r=r,h=thick);
    }
}

module forehead_holder(heatsink_base=25.4,length=64,angle=20,head_radius=120,fin_height=3,fin_count=10) {
    difference() {
	union() {
	    translate([-length/2,-heatsink_base/2,-fin_height]) cube([length,heatsink_base,fin_height+2]);
	    // x^2+y^2 = head_radius^2
	    // so: y = sqrt(head_radius^2 - x^2)
	    rotate([angle,0,0]) {
		for (i=[0:1:fin_count-1]) {
	            assign(pos = -length/2 + 2 + i * (length-4)/(fin_count-1)) {
			translate([pos,0,0]) rounded_rectangle(h=head_radius+3-sqrt(head_radius*head_radius - pos*pos), base=0.9 * cos(angle)*heatsink_base, thick=(i==0 || i == fin_count-1) ? 2.5 : 1.2);
		    }
		}
	    }
	}
	translate([0,0,-fin_height]) heatsink(base=heatsink_base, fin_height=fin_height);
    }
}

module forehead_holder2(heatsink_base=25.4,length=64,angle=20,head_radius=120,fin_height=3,fin_count=10) {
    difference() {
	union() {
	    translate([-length/2,-heatsink_base/2,-fin_height]) cube([length,heatsink_base,fin_height+2]);
	    assign(block_thick=cos(angle) * heatsink_base)
	    difference() {
		translate([0,1.2,0]) rotate([angle,0,0]) difference() {
		    hull() {
			translate([-length/2,-block_thick/2,-5]) cube([length, block_thick, 4]);
			translate([length/2-5, block_thick/2,16.5]) rotate([90,0,0]) cylinder(r=5,h=block_thick);
			translate([-length/2+5, block_thick/2,16.5]) rotate([90,0,0]) cylinder(r=5,h=block_thick);
		    }

		    // The forehead :)
		    translate([0,heatsink_base/2+epsilon,head_radius+9]) rotate([90,0,0]) cylinder(r=head_radius, h=heatsink_base+2*epsilon);

		    translate([length/2-10,12,6]) rotate([90,0,0]) cylinder(r=1.1,h=15);
		    translate([-(length/2-10),12,6]) rotate([90,0,0]) cylinder(r=1.1,h=15);
		    //translate([0,12,-5]) rotate([0,0,0]) pcb();
		}
		translate([-length/2-5,-heatsink_base,-fin_height]) cube([length+2*5,2*heatsink_base,fin_height+2]);
	    }
	}
	translate([0,0,-fin_height]) heatsink(base=heatsink_base, fin_height=fin_height);
    }
}

module brackets() {
    // The holes are a bit off-center :)
    bracket2(hole_x=12.7,hole_y=5.7);
    translate([0,-16,0]) bracket(hole_x=11.8,hole_y=6);
}

module retainer(wider=2) {
    difference() {
	cube([25.4 + 2*wider, 4, 12], center=true);
	cube([25.4, 2, 14], center=true);
    }
}

module test_forehead() {
    difference() {
	forehead_holder(length=100, fin_count=5, head_radius=78, angle=angle);
	translate([0,0,-4]) cube([200,200,10], center=true);
    }
}

//heatsink();
//retainer();
//brackets();

//rounded_rectangle();
//heatsink();

module brackets() {
    translate([0,30,0]) {
	bracket2();
	translate([-30,0,0]) bracket();
    }
}

module battery(width=80,thick=19,extra=0,height=40) {
    translate([0,-extra/2,0]) cube([width-thick, thick+extra, height]);
    translate([0,thick/2,0]) cylinder(r=(thick+extra)/2,h=height);
    translate([width-thick,thick/2,0]) cylinder(r=(thick+extra)/2,h=height);
}

module battery_holder(wall=1.5,height=5) {
    difference() {
	battery(extra=wall,height=height+wall-epsilon);
	translate([0,0,wall]) battery(height=height);
    }
}


module belt_bracket(height=40,width=30,thick=4,wall=1.5) {
    posts = [ [ 0, 0 ],
	      [height,0], [height+0.8,thick/2], [height,thick],
	      [height/3,thick], [height/3-5,thick+1] ];
    for (i = [1:len(posts)-1] ) {
	hull() {
	    translate(posts[i-1]) cylinder(r=wall/2,h=width);
	    translate(posts[i]) cylinder(r=wall/2,h=width);
	}
    }
}

//battery_holder(wall=1.5);
//rotate([0,-90,180]) belt_bracket();

forehead_holder2(length=100, fin_count=17, head_radius=74, angle=angle);