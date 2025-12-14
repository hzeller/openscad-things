// To put in different switches that fits into a gaggia classic.

$fn=90;
e=0.01;

top_width=65;
top_height=43;
top_thick=3;
front_wall=2;
switch_offset=5;

module zip_tie() {
  translate([-1.2/2, -60/2, top_thick+1.5]) cube([1.2, 60, 5]);
}

module switch_block() {
  h=30;
  w=21;
  translate([0, -h/2, -e]) cube([w, h, 20]);
  translate([w+1, 0, 0]) zip_tie();
}

module rounded_rectangle(w=40, h=20,r=2.5,thick=1) {
    hull() {
      translate([-w/2+r, -h/2+r, 0]) cylinder(r=r,h=thick);
      translate([+w/2-r, -h/2+r, 0]) cylinder(r=r,h=thick);
      translate([+w/2-r, +h/2-r, 0]) cylinder(r=r,h=thick);
      translate([-w/2+r, +h/2-r, 0]) cylinder(r=r,h=thick);
    }
}

module hollow_box(from_outer=4, draft=1, wall=2, height=15, punch=false) {
  if (punch) {
    hull() {
      translate([0, 0, -e]) rounded_rectangle(w=top_width-from_outer-wall, h=top_height-from_outer-wall, thick=1);
      translate([0, 0, height+e]) rounded_rectangle(w=top_width-from_outer-wall-draft, h=top_height-from_outer-wall-draft, thick=1);
    }
  }
  else {
    difference() {
      hull() {
	rounded_rectangle(w=top_width-from_outer, h=top_height-from_outer, thick=1);
	translate([0, 0, height]) rounded_rectangle(w=top_width-from_outer-draft, h=top_height-from_outer-draft, thick=1);
      }

      hollow_box(from_outer, draft, wall, height, true);
    }
  }
}

difference() {
  hollow_offset=2;
  union() {
    rounded_rectangle(w=top_width, h=top_height, thick=top_thick);
    translate([0, 0, hollow_offset]) hollow_box();
  }

  translate([0, 0, hollow_offset]) hollow_box(punch=true);
  translate([switch_offset, 0, 0]) switch_block();
  scale([-1, 1, 1]) translate([switch_offset, 0, 0]) switch_block();
}
