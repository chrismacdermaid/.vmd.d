
proc labelatoms {sel label {size 1.0} {off {0.5 0.5 0.0}}} {

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
    graphics $newmol color 8

    foreach x [$sel get x]\
        y [$sel get y]\
        z [$sel get z]\
        w [$sel get $label] {
            graphics $newmol text [vecadd [list $x $y $z] $off] $w size $size
        }

    ## Make sure the old mol is top
    molinfo $molid set top 1

    ## Apply the viewpoint to the new mol
    cpy_viewpoint 99999 $molid $newmol

}
