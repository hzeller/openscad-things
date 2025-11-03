e=0.01;
$fn=160;

bialetti_inner=55;
bialetti_outer=64;

lip_overlap=3;
lip_thick=0.8;
outer_wall=2;

tamper_clearance=0.5;

funnel_len=10;

module bialetti(extra=0) {
  height=5;
  color("silver") translate([0, 0, -height]) difference() {
    cylinder(r=(bialetti_outer + extra)/2, h=height);
    translate([0, 0, -e]) cylinder(r=(bialetti_inner + extra)/2, h=height+2*e);
  }
}

module funnel() {
  difference() {
    translate([0, 0, -lip_overlap]) {
      cylinder(r=bialetti_outer/2 + outer_wall, h=funnel_len + lip_overlap - e);
    }
    translate([0, 0, -e]) cylinder(r1=bialetti_inner/2-lip_thick,
				   r2=bialetti_outer/2-lip_thick,
				   h=funnel_len+2*e);
    translate([0, 0, -lip_overlap - e ]) cylinder(r=bialetti_inner/2-lip_thick, h=lip_overlap+2*e);
    bialetti();
  }
}

module curved_handle_2d(height=25, top_r=9, curve_r=8) {
  top_circle_pos = height - top_r;
  touch_distance = top_r + curve_r;
  y_pos = top_circle_pos/2;
  y_cicle_distance = top_circle_pos - y_pos;
  x_pos = sqrt(touch_distance*touch_distance - y_cicle_distance*y_cicle_distance);

  touch_elevation = y_cicle_distance * curve_r/touch_distance;  // linear
  difference() {
    union() {
      translate([0, top_circle_pos]) circle(r=top_r);
      fumble=4;  // Maybe calculate that we have a certain bottom squareness?
      square([top_r+fumble, y_pos + touch_elevation]);
    }
    translate([x_pos, y_pos]) circle(r=curve_r);
    translate([-100, -50]) square([100, 100]);  // only keep one half
  }
}

module curved_handle(height=27.7, top_r=9, curve_r=10) {
  rotate_extrude() curved_handle_2d(height, top_r, curve_r);
}

module tamper() {
  height=5;
  cylinder(r=bialetti_inner/2-lip_thick-tamper_clearance, h=height);
  translate([0, 0, height]) curved_handle();
}

translate([bialetti_outer, 0, 0]) tamper();
translate([0, 0, funnel_len]) rotate([180, 0, 0]) funnel();
//curved_handle();
//tamper();
