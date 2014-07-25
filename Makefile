THINGS=dimension-bracket.stl webcam-hood.stl spool-holder.stl \
       stacked-spool-holder.stl

all : $(THINGS)

%.stl: %.scad
	openscad -o $@ -d $@.deps $<
