THINGS=dimension-bracket.stl webcam-hood.stl spool-holder.stl \
       simple-spool-holder.stl

all : $(THINGS)

%.stl: %.scad
	openscad -o $@ -d $@.deps $<
