## Some useful "one-liners" for vmd

## Display Active Windows with filename
#proc showme {} {draw color yellow; set gid [graphics top text {0 0 0} [molinfo top get name] size 2]; display update; after 1000; graphics top delete $gid}

## Blink Active Window
proc showme {} {color Display {Background} white; display update; after 100; color Display {Background} black}

## Number of unique resdiues in selection
proc nres {sel} {return [llength [lsort -unique [$sel get residue]]]}

## Run scripts silently.
proc source_silent {args} {foreach f $args {source $f}}

proc setbox {{molid top} {tweak {0.0 0.0 0.0}}} {
    set sel [atomselect $molid "all"]
    set box [vecinvert [vecsub {*}[measure minmax $sel -withradii]]]
    set box [vecadd $box $tweak]
    molinfo $molid set {a b c} $box
    $sel delete
}

## Write out a xsc/xst, guess box dims if necessary
proc writebox {fname {molid top} {guess 0}} {
    if {[catch {package present "pbctools"}]} {
        package require pbctools
    }

    if {$guess} {setbox $molid}
    pbc writexst $fname -molid $molid -now
}

proc boxby2 {{molid top} {guess 0}} {
    if {[catch {package present "pbctools"}]} {
        package require pbctools
    }

    if {$guess} {setbox $molid}

    return [vecscale [molinfo top get {a b c}] 0.5]
}

## Alias atomselect. I'm so tired of typing "atomselect"
proc as_alias {} {
    interp alias {} as {} atomselect
    interp alias {} ast {} atomselect top
    interp alias {} asa {} atomselect top all
}; as_alias

## Return atomselect text for selecting within the specified min/max range
## aswithin {*}[measure minmax $sel]
proc aswithin {{min {0.0 0.0 0.0}} {max {0.0 0.0 0.0}} {molid top}} {

    lassign $min xmin ymin zmin
    lassign $max xmax ymax zmax

    set seltxt {}

    if {$xmin != ""} {lappend seltxt "x >= $xmin"}
    if {$ymin != ""} {lappend seltxt "y >= $ymin"}
    if {$zmin != ""} {lappend seltxt "z >= $zmin"}
    if {$xmax != ""} {lappend seltxt "x <= $xmax"}
    if {$ymax != ""} {lappend seltxt "y <= $ymax"}
    if {$zmax != ""} {lappend seltxt "z <= $zmax"}
    
    return ([join $seltxt " and "])
}

## Return atomselect text for selecting withing a spherical cutoff
proc aswithin_sphere {{center {0.0 0.0 0.0}} {r 1.0} {molid top}} {
    lassign $center cx cy cz
    return "((x-$cx)*(x-$cx)+(y-$cy)*(y-$cy)+(z-$cz)*(z-$cz) < $r*$r)"
}

## calculate COM of sel1 translate $sel2 by inverse of COM
proc recenter {sel1 sel2 {first -1} {last -1}} {

    set molid [$sel1 molid]
    if {$molid != [$sel2 molid]} {
        vmdcon -err "Selections must share the same molid"
        return -1
    }

    if {$first < 0} {
        set first [molinfo $molid get frame]
    }

    set n [molinfo $molid get numframes]
    if {$last < 0 || $last > $n} {
        set last [molinfo $molid get frame]
    }

    for {set i $first} {$i <= $last} {incr i} {
        molinfo $molid set frame $i
        $sel1 update; $sel2 update
        set v [vecinvert [measure center $sel1 weight mass]]
        $sel2 moveby $v
    }
}

proc striplist {args} {
    # Usage:
    # http://wiki.tcl.tk/3400
    # striplist ?-level num? list
    #
    # Level defaults to 0 if omitted.  This means all levels of list nesting
    #   are removed by the proc.  For each level requested, a level of list nesting
    #   is removed.
    #
    # determine level
    set idx [lsearch $args -level]
    if {$idx == 0} {
        set level [lindex $args [incr idx]]
        set args [lreplace $args [expr $idx - 1] $idx]
    } else {
        set level 0
    }
    # while text seems braced and level is not exhausted
    while {1} {
        # strip outer braces and expose inners
        incr level -1
        set newargs [join $args]
        if {$newargs == $args} {
            break
        } else {
            set args $newargs
        }
        if {$level == 0} {
            break
        }
    }
    return $args
}
