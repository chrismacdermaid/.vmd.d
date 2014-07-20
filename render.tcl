## Renders some frames

proc myrender {molid filename {start 0} {stop end} {stride 1}} {

    if {$molid == "all"} {set molid [molinfo list]}

    if {$stop == "end"} {
        foreach m $molid {
            lappend N [molinfo $m get numframes]
        }
        set N [lsort -integer -decreasing $N]
        set stop [lindex $N 0]
    }

    for {set i $start;set j 0} {$i < $stop} {incr i $stride; incr j} {
        foreach m $molid {
            molinfo $m set frame $i
        }
        render TachyonInternal [format "%s.%04d.tga" $filename $j]
    }
}
