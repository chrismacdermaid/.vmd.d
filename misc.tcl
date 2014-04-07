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
