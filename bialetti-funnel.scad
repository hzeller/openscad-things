e=0.01;
$fn=120;

bialetti_inner=55;
bialetti_outer=64;

lip_overlap=3;
lip_thick=0.8;

tamper_clearance=0.5;

funnel_len=10;

module bialetti(extra=0) {
  height=5;
  color("silver") translate([0, 0, -height]) difference() {
    cylinder(r=(bialetti_outer + extra)/2, h=height);
    translate([0, 0, -e]) cylinder(r=(bialetti_inner + extra)/2, h=height+2*e);
  }
}

module lip() {
  translate([0, 0, -lip_overlap]) difference() {
    cylinder(r=bialetti_inner/2, h=lip_overlap);
    translate([0, 0, -e]) cylinder(r=bialetti_inner/2-lip_thick, h=lip_overlap+2*e);
  }
}

module funnel() {
  difference() {
    cylinder(r=bialetti_outer/2, h=funnel_len);
    translate([0, 0, -e]) cylinder(r1=bialetti_inner/2-lip_thick,
				   r2=bialetti_outer/2 -lip_thick,
				   h=funnel_len+2*e);
  }
}

module tamper() {
  height=5;
  ball_r=10;
  elevate=10;
  cylinder(r=bialetti_inner/2-lip_thick-tamper_clearance, h=height);
  cylinder(r=ball_r/2, h=height+elevate);
  translate([0, 0, height+elevate]) hull() {
    translate([0, 0, ball_r]) sphere(r=ball_r);
    cylinder(r=ball_r/2, h=1);
  }
}

module complete_funmnel() {
  lip();
  funnel();
}

translate([bialetti_outer, 0, 0]) tamper();
translate([0, 0, funnel_len]) rotate([180, 0, 0]) complete_funmnel();
