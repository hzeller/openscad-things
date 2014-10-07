THINGS=dimension-bracket.stl webcam-hood.stl spool-holder.stl \
       simple-spool-holder.stl peristaltic-pump.stl

world :
	@echo "Choose 'make all' or make <one of the following>:"
	@echo $(THINGS)

all : $(THINGS)

# Make 'make' tab-completion a breeze by listing each target.
dimension-bracket.stl:
webcam-hood.stl:
spool-holder.stl:
simple-spool-holder.stl:
peristaltic-pump.stl:

%.stl: %.scad
	openscad -o $@ -d $@.deps $<
