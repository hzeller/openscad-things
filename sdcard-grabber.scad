// Grabber for SD cards on a Pi.
$fn=60;
e=0.01;

module sdcard_back(wide=20) {
  cube([wide, 20, 0.8]);
  color("red") cube([wide, 2.5, 1.2]);
}

thick=4;
width=15;

module grabber() {
  translate([0, -20, -1/2]) cube([width, 20, 1]);  // handle
  difference() {
     union() {
      translate([0, 0, 0]) cube([width, 4, thick/2]);
      rotate([0, 90, 0]) cylinder(r=thick/2, h=width);
      translate([0, 0, -thick/2]) cube([width, 2.2, thick/2]);
      rotate([0, 90, 0]) cylinder(r=thick/2, h=width);
    }

    #sdcard_back();
  }
}

module ear() {
  color("green") cylinder(r=3, h=0.20);
}

rotate([0, -90, 0]) grabber();
translate([0, -20, 0]) ear();
translate([3, 2, 0]) ear();
translate([-4, 2, 0]) ear();
