$fn=120;
e=0.01;

// Size of the holder
length=55;
mount_r=20;
mount_wall=2;

// Mounting screws
with_mount_holes=true;  // Switch off when just using double-sided tape
mount_distance=20;      // hole distance
mount_screw_head_dia=5.5;
mount_screw_dia=2.55;

// Size of cavity to glue magnet in.
magnet_r=12.2 / 2;   // diameter/2
magnet_thick=3;
soap_r=magnet_r + 4;  // frame around magnet


r_tilt_per_length=(mount_r - soap_r)/length;

module cone(r1=soap_r, r2=mount_r, len=length) {
  translate([0, 0, len]) rotate([180, 0, 0]) hull() {
    cylinder(r1=r1, r2=r2, h=length);
    sphere(r=r1);
  }
}

module magnet() {
  translate([0, e, length]) rotate([90, 0, 0]) cylinder(r=magnet_r, h=magnet_thick+e);
}

module screw_punch(head_dia=mount_screw_head_dia, body_dia=mount_screw_dia) {
  translate([0, 0, -1]) {
    cylinder(r=head_dia/2, h=5);
    hull() {
      cylinder(r=body_dia/2, h=5);
      translate([0, -head_dia/2-body_dia, 0])
	cylinder(r=body_dia/2, h=5);
    }
  }
}

module soap_holder() {
  l2=8;            // level 2: cylindrical straight part
  l3=length - 20;  // level 3: cone: when the solid parts begins
  wall = 2;

  difference() {
    cone();
    translate([-50, 0, -1]) cube([100, 100, 100]);  // shave off bottom part

    // bottom hollow
    translate([0, 0, mount_wall]) cylinder(r=mount_r-(l2*r_tilt_per_length)-wall, h=l2-mount_wall+e);
    // middle hollow
    hollow_len=l3 - l2;
    translate([0, 0, l2]) cylinder(r1=mount_r-(l2*r_tilt_per_length)-wall, r2=mount_r - l3*r_tilt_per_length - wall, h=hollow_len+2*e);

    translate([0, 0, l3-e]) cylinder(r1=mount_r - l3*r_tilt_per_length - wall, r2=5, h=10);
    magnet();

    if (with_mount_holes) {
      bottom_clearance = mount_screw_head_dia/2+1.6;
      translate([mount_distance/2, -bottom_clearance, 0]) screw_punch();
      translate([-mount_distance/2, -bottom_clearance, 0]) screw_punch();
    }
  }
}

// Just a little guide to drill holes
module drill_guide() {
  difference() {
    cube([mount_distance + 10, 10, 0.4], center=true);
    translate([mount_distance/2, 0, -1]) cylinder(r=0.7, h=5);
    translate([-mount_distance/2, 0, -1]) cylinder(r=0.7, h=5);
  }
}

soap_holder();
if (with_mount_holes) { // In that case, a drill guide is useful
  translate([0, 10, 0]) drill_guide();
}
