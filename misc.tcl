## Some useful "one-liners" for vmd

## Display Active Windows with filename
#proc showme {} {draw color yellow; set gid [graphics top text {0 0 0} [molinfo top get name] size 2]; display update; after 1000; graphics top delete $gid}

## Blink Active Window
proc showme {} {color Display {Background} white; display update; after 100; color Display {Background} black}

## Number of unique resdiues in selection
proc nres {sel} {return [llength [lsort -unique [$sel get residue]]]}

## Run scripts silently.
proc source_silent {args} {foreach f $args {source $f}}

## Use a repid id and create 3 representations:
## 1. seltext and "C.*"
## 2. seltext and "O.*"
## 3. seltext and "N.*"

proc cpk {repid {molid top}} {

    if {$molid == "top"} {
        set molid [molinfo top]
    }

    ## Molinfo properties
    set rep{}
    foreach x {rep color selection color material} {
        lappend rep [molinfo get $molid "{$x $repid}"]
    } 

    ## Molproperties
    foreach x {numperiodic showperiodic selupdate
        colupdate scaleminmax smoothrep drawframes} {
        lappend rep [mol $x $molid $repid]
    }

}

