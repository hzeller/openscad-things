e=0.01;

len = 150;
width=45;
height = 10;
min_height=1;

module foot() {
  cylinder(r=5, h=0.25);
}

module measure_row(over_range=len, tap_offset=5, mini_offset=8) {
  emboss=0.4;
  x_per_mm = over_range / (height - min_height);
  for (i = [min_height:height]) {
    // Measure lines side
    xoffset=x_per_mm * (i - min_height);
    r = (i % 10 == 0) ? 2*emboss
      : (i % 5 == 0) ? emboss
      : emboss / 2;
    up = (i % 5 == 0) ? 0 : i - 3;
    translate([xoffset - r/2, up, -emboss]) {
      cube([r, 2*height, emboss+e]);
    }

    top_w=0.7;
    translate([xoffset-top_w/2, i-0.1*emboss, -width]) cube([top_w, 1, width]);
    // Measure text
    if (i % 10 == 0) {
      translate([xoffset - 0.2 * x_per_mm, 2, -emboss]) rotate([0, 0, 0]) linear_extrude(height=emboss+e) text(str(i), halign="right", size=min(x_per_mm * .9, height/2), font="Liberation Sans:style=Bold");
    }
  }
}

difference() {
  color("blue") linear_extrude(h=width) polygon([[0, 0], [0, min_height], [len, height], [len, 0]]);
  translate([0, 0, width]) measure_row();
}

translate([0, 0, width-0.25]) foot();
