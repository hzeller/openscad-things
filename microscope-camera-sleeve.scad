include <threads.scad>
$fn=70;
e=0.01;
ramp=8;
camera_top=27.3;

module camera() {
  cylinder(r=23.3/2, h=17);
  translate([0, 0, 15]) cylinder(r=27/2, h=30);
}

if (true) difference() {
  //translate([0, 0, -e]) camera();
}

//
//ScrewHole(outer_diam=20, height=10, pitch=1.5)   cylinder(r=23.3/2, h=17);
//  ScrewThread(outer_diam=25, height=17, pitch=1.5);

module outer_sleeve() {
  difference() {
    union() {
      translate([0, 0, 25-e]) cylinder(r=35/2, h=3);
      translate([0, 0, ramp]) cylinder(r=30/2, h=25-ramp);
      cylinder(r1=30/2, r2=30/2, ramp);
    }
    translate([0, 0, -e]) cylinder(r=camera_top/2, h=30);
  }
}

module screw_sleeve() {
  ScrewHole(outer_diam=28, height=25, pitch=1.5) outer_sleeve();
}

module plug() {
  difference() {
    ScrewThread(outer_diam=28, height=17, pitch=1.5) outer_sleeve();
    translate([0, 0, -e]) cylinder(r=23.3/2, h=18);
  }
}


//plug();

screw_sleeve();
