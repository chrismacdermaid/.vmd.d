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

## Alias atomselect. I'm so tired of typing "atomselect"
proc as_alias {} {
    interp alias {} as {} atomselect
    interp alias {} ast {} atomselect top
    interp alias {} asa {} atomselect top all
}; as_alias

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
