all : dimension-bracket.stl webcam-hood.stl spool-holder.stl

%.stl: %.scad
	openscad -o $@ -d $@.deps $<
