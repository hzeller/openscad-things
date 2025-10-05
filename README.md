Some random things with no claim of usefulness :) Mostly for me to dump
some designs I want to share somewhere or not forget.

   - cello-endpin-holder: holds the endpin of a cello ([here an early version] (https://plus.google.com/u/0/+HennerZeller/posts/4s14tKttz5i))
   - dimension-bracket: simpler ruler for printer adjustment
   - scope phone adapter: an [adapter for my MotoX phone to my microscope](https://plus.google.com/u/0/+HennerZeller/posts/9eWFhvYqgtb)
   - snap joint test: little test to see how things can be snap joint (not
     terribly successful yet).
   - spool-holder: necessity - an axis adaptor for spools.
   - stacked-spool-holder: stack of spool holders, mount on top of printer.
   - webcam-hood: a hood for my Logitec C920 webcam.

All designs are (c) h.zeller@acm.org and licensed Creative Commons BY-SA.

Update list with:

```
SCAD_LIST=$(git ls-tree --full-tree -r --name-only HEAD *.scad)
make all-img
for f in ${SCAD_LIST} ; do NAME="$(basename -s.scad $f)"; git add img/${NAME}.png ; echo "## $NAME"; echo '[!'"[$NAME](img/$NAME.png)]($NAME.scad)"; done
```

# Generated images
## bezier
[![bezier](img/bezier.png)](bezier.scad)
## bialetti-funnel
[![bialetti-funnel](img/bialetti-funnel.png)](bialetti-funnel.scad)
## cello-endpin-holder
[![cello-endpin-holder](img/cello-endpin-holder.png)](cello-endpin-holder.scad)
## dimension-bracket
[![dimension-bracket](img/dimension-bracket.png)](dimension-bracket.scad)
## dosing-funnel-porta
[![dosing-funnel-porta](img/dosing-funnel-porta.png)](dosing-funnel-porta.scad)
## framework
[![framework](img/framework.png)](framework.scad)
## funnel-holder
[![funnel-holder](img/funnel-holder.png)](funnel-holder.scad)
## hinge
[![hinge](img/hinge.png)](hinge.scad)
## hp-foot
[![hp-foot](img/hp-foot.png)](hp-foot.scad)
## ikea-fridans-holder
[![ikea-fridans-holder](img/ikea-fridans-holder.png)](ikea-fridans-holder.scad)
## light-bracket
[![light-bracket](img/light-bracket.png)](light-bracket.scad)
## microscope-camera-sleeve
[![microscope-camera-sleeve](img/microscope-camera-sleeve.png)](microscope-camera-sleeve.scad)
## mini-box
[![mini-box](img/mini-box.png)](mini-box.scad)
## mirror-wedge
[![mirror-wedge](img/mirror-wedge.png)](mirror-wedge.scad)
## peristaltic-pump
[![peristaltic-pump](img/peristaltic-pump.png)](peristaltic-pump.scad)
## rift-glass-holder
[![rift-glass-holder](img/rift-glass-holder.png)](rift-glass-holder.scad)
## scope-phone-adapter
[![scope-phone-adapter](img/scope-phone-adapter.png)](scope-phone-adapter.scad)
## sdcard-grabber
[![sdcard-grabber](img/sdcard-grabber.png)](sdcard-grabber.scad)
## snap-joint-test
[![snap-joint-test](img/snap-joint-test.png)](snap-joint-test.scad)
## soap-holder
[![soap-holder](img/soap-holder.png)](soap-holder.scad)
## solenoid-valve
[![solenoid-valve](img/solenoid-valve.png)](solenoid-valve.scad)
## spool-holder
[![spool-holder](img/spool-holder.png)](spool-holder.scad)
## stacked-spool-holder
[![stacked-spool-holder](img/stacked-spool-holder.png)](stacked-spool-holder.scad)
## staircase
[![staircase](img/staircase.png)](staircase.scad)
## sun-tracker
[![sun-tracker](img/sun-tracker.png)](sun-tracker.scad)
## syringe-piston
[![syringe-piston](img/syringe-piston.png)](syringe-piston.scad)
## vacuum-corner-attach
[![vacuum-corner-attach](img/vacuum-corner-attach.png)](vacuum-corner-attach.scad)
## webcam-hood
[![webcam-hood](img/webcam-hood.png)](webcam-hood.scad)
