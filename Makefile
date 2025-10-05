THINGS=$(shell git ls-tree --full-tree -r --name-only HEAD *.scad)
THING_STL=$(patsubst %.scad, stl/%.stl, $(THINGS))
THING_PNG=$(patsubst %.scad, img/%.png, $(THINGS))

world :
	@echo "Choose 'make all' or make <one of the following>:"
	@echo $(THING_STL)

all : $(THING_STL) $(THING_PNG)

#enumerate them to make tab-completion work.
stl/dimension-bracket.stl:
stl/webcam-hood.stl:
stl/spool-holder.stl:
stl/stacked-spool-holder.stl:
stl/cello-endpin-holder.stl:
stl/scope-phone-adapter.stl:
stl/snap-joint-test.stl:
stl/peristaltic-pump.stl:
stl/solenoid-valve.stl:
stl/dosing-funnel-porta.stl:
stl/soap-holder.stl:

%.eps: %.svg
	inkscape -E $@ $<

%.dxf: %.eps
	pstoedit -psarg "-r300x300" -dt -f dxf:-polyaslines $< $@

stl/%.stl: %.scad
	openscad -o $@ -d $@.deps $<

img/%.png: %.scad
	openscad --export-format=png -o $@ -d $@.deps $<

clean:
	rm -f $(THING_STL)
