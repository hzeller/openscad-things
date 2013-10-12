all : dimension-bracket.stl webcam-hood.stl

%.stl: %.scad
	openscad -o $@ -d $@.deps $<
