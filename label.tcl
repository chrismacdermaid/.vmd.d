
# Label atoms with specified atomselect quantity
## Colorid: 8=white 16=black
# labelatoms "all" {name type}
proc labelatoms {{sel ""} {label name} {color 8}\
                     {size 1.0} {off {0.5 0.5 0.0}}} {

    set flag 0

    if {$sel == ""} {
        set sel [atomselect top "all"]
        set flag 1
    } elseif {![string match "atomselect*" $sel]} {
        if {[catch {atomselect top $sel} sel]} {return}
        set flag 1
    } else {}

    set molid [$sel molid]

    foreach x $label {
        if {[lsearch -ascii [atomselect keywords] $x] == -1} {
            set msg [vmdcon -err "Unknown atomselect keyword: $x"]
            return -code error $msg
        }
    }

    ## Get the viewpoint for the mol we're labeling
    save_viewpoint 99999 $molid

    ## Make a new mol
    set newmol [mol new]

    ## Set the label color to white
    graphics $newmol color $color

    foreach x [$sel get x]\
        y [$sel get y]\
        z [$sel get z]\
        w [$sel get $label] {
            graphics $newmol text [vecadd [list $x $y $z] $off] [join $w " "] size $size
        }

    ## Make sure the old mol is top
    molinfo $molid set top 1

    ## Apply the viewpoint to the new mol
    cpy_viewpoint 99999 $molid $newmol

    if {[string match "atomselect*" $sel] && $flag} {
        $sel delete
    }
}
