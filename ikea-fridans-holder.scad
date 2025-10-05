// Holding the stick that keeps the blind up.
$fn=180;
e=0.01;
clearance=0.2;
small=14.4;
big=27;

offset=(big-small)/2;

module cutout(extra=clearance, height=40, top_wider=10) {
  translate([0, 0, small/2]) hull() {
    translate([-offset, 0, 0]) sphere(r=small/2+extra);
    translate([-offset-top_wider, 0, height]) sphere(r=small/2+extra);
    translate([offset, 0, 0]) sphere(r=small/2+extra);
    translate([offset+top_wider, 0, height]) sphere(r=small/2+extra);
  }
}

module block() {
  long_block=big + 4;
  overlap=small*0.6;
  back_wall=2;
  translate([-long_block/2, -small/2-back_wall, -1]) cube([long_block, overlap+back_wall, 20]);
}

module block1() {
  wall=1.2;
  w=big + 4.6*wall;
  h=small+2*wall;
  intersection() {
    hull() {
      translate([-w/2, -h/2-5, 0]) cube([w, 1, small/2+5]);
      cutout(extra=wall);
    }
    union() {
      hull() {
	translate([0, -1, -2]) cube([w, h, e], center=true);
	translate([0, -1, small/4]) cube([w, h, e], center=true);
	translate([-w/2, -h/2-2, 0]) cube([w, 1, small/2+5]);
      }
      hull() {
	translate([0, -1, small/4]) cube([w, h, e], center=true);
	translate([0, -h/4-1, small/2+5]) cube([w, h/2, e], center=true);
      }
    }
  }
}

//block();
module block3() {
  intersection() {
    block1();
    //cube([50, 50, 30], center=true);
  }
}

module screw() {
  cylinder(r=4/2, h=20);
  color("yellow") cylinder(r1=7.5/2, r2=4/2, h=3.5);
  translate([0, 0, -2+e]) cylinder(r=7.5/2, h=2);
}

if (true) rotate([0, 0, 180]) intersection() {
  difference() {
    block3();
    cutout();
    translate([-5, -7.3, 7]) rotate([90, 0, 0]) screw();
    translate([+5, -7.3, 7]) rotate([90, 0, 0]) screw();
  }

  hull() {
    translate([-20, -2.65, 8.2]) rotate([0, 90, 0]) cylinder(r=4, h=40);
    difference() {
      block3();
      translate([-20, -2.65, 9.2]) rotate([0, 90, 0]) cylinder(r=4, h=40);
    }
  }
}
