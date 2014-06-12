## Some useful "one-liners" for vmd

## Display Active Windows with filename
#proc showme {} {draw color yellow; set gid [graphics top text {0 0 0} [molinfo top get name] size 2]; display update; after 1000; graphics top delete $gid}

## Blink Active Window
proc showme {} {color Display {Background} white; display update; after 100; color Display {Background} black}

## Number of unique resdiues in selection
proc nres {sel} {return [llength [lsort -unique [$sel get residue]]]}

## Run scripts silently.
proc source_silent {args} {foreach f $args {source $f}}

proc setbox {{molid top}} {
    set sel [atomselect $molid "all"]
    set box [vecinvert [vecsub {*}[measure minmax $sel -withradii]]]
    molinfo $molid set {a b c} $box
    $sel delete
}

## Write out a xsc/xst, guess box dims if necessary
proc writebox {fname {molid top} {guess 0}} {
    if {[catch {package present "pbctools"}]} {
        package require pbctools
    }

    if {$guess} {setbox $molid}
    pbc writexst $fname
}


## Alias atomselect. I'm so tired of typing "atomselect"
proc as_alias {} {
    interp alias {} as {} atomselect
    interp alias {} ast {} atomselect top
    interp alias {} asa {} atomselect top all
}; as_alias
