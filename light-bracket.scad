$fn=96;
epsilon=0.01;
above_eyes=50;
working_distance=300;
angle=atan(above_eyes/working_distance);

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
		    rotate([0,0,angle]) translate([wider,-3,0]) cube([25.4,11,thick]);
		    translate([0,11,0]) cube([25.4 + 2 * wider,3,thick]);
		    translate([3,35,0]) cylinder(r=3,h=thick);
		    translate([25.4 + 2*wider - 3,35,0]) cylinder(r=3,h=thick);
		}
		rotate([90,0,angle]) translate([wider,0,3]) cube([25.4,3+thick,thick]);
	    }
	    translate([wider,15,-0.1]) cube([25.4,2,5]);
	    translate([wider,23,-0.1]) cube([25.4,2,5]);
	    translate([wider,31,-0.1]) cube([25.4,2,5]);
	}

	translate([wider,0,0]) translate([hole_x,hole_y,-1]) cylinder(r=3/2,h=5);
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
	    rotate([angle,0,0])
	      for (i=[-length/2 + 2:(length-4)/(fin_count-1):length/2 - 2]) {
		translate([i,0,0]) rounded_rectangle(h=head_radius+3-sqrt(head_radius*head_radius - i*i), base=0.9 * cos(angle)*heatsink_base);
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
	forehead_holder(length=110, fin_count=7, head_radius=78, angle=angle);
	translate([0,0,-5]) cube([200,200,10], center=true);
    }
}

//heatsink();
//retainer();
//brackets();

//rounded_rectangle();
//heatsink();

//bracket2();
//translate([-30,0,0]) bracket();
test_forehead();