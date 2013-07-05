## Renders some frames

proc myrender {molid filename} {

    set n [molinfo $molid get numframes]

    for {set i 0} {$i < $n} {incr i} {
        molinfo $molid set frame $i
        render TachyonInternal [format "%s.%04d.tga" $filename $i]
    }

}

