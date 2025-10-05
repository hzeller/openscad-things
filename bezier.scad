$fn=90;
e=0.01;

function _cubic_bazier_point(start, c1, c2, finish, t) =
  let (
    u = 1.0 - t,
    tt = t * t,
    uu = u * u,
  )
  (u*uu) * start +
  3.0 * uu * t * c1 +
  3.0 * u * tt * c2 +
  (t*tt) * finish;

function cubic_bezier(start, c1, c2, finish, count=50) =
  [ for (t = [0 : 1/count : 1]) _cubic_bazier_point(start, c1, c2, finish, t) ];

module bezier_polygon(start, c1, c2, finish, count=100, visualize_cp=true) {
  polygon(cubic_bezier(start, c1, c2, finish, count));

  if (visualize_cp) {
    color("red") translate(c1) circle(r=0.2);
    color("green") translate(c2) circle(r=0.2);
  }
}

module viz_controlpoint(col, point, cp) {
  hull() {
    translate(point) circle(r=0.01);
    translate(cp) circle(r=0.01);
  }
  color(col) translate(cp) circle(r=0.1);
}

module viz_vertex(start, c1, c2, finish) {
  viz_controlpoint("red", start, c1);
  viz_controlpoint("green", finish, c2);
}

module cubic_spline(points, cps,
		    extrude=-1, count=50,
		    show_controlpoints=false) {
  assert(len(points) >= 2, "Need to have at least twp points");
  assert(len(points) == len(cps),
	 "There needs one control point per point");
  second_to_last = len(points) - 1;
  list = [ for (i = [0:1:second_to_last-e])
      each cubic_bezier(points[i],
			cps[i],
			i < second_to_last-1
			? points[i+1]-(cps[i+1] - points[i+1])
			: cps[i+1],
			points[i+1]) ];
  if (extrude > 0) {
    linear_extrude(height=extrude) polygon(list);
  } else {
    polygon(list);
  }

  if (show_controlpoints) {
    for (i = [0:1:second_to_last-e]) {
      viz_vertex(points[i], cps[i],
		 i < second_to_last-1
		 ? points[i+1]-(cps[i+1] - points[i+1])
		 : cps[i+1],
		 points[i+1]);
    }
  }
}

cubic_spline(points=[  [0, 0], [1, 2], [3, 0]  ],
	     cps=[  [-1, 1], [2, 2], [4, 1]    ],
	     show_controlpoints=true);
//bezier_polygon([0,0], [-1, 2], [7, 5], [5, 3]);
