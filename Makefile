THINGS=$(shell git ls-tree --full-tree -r --name-only HEAD *.scad)
THING_STL=$(patsubst %.scad, stl/%.stl, $(THINGS))
THING_PNG=$(patsubst %.scad, img/%.png, $(THINGS))

world :
	@echo "Choose 'make all' or make <one of the following>:"
	@echo $(THING_STL)

all-stl : $(THING_STL)
all-img : $(THING_PNG)
all : all-stl all-img

%.eps: %.svg
	inkscape -E $@ $<

%.dxf: %.eps
	pstoedit -psarg "-r300x300" -dt -f dxf:-polyaslines $< $@

stl :
	mkdir -p stl

stl/%.stl: %.scad stl
	openscad -o $@ -d $@.deps $<

img/%.png: %.scad
	openscad --export-format=png -o $@ -d $@.deps $<

clean:
	rm -f $(THING_STL)
