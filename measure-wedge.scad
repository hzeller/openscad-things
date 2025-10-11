e=0.01;

len = 150;
width=5;
height = 30;
min_height=2;


module measure_row(over_range=len, tap_offset=5, mini_offset=8) {
  emboss=0.4;
  x_per_mm = over_range / (height - min_height);
  for (i = [min_height:height]) {
    xoffset=x_per_mm * (i - min_height);
    r = (i % 10 == 0) ? 2*emboss
      : (i % 5 == 0) ? emboss
      : emboss / 2;
    up = (i % 5 == 0) ? 0 : i - 3;
    translate([xoffset - r/2, up, -emboss]) {
      cube([r, 2*height, emboss+e]);
    }
    if (i % 10 == 0) {
      translate([xoffset - 0.3 * x_per_mm, 2, -emboss]) rotate([0, 0, 90]) linear_extrude(height=emboss+e) text(str(i), halign="left", size=x_per_mm * .6);
    }
  }
}

difference() {
  color("red") linear_extrude(h=width) polygon([[0, 0], [0, min_height], [len, height], [len, 0]]);
  translate([0, 0, width]) measure_row();
}
