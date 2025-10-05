$fn=30;
e=0.01;

part_w=32;
part_h=30.5;
part_t=6.85;
wall=1.5;
living_hinge_thick=0.4;
side_wall=2;
usb_offset=3.75;

hinge_extra=1;  // a bit longer for more relief.
hinge_len=PI*(part_t+wall)+hinge_extra;

part_count=3;

module usb(r=2.6/2) {
  w=8.4;
  rotate([0, 90, 0]) hull() {
    translate([0, -w/2+r, 0]) cylinder(r=r, h=7);
    translate([0, +w/2-r, 0]) cylinder(r=r, h=7);
  }
}

module part(usb_extra=0, with_ether=false) {
  difference() {
    translate([0, -part_h/2, 0]) {
      cube([part_w+wall, part_h, wall]);  // bottom
      cube([wall, part_h, part_t+wall]);  // front

      lock_width=1.2*wall;
      start_at=max(0, part_t-4);
      color("red") translate([-lock_width+e, 0, start_at]) hull() {  // lock
	translate([0, 0, 2]) cube([0.5, part_h/3, part_t+wall-start_at]);
	translate([lock_width, 0, living_hinge_thick]) {
	  cube([e, part_h/3, part_t+wall-living_hinge_thick+0.5-start_at]);
	}
      }
    }
    translate([-1, 0, wall+usb_offset+usb_extra]) usb();
    translate([part_w+wall+2, 0, -e]) cylinder(r=10, h=wall+1);
    if (with_ether) {
      translate([wall+3.2, -part_h/2, -e]) cube([part_w, part_h, wall+2*e]);
    }
  }
}

module side() {
  difference() {
    translate([0, part_h/2, 0]) cube([part_w+wall, side_wall, part_t+wall]);
    // slot for rubber-band
    translate([part_w-15, part_h/2+1, -e]) cube([5, side_wall, part_t+wall+2*e]);
  }
}

module living_hinge(w=part_h) {
  translate([-hinge_len/2, -part_h/2, 0]) {
    cube([hinge_len, w, 0.4]);
  }
}

module row(ether_at=100, mirror=false) {
  sf=mirror ? -1 : 1;

  scale([sf, 1, 1]) {
    translate([hinge_len/2, (part_count-1)*part_h, 0]) side();
    translate([hinge_len/2, 0, 0]) scale([1, -1, 1]) side();
  }
  for (i=[0:1:part_count-e]) {
    translate([0, i*part_h, 0]) scale([sf, sf, 1]) translate([hinge_len/2, 0, 0]) part(with_ether=(i == ether_at));
  }
}

if (true) {
  row(ether_at=1);
  row(mirror=true);
  translate([0, -side_wall, 0]) living_hinge(part_h*part_count+2*side_wall);
 }
