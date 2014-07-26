THING_STL=stl/dimension-bracket.stl stl/webcam-hood.stl stl/spool-holder.stl \
          stl/stacked-spool-holder.stl stl/cello-endpin-holder.stl

all : $(THING_STL)

 %.eps: %.svg
	inkscape -E $@ $<

 %.dxf: %.eps
	pstoedit -psarg "-r300x300" -dt -f dxf:-polyaslines $< $@

%.stl: %.scad
	openscad -o $@ -d $@.deps $<

clean:
	rm -f $(THING_STL)
