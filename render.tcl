## Renders some frames

proc myrender {molid filename {start 0} {stop end} {stride 1}} {

    if {$stop == "end"} {
      set stop [molinfo $molid get numframes]
    }

    for {set i $start;set j 0} {$i < $stop} {incr i $stride; incr j} {
        molinfo $molid set frame $i
        render TachyonInternal [format "%s.%04d.tga" $filename $j]
    }

}

