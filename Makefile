THINGS=dimension-bracket.stl webcam-hood.stl spool-holder.stl \
       stacked-spool-holder.stl cello-endpin-holder.stl

all : $(THINGS)

clef.scad : FClef.dxf

 %.eps: %.svg
	inkscape -E $@ $<

 %.dxf: %.eps
	pstoedit -psarg "-r300x300" -dt -f dxf:-polyaslines $< $@

%.stl: %.scad
	openscad -o $@ -d $@.deps $<
