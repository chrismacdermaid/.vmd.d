## Read an opendx file into memory and manipulate the data

#         object 1 class gridpositions counts nx ny nz
#         origin xmin ymin zmin
#         delta hx 0.0 0.0
#         delta 0.0 hy 0.0
#         delta 0.0 0.0 hz
#         object 2 class gridconnections counts nx ny nz
#         object 3 class array type double rank 0 times n
#         u(0,0,0) u(0,0,1) u(0,0,2)
#         ...
#         u(0,0,nz-3) u(0,0,nz-2) u(0,0,nz-1)
#         u(0,1,0) u(0,1,1) u(0,1,2)
#         ...
#         u(0,1,nz-3) u(0,1,nz-2) u(0,1,nz-1)
#         ...
#         u(0,ny-3,nz-3) u(0,ny-2,nz-2) u(0,ny-1,nz-1)
#         u(1,0,0) u(1,0,1) u(1,0,2)
#         ...
#         attribute "dep" string "positions"
#         object "regular positions regular connections" class field
#         component "positions" value 1
#         component "connections" value 2
#         component "data" value 3


## Read Opendx file
proc read_dx {fname data} {

    upvar 1 $data dx_data

    ## Unset array holding any current dx data
    catch {[array unset dx_data]}

    ##open file
    set fid [open $fname "r"]

    array set dx_data {}
    set temp {}

    ## Loop over file, read line-by-line, match
    while {[gets $fid line] >= 0} {

        switch -regex $line {

            ## Comments
            {\#} {
                lappend dx_data(comments) $line
            }

            object*1* {
                scan $line "object 1 class gridpositions counts %i %i %i"\
                    dx_data(nx) dx_data(ny) dx_data(nz)
                continue
            }

            origin* {
                scan $line "origin %e %e %e"\
                    dx_data(xmin) dx_data(ymin) dx_data(zmin)
                continue
            }

            delta* {
                scan $line "delta %e %e %e" hx hy hz
                lappend delta $hx $hy $hz
                continue
            }

            {[-+]?[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?$} {
                ## Look for lines starting with some floatingpoints
                scan $line "%e %e %e" u1 u2 u3
                lappend temp $u1 $u2 $u3
                continue
            }

            default {continue}
        }
    }

    close $fid

    set dx_data(hx) [lindex $delta 0]
    set dx_data(hy) [lindex $delta 4]
    set dx_data(hz) [lindex $delta 8]

    ## Transpose u so that x dimension
    ## changes fastest, then y then z.
    ## Convert from kT/e =0.0256 V 
    upvar 0 dx_data(nx) nx
    upvar 0 dx_data(ny) ny
    upvar 0 dx_data(nz) nz

    set nyz [expr {$ny * $nz}]
    for {set k 0} {$k < $nz} {incr k} {
        for {set j 0} {$j < $ny} {incr j} {
            for {set i 0} {$i < $nx} {incr i} {
                set idx [expr {$i * $nyz + $j * $nz + $k}]
                lappend dx_data(u) [expr {[lindex $temp $idx] * 0.0256}]
            }
        }
    }

    #puts "Read [llength $temp] potential values"
    #puts "Read [llength $dx_data(u)] potential values"
    unset temp

    return -code ok
}

## Extract 2D contour from dx dataset
proc ex_dx {data {along X} {slice_offset 0.5}} {

    upvar $data dx_data

    if {[expr {$slice_offset > 1 || $slice_offset < 0}]} {
        return -code error
    }

    ## Create references to data
    ## e.g. upvar 0 dx_data(nx) nx
    foreach x [array names dx_data *] {
        upvar 0 dx_data($x) $x
    }

    set pot {}
    set grid {}
    switch -exact $along {

        X {
	    set ndim1 $nz; set ndim2 $ny
            set iso [expr {int($nx * $slice_offset)}]

            for {set i 0} {$i < $nz} {incr i} {
                set off [expr {$i * $nx * $ny}]
                for {set j 0} {$j < $ny} {incr j} {
                    lappend pot [lindex $u [expr {$off + $j * $nx + $iso}]]
                    lappend grid [expr {$ymin + $j * $hy}] [expr {$zmin + $i * $hz}]
                }
            }
        }


        Y {
	    set ndim1 $nz; set ndim2 $nx
            set iso [expr {int($ny * $slice_offset)}]
            set offset [expr {$iso * $nx}]

            for {set i 0} {$i < $nz} {incr i} {
                set off [expr {$i * $nx * $ny}]
                for {set j 0} {$j < $nx} {incr j} {
                    lappend pot [lindex $u [expr {$offset + $off + $j}]]
                    lappend grid [expr {$xmin + $j * $hx}] [expr {$zmin + $i * $hz}]
                }
            }
        }


        Z {
	    set ndim1 $ny; set ndim2 $nx
            set iso [expr {int($nz * $slice_offset)}]
            set offset [expr {$iso * $nx * $ny}]

            for {set i 0} {$i < $ny} {incr i} {
                set off [expr {$i * $nx}]
                for {set j 0} {$j < $nx} {incr j} {
                    lappend pot [lindex $u [expr {$offset + $off + $j}]]
                    lappend grid [expr {$xmin + $j * $hx}] [expr {$ymin + $i * $hy}]
                }
            }
        }
    }

    ## Output into something gnuplot understands    
    set i 0
    foreach p $pot {x y} $grid {
        puts [format "%10.4g %10.4g %10.4g" $x $y $p]
	incr i
	if {[expr {$i % $ndim2}] == 0} {puts -nonewline "\n"}
    }

    return -code ok
}

if {1} {
    lassign $argv fname along offset
    read_dx $fname dx
    ex_dx dx $along $offset
}
