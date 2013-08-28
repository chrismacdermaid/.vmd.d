## Apply custom colorscales

proc setcolorscale {scalename {reverse 0}} {

    global mycolors

    display update off

    set names [array names mycolors *]
    if {[lsearch -exact $names $scalename] < 0} {
        set msg [vmdcon -err "Unknown scale name $scalename"]
        return -code 1 $msg
    }

    ## Number of colors
    set n [llength $mycolors($scalename)]

    ## Convert rgb/hex to VMD-RGB values on (0,1) scale
    set colors {}
    foreach x $mycolors($scalename) {

        ## Check to see if x is a list or hex..
        if {[string is list -strict $x] && [llength $x] == 3} {
            lappend colors [rgb2vmd $x]
        } else {
            lappend colors [hex2vmd $x]
        }

    }

    ## VMD colorscale values
    set min   [expr {[colorinfo num] - 1}]
    set max   [expr {[colorinfo max] - 1}]
    set range [expr {int(($max - $min) / ($n - 1))}]

    ## Loop over colors
    for {set i 0; set j 1; set k $min} {$j < $n} {incr i; incr j} {

        lassign [lindex $colors $i]  r1 g1 b1
        lassign [lindex $colors $j]  r2 g2 b2
        set dr [expr {($r2 - $r1)/$range}]
        set dg [expr {($g2 - $g1)/$range}]
        set db [expr {($b2 - $b1)/$range}]

        ## Loop over color vmd color ids
        for {set l 0} {$l < $range && $k < $max} {incr k; incr l} {
            color change rgb $k [expr {$r1 + ($l * $dr)}]\
                [expr {$g1 + ($l * $dg)}] [expr {$b1 + ($l * $db)}]
        }
    }

    display update on

}

proc listcolorscales {} {

    global mycolors

    return [array names mycolors *]

}

# +---------+
# | HELPERS |
# +---------+

## Convert HEX to RGB
proc hex2rgb {hex} {
    set hex [string trimleft $hex "#"]
    lassign [split $hex ""] a b c d e f
    return [list [expr 0x$a$b] [expr 0x$c$d] [expr 0x$e$f]]
}

## Convert rgb scale [0 to 255] to [0 1)
proc rgb2vmd {rgb} {

    lassign $rgb r g b

    set r [expr $r * .00390625]
    set g [expr $g * .00390625]
    set b [expr $b * .00390625]

    return [list $r $g $b]

    #return [vecscale $rgb .003906250000]
}

proc hex2vmd {hex} {

    set hex [string trimleft $hex "#"]
    lassign [split $hex ""] a b c d e f
    set r [expr 0x$a$b]; set g [expr 0x$c$d]; set b [expr 0x$e$f]

    set r [expr $r * .00390625]
    set g [expr $g * .00390625]
    set b [expr $b * .00390625]

    return [list $r $g $b]

}

# +------------------------+
# | Colorscale Definitions |
# +------------------------+

proc setmycolors {} {
    global mycolors
    array set mycolors {}

    ## ColorBrewer
    set mycolors(BrBg)     [list "#8C510A" "#BF812D" "#DFC27D" "#F6E8C3" "#C7EAE5" "#80CDC1" "#35978F" "#01665E"]
    set mycolors(PuBuGn)   [list "#FFF7FB" "#ECE2F0" "#D0D1E6" "#A6BDDB" "#67A9CF" "#3690C0" "#02818A" "#016540"]
    set mycolors(Oranges)  [list "#FFF5EB" "#FEE6CE" "#FDD0A2" "#FDAE6B" "#FD8D3C" "#F16913" "#D94801" "#8C2D04"]
    set mycolors(Greys)    [list "#FFFFFF" "#F0F0F0" "#D9D9D9" "#BDBDBD" "#969696" "#737373" "#525252" "#252525"]
    set mycolors(GnBu)     [list "#F7FCF0" "#E0F3DB" "#CCEBC5" "#A8DDB5" "#7BCCC4" "#4EB3D3" "#2B8CBE" "#08589E"]
    set mycolors(BuGn)     [list "#F7FCFD" "#E5F5F9" "#CCECE6" "#99D8C9" "#66C2A4" "#41AE76" "#238B45" "#005824"]
    set mycolors(PuBu)     [list "#FFF7FB" "#ECE7F2" "#D0D1E6" "#A6BDDB" "#74A9CF" "#3690C0" "#0570B0" "#034E7B"]
    set mycolors(Blues)    [list "#F7FBFF" "#DEEBF7" "#C6DBEF" "#9ECAE1" "#6BAED6" "#4292C6" "#2171B5" "#084594"]
    set mycolors(RdPu)     [list "#FFF7F3" "#FDE0DD" "#FCC5C0" "#FA9FB5" "#F768A1" "#DD3497" "#AE017E" "#7A0177"]
    set mycolors(Greens)   [list "#F7FCF5" "#E5F5E0" "#C7E9C0" "#A1D99B" "#74C476" "#41AB5D" "#238B45" "#005A32"]
    set mycolors(YlGn)     [list "#FFFFE5" "#F7FCB9" "#D9F0A3" "#ADDD8E" "#78C679" "#41AB5D" "#238443" "#005A32"]
    set mycolors(Reds)     [list "#FFF5F0" "#FEE0D2" "#FCBBA1" "#FC9272" "#FB6A4A" "#EF3B2C" "#CB181D" "#99000D"]
    set mycolors(OrRd)     [list "#FFF7EC" "#FEE8C8" "#FDD49E" "#FDBB84" "#FC8D59" "#EF6548" "#D7301F" "#990000"]
    set mycolors(BuPu)     [list "#F7FCFD" "#E0ECF4" "#BFD3E6" "#9EBCDA" "#8C96C6" "#8C6BB1" "#88419D" "#6E016B"]
    set mycolors(YlGnBu)   [list "#FFFFD9" "#EDF8B1" "#C7E9B4" "#7FCDBB" "#41B6C4" "#1D91C0" "#225EA8" "#0C2C84"]
    set mycolors(YlOrBr)   [list "#FFFFE5" "#FFF7BC" "#FEE391" "#FEC44F" "#FE9929" "#EC7014" "#CC4C02" "#CC4C02"]
    set mycolors(YlOrRd)   [list "#FFFFCC" "#FFEDA0" "#FED976" "#FEB24C" "#FD8D3C" "#FC4E2A" "#E31A1C" "#B10026"]
    set mycolors(Purples)  [list "#FCFBFD" "#EFEDF5" "#DADAEB" "#BCBDDC" "#9E9AC8" "#807DBA" "#6A51A3" "#4A1486"]
    set mycolors(Paired)   [list "#A6CEE3" "#1F78B4" "#B2DF8A" "#33A02C" "#FB9A99" "#E31A1C" "#FDBF6F" "#FF7F00"]
    set mycolors(Accent)   [list "#7FC97F" "#BEAED4" "#FDC086" "#FFFF99" "#386CB0" "#F0027F" "#BF5B17" "#666666"]
    set mycolors(Set1)     [list "#E41A1C" "#377EB8" "#4DAF4A" "#984EA3" "#FF7F00" "#FFFF33" "#A65628" "#F781BF"]
    set mycolors(Set2)     [list "#66C2A5" "#FC8D62" "#8DA0CB" "#E78AC3" "#A6D854" "#FFD92F" "#E5C494" "#B3B3B3"]
    set mycolors(Set3)     [list "#8DD3C7" "#FFFFB3" "#BEBADA" "#FB8072" "#80B1D3" "#FDB462" "#B3DE69" "#FCCDE5"]
    set mycolors(Dark2)    [list "#1B9E77" "#D95F02" "#7570B3" "#E7298A" "#66A61E" "#E6AB02" "#A6761D" "#666666"]
    set mycolors(Pastel1)  [list "#FBB4AE" "#B3CDE3" "#CCEBC5" "#DECBE4" "#FED9A6" "#FFFFCC" "#E5D8BD" "#FDDAEC"]
    set mycolors(Pastel2)  [list "#B3E2CD" "#FDCDAC" "#CDB5E8" "#F4CAE4" "#D6F5C9" "#FFF2AE" "#F1E2CC" "#CCCCCC"]
    set mycolors(PRGn)     [list "#762A83" "#9970AB" "#C2A5CF" "#E7D4E8" "#D9F0D3" "#A6DBA0" "#5AAE61" "#1B7837"]
    set mycolors(RdGy)     [list "#B2182B" "#D6604D" "#F4A582" "#FDDBC7" "#E0E0E0" "#BABABA" "#878787" "#4D4D4D"]
    set mycolors(PuOr)     [list "#B35806" "#E08214" "#FDB863" "#FEE0B6" "#D8DAEB" "#B2ABD2" "#8073AC" "#542788"]
    set mycolors(RdYlBu)   [list "#D73027" "#F46D43" "#FDAE61" "#FEE090" "#E0F3F8" "#ABD9E9" "#74ADD1" "#4575B4"]
    set mycolors(RdYlGn)   [list "#D73027" "#F46D43" "#FDAE61" "#FEE08B" "#D9EF8B" "#A6D96A" "#66BD63" "#1A9850"]
    set mycolors(Spectral) [list "#D53E4F" "#F46D43" "#FDAE61" "#FEE08B" "#E6F598" "#ABDDA4" "#66C2A5" "#3288BD"]
    set mycolors(RdBu)     [list "#B2182B" "#D6604D" "#F4A582" "#FDDBC7" "#D1E5F0" "#92C5DE" "#4393C3" "#2166AC"]
    set mycolors(BrBG)     [list "#8C510A" "#BF812D" "#DFC27D" "#F6E8C3" "#C7EAE5" "#80CDC1" "#35978F" "#01665E"]
    set mycolors(PiYG)     [list "#C51B7D" "#DE77AE" "#F1B6DA" "#FDE0EF" "#E6F5D0" "#B8E186" "#7FBC41" "#4D9221"]

    ## Matlab (specified as RGB tuples)
    set mycolors(jet)      [list  {0 0 256} {0 128 256} {0 256 256} {128 256 128} {256 256 0} {256 128 0} {256 0 0} {128 0 0}]
    set mycolors(hsv)      [list  {256 0 0} {256 192 0} {128 256 0} {0 256 64} {0 256 256} {0 64 256} {128 0 256} {256 0 192}]
    set mycolors(hot)      [list  {85.3 0 0} {170.6 0 0} {256 0 0} {256 85.3 0} {256 170.6 0} {256 256 0} {256 256 128} {256 256 256}] 
    set mycolors(cool)     [list {0 256 256} {37 219 256} {73 183 256} {110 146 256} {146 110 256} {183 73 256} {219 37 256} {256 0 256}]
    set mycolors(spring)   [list {256 0 256} {256 37 219} {256 73 183} {256 110 146} {256 146 110} {256 183 73} {256 219 37} {256 256 0}] 
    set mycolors(summer)   [list {0 128 102} {37 146 102} {73 165 102} {110 183 102} {146 201 102} {183 219 102} {219 238 102} {256 256 102}]
    set mycolors(autumn)   [list {256 0 0} {256 37 0} {256 73 0} {256 110 0} {256 146 0} {256 183 0} {256 219 0} {256 256 0}]
    set mycolors(winter)   [list {0 0 256} {0 37 238} {0 73 219} {0 110 201} {0 146 183} {0 183 165} {0 219 146} {0 256 128}]
    set mycolors(copper)   [list {0 0 0} {46 29 18} {91 57 36} {137 86 55} {183 114 73} {229 143 91} {256 171 109} {256 200 127}]
    set mycolors(pink)     [list {85 0 0} {144 79 79} {185 112 112} {201 161 137} {216 199 158} {230 230 177} {244 244 220} {256 256 256}]
    set mycolors(bone)     [list {0 0 11} {32 32 53} {64 64 96} {96 107 128} {128 149 160} {160 192 192} {208 224 224} {256 256 256}]

    ## Custom
    set mycolors(rainbow) [list "#FF0000" "#FF7F00" "#FFFF00" "#00FF00" "#0000FF" "#4B0082" "#8B00FF"]
    set mycolors(bw)      [list "#000000" "#FFFFFF"]
}

## Load default colors
setmycolors