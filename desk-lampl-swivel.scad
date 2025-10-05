$fn=90;
e=0.01;

block_thick=11;
block_wide=20;
block_bottom_r=2;
block_offset=2;

pin_len=19.3;
pin_dia=6;
pin_front_cone=2;
pin_front_cone_wider=1;
pin_retainer_radius=3;
pin_narrow_dia=4.5;

hold_screw_distance=10;
hold_screw_dia=4;
hold_screw_offset=hold_screw_dia/2 + pin_narrow_dia/2;

module back_donut() {
  hull() rotate_extrude() translate([pin_retainer_radius, 0, 0]) circle(r=pin_retainer_radius);
}

module center_donut() {
  rotate_extrude() translate([hold_screw_dia/2 + pin_narrow_dia/2, 0, 0]) circle(r=hold_screw_dia/2);
}

module pin(back_extra=10) {
  cylinder(r=pin_dia/2, h=pin_len + back_extra);
  translate([0, 0, pin_len]) back_donut();
  cylinder(r1=pin_dia/2 + pin_front_cone_wider, h=pin_front_cone);
  translate([0, 0, -1+e]) cylinder(r=pin_dia/2 + pin_front_cone, h=1);
}

module mount_screw() {
  translate([hold_screw_offset, 0, hold_screw_distance]) {
    rotate([90, 0, 0]) translate([0, 0, -20])
      cylinder(r=hold_screw_dia/2, h=40);
  }
}

module negative_space() {
  difference() {
    pin();
    translate([0, 0, hold_screw_distance]) center_donut();
  }
  mount_screw();
}

module hold_block() {
  difference() {
    translate([block_offset, 0, 0]) hull() {
      translate([0, 0, pin_len]) rotate([90, 0, 0]) translate([0, 0, -block_thick/2]) cylinder(r=block_wide/2, h=block_thick);
      translate([-(block_wide/2-block_bottom_r), 0, block_bottom_r]) rotate([90, 0, 0]) translate([0, 0, -block_thick/2]) cylinder(r=block_bottom_r, h=block_thick);
      right_r=block_bottom_r + 2*block_offset;
      translate([block_wide/2-right_r, 0, right_r]) rotate([90, 0, 0]) translate([0, 0, -block_thick/2]) cylinder(r=right_r, h=block_thick);
    }
    #negative_space();
  }
}

module separator() {
  translate([0, -25, 0]) cube([50, 50, 100], center=true);  // cut in half
}

module print() {
  difference() {
    hold_block();
    separator();
  }

  translate([0, 0, -5]) rotate([180, 0, 0]) intersection() {
    hold_block();
    separator();
  }
}

print();
