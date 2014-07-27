THING_STL=stl/dimension-bracket.stl stl/webcam-hood.stl stl/spool-holder.stl \
          stl/stacked-spool-holder.stl stl/cello-endpin-holder.stl \
	  stl/scope-phone-adapter.stl stl/snap-joint-test.stl

all : $(THING_STL)

#enumerate them to make tab-completion work.
stl/dimension-bracket.stl:
stl/webcam-hood.stl:
stl/spool-holder.stl:
stl/stacked-spool-holder.stl:
stl/cello-endpin-holder.stl:
stl/scope-phone-adapter.stl:
stl/snap-joint-test.stl:

 %.eps: %.svg
	inkscape -E $@ $<

 %.dxf: %.eps
	pstoedit -psarg "-r300x300" -dt -f dxf:-polyaslines $< $@

stl/%.stl: %.scad
	openscad -o $@ -d $@.deps $<

clean:
	rm -f $(THING_STL)
