## Some useful "one-liners" for vmd

## Display Active Windows with filename
#proc showme {} {draw color yellow; set gid [graphics top text {0 0 0} [molinfo top get name] size 2]; display update; after 1000; graphics top delete $gid}

## Blink Active Window
proc showme {} {color Display {Background} white; display update; after 100; color Display {Background} black}

## Number of unique resdiues in selection
proc nres {sel} {return [llength [lsort -unique [$sel get residue]]]}

## Run scripts silently.
proc source_silent {args} {foreach f $args {source $f}}

proc setbox {{molid top} {seltext all} {tweak {0.0 0.0 0.0}}} {
    set sel [atomselect $molid $seltext]
    set box [vecinvert [vecsub {*}[measure minmax $sel -withradii]]]
    set box [vecadd $box $tweak]
    molinfo $molid set {a b c} $box
    $sel delete
}

proc displayscale {scale} {
  lassign [vecscale [display get size] $scale] x y
  display resize [expr {int($x)}] [expr {int($y)}]
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

## Wrap trajectory with common options
proc wrap {{molid top} {opts {-all -center origin -compound fragment}}} {

    if {[catch {package present "pbctools"}]} {
        package require pbctools
    }

    pbc wrap {*}$opts -molid $molid
}

## UnWrap trajectory
proc unwrap {{molid top} {opts {}}} {

    if {[catch {package present "pbctools"}]} {
        package require pbctools
    }

    pbc unwrap {*}$opts -molid $molid
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

## Renumber the residues in a molecule based on fragment
proc renumber_residues {mol} {

    set sel [atomselect $mol "all"]
    set frags [lsort -unique -increasing -integer [$sel get fragment]]
    $sel delete

    ## Now go residue-by-residue in each fragment and resnumber
    foreach f $frags {
        set sel [atomselect $mol "fragment $f"]
        set res [lsort -unique -increasing -integer [$sel get residue]]
        $sel delete

        set i 0
        foreach r $res {
            set sel [atomselect $mol "residue $r"]
            $sel set resid [incr i]
            $sel delete
        }
    }
}

## Reletter the chains in a molecule based on fragment
proc reletter_chains {mol} {

    set sel [atomselect $mol "all"]
    set frags [lsort -unique -increasing -integer [$sel get fragment]]
    $sel delete

    set chains {A B C D E F G H I J K L M N O\
                    P Q R S T U V W X Y Z a b c\
                    d e f g h i j k l m n o p q r\
                    s t u v w x y z 0 1 2 3 4 5 6\
                    7 8 9 0}
    set i 0
    foreach f $frags {
        set sel [atomselect $mol "fragment $f"]
        $sel set chain [lindex $chains $i]
        incr i
    }
}

## Use bfactor column to recolor residues with chainbows
## Create a chainbow representation to accompany
proc chainbows {mol {addrep 0}} {

    set sel [atomselect $mol "all"]
    set frags [lsort -unique -increasing -integer [$sel get fragment]]
    $sel delete

    ## Now go residue-by-residue in each fragment and renumber
    foreach f $frags {
        set sel [atomselect $mol "fragment $f"]
        set res [lsort -unique -increasing -integer [$sel get residue]]
        set N [llength $res]
        $sel delete

        set i 0
        foreach r $res {
            set sel [atomselect $mol "residue $r"]
            $sel set beta [expr { $i / double($N)}]
            $sel delete
            incr i
        }
    }

    if {$addrep} {

        ## Set the color method to beta
        set n [molinfo $mol get numreps]
        eval "mol color beta"

        ## Duplicate the representation
        eval "mol addrep $mol"

        ## Adjust the colorscale
        eval "mol scaleminmax $mol $n 0.0 1.0"
    }
}

proc getseq {sel} {

    set seq {}
    set three [$sel get resname]

    foreach s $three {

        switch -exact $s {
            GLY {lappend seq G} ALA {lappend seq A} VAL {lappend seq V}
            LEU {lappend seq L} ILE {lappend seq I} PHE {lappend seq F}
            TRP {lappend seq W} PRO {lappend seq P} SER {lappend seq S}
            THR {lappend seq T} ASN {lappend seq N} GLN {lappend seq Q}
            CYS {lappend seq C} LYS {lappend seq K} ARG {lappend seq R}
            HIS {lappend seq H} ASP {lappend seq D} GLU {lappend seq E}
            MET {lappend seq M} TYR {lappend seq Y}
            default {lappend seq X} }

    }
    return [join $seq ""]
}

## Return rotation matrix necessary to bring vector v to axis x,y or z
proc mytransvecinv {axis v} {

    lassign $v v0 v1 v2

    switch -exact $axis {
        X -
        x {
            set theta [expr {-1 * atan2($v1, $v0)}]
            set length [expr {sqrt($v1 * $v1 + $v0 * $v0)}]
            set phi [expr {atan2($v2, $length)}]

            set m1 [transaxis y $phi rad]
            set m2 [transaxis z $theta rad]

            return [transmult $m2 $m1]
        }
        Y -
        y {
            set theta [expr {-1 * atan2($v2, $v1)}]
            set length [expr {sqrt($v2 * $v2 + $v1 * $v1)}]
            set phi [expr {atan2($v0, $length)}]

            set m1 [transaxis z $phi rad]
            set m2 [transaxis x $theta rad]

            return [transmult $m2 $m1]
        }
        Z -
        z {
            set theta [expr {-1 * atan2($v0, $v2)}]
            set length [expr {sqrt($v0 * $v0 + $v2 * $v2)}]
            set phi [expr {atan2($v1, $length)}]

            set m1 [transaxis x $phi rad]
            set m2 [transaxis y $theta rad]

            return [transmult $m2 $m1]
        }

        default {return [transidentity]}
    }
}
