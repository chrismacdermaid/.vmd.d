# Scripts to save (and restore) VMD viewpoints and animate
# a smooth 'camera move' between them.
#
#VMD  --- start of VMD description block
#Name:
# view_change
#Synopsis:
# Four commands to save (and restore) VMD viewpoints, and animate
# a smooth 'camera move' between them.
#Version:
# 1.0
#Uses VMD version:
# 1.1
#Ease of use:
# 2
#Procedures:
# <li> save_viewpoint - save current viewpoint
# <li> restore_viewpoint - change  current viewpoint  to a saved one
# <li> move_view - smoothly move between saved viewpoints (see Warning)
# <li> write_viewpoints - write viewpoints to a disk file (read back in via 'source')
#
# Warning: this script does the math cheaply, i.e. only interpolates
# transformation matrices, many sorts of extreme viewpoint changes will look
# odd to bizzare. This is often cured by segmenting a drastic camera move into
# smaller ones.
#
#
#
# Usage:
# In the vmd console type
#       save_viewpoint 1
# to save your current viewpoint
#
# type
#       restore_viewpoint 1
# to restore that viewpoint  (You can replace '1' with an integer < 10000)
#
# After you've saved more than 1 viewpoint
#       move_view 1 43
# will restore viewpoint 1, then smoothly move to viewpoint 43.
#  Note warning above.  Extreme moves that cause obvious protein distortion
#can be done in two or three steps.
#
# To specify animation frames used, use
#    move_view 1 43 200
# will move from viewpoint 1 to 43 in 200 steps.  If this is not specified, a
# default 50 frames is used
#
# To specify smooth/jerky accelaration, use
#   move_view 1 43 200 smooth
#   or
#   move_view 1 43 200 sharp
#
# the 'smooth' option accelerates and deccelrates the transformation
# the 'sharp' option gives constant velocity
#
# To write viewpoints to a file,
# write_viewpoints my_viewpoint_file.tcl
#
# viewpoints with integer numbers 0-10000 are saved
#
# To restore viewpoints from a file,
# source my_viewpoint_file.tcl
#
#
#See also:
# the VMD user's guide
#Author:
# Barry Isralewitz &lt;barryi@ks.uiuc.edu&gt;
#Url:
# http://www.ks.uiuc.edu/Research/vmd/script_library/view_change/
#\VMD  --- end of block
proc scale_mat {mat scaling} {
    set bigger ""
    set outmat ""
    for {set i 0} {$i<=3} {incr i} {
        set r ""
        for {set j 0} {$j<=3} {incr j} {
            lappend r  [expr $scaling * [lindex [lindex [lindex $mat 0] $i] $j] ]
        }
        lappend outmat  $r
    }
    lappend bigger $outmat
    return $bigger
}

proc div_mat {mat1 mat2} {
    set bigger ""
    set outmat ""
    for {set i 0} {$i<=3} {incr i} {
        set r ""
        for {set j 0} {$j<=3} {incr j} {
            lappend r  [expr  (0.0 + [lindex [lindex [lindex $mat1 0] $i] $j]) / ( [lindex [lindex [lindex $mat2 0] $i] $j] )]

        }
        lappend outmat  $r
    }
    lappend bigger $outmat
    return $bigger
}

proc sub_mat {mat1 mat2} {
    set bigger ""
    set outmat ""
    for {set i 0} {$i<=3} {incr i} {
        set r ""
        for {set j 0} {$j<=3} {incr j} {
            lappend r  [expr  (0.0 + [lindex [lindex [lindex $mat1 0] $i] $j]) - ( [lindex [lindex [lindex $mat2 0] $i] $j] )]

        }
        lappend outmat  $r
    }
    lappend bigger $outmat
    return $bigger
}

proc power_mat {mat thePower} {
    set bigger ""
    set outmat ""
    for {set i 0} {$i<=3} {incr i} {
        set r ""
        for {set j 0} {$j<=3} {incr j} {
            lappend r  [expr pow( [lindex [lindex [lindex $mat 0] $i] $j], $thePower)]
        }
        lappend outmat  $r
    }
    lappend bigger $outmat
    return $bigger
}

proc mult_mat {mat1 mat2} {
    set bigger ""
    set outmat ""
    for {set i 0} {$i<=3} {incr i} {
        set r ""
        for {set j 0} {$j<=3} {incr j} {
            lappend r  [expr  (0.0 + [lindex [lindex [lindex $mat1 0] $i] $j]) * [lindex [lindex [lindex $mat2 0] $i] $j] ]
        }
        lappend outmat  $r
    }
    lappend bigger $outmat
    return $bigger
}

proc add_mat {mat1 mat2} {
    set bigger ""
    set outmat ""
    for {set i 0} {$i<=3} {incr i} {
        set r ""
        for {set j 0} {$j<=3} {incr j} {
            lappend r  [expr  (0.0 + [lindex [lindex [lindex $mat1 0] $i] $j]) + [lindex [lindex [lindex $mat2 0] $i] $j] ]
        }
        lappend outmat  $r
    }
    lappend bigger $outmat
    return $bigger
}


proc write_viewpoints {filename} {
    global viewpoints

    set myfile [open $filename w]
    puts $myfile "\#This file contains viewpoints for a VMD script, view_change.tcl.\n\#Type 'source $filename' from the VMD command window to load these viewpoints.\n"

    puts $myfile "array set viewpoints [list [array get viewpoints]]"

    #foreach mol [molinfo list] {
    #    
    #    foreach {key value} [array get viewpoints *] {
    #      puts $key
    #        lassign [split $key ","] v mol id 
    #            for {set mat 0} {$mat <= 3} {incr mat} {
    #                puts $myfile "set viewpoints($v,$mol,$mat) { $viewpoints($v,$mol,$mat) }\n "
    #            }
    #          }
    #    #for {set v 0} {$v<=10000} {incr v} {
    #    #    if  [info exists viewpoints($v,$mol,0)] {
    #    #        for {set mat 0} {$mat <= 3} {incr mat} {
    #    #            puts $myfile "set viewpoints($v,$mol,$mat) { $viewpoints($v,$mol,$mat) }\n "
    #    #        }
    #    #    }
    #    #}
    #}
    puts $myfile "puts \"\\nLoaded viewpoints file $filename \\n\"\n"
    close $myfile
}

proc save_viewpoint {view_num {mollist "all"}} {
    global viewpoints

    catch {unset viewpoints($view_num)}

    if {$mollist == "all"} {
        set mollist [molinfo list]
    }

    # get the current matricies
    foreach mol $mollist {
        set viewpoints($view_num,$mol,0) [molinfo $mol get rotate_matrix]
        set viewpoints($view_num,$mol,1) [molinfo $mol get center_matrix]
        set viewpoints($view_num,$mol,2) [molinfo $mol get scale_matrix]
        set viewpoints($view_num,$mol,3) [molinfo $mol get global_matrix]
    }
}

proc restore_viewpoint {view_num {mollist "all"}} {
    global viewpoints

    if {$mollist == "all"} {
        set mollist [molinfo list]
    }

    foreach mol $mollist {
        if [info exists viewpoints($view_num,$mol,0)] {
            molinfo $mol set rotate_matrix   $viewpoints($view_num,$mol,0)
            molinfo $mol set center_matrix   $viewpoints($view_num,$mol,1)
            molinfo $mol set scale_matrix   $viewpoints($view_num,$mol,2)
            molinfo $mol set global_matrix   $viewpoints($view_num,$mol,3)
        } else {
            puts "View $view_num was not saved"}
    }
}

proc cpy_viewpoint {view_num index mol} {

    ## applies viewpoint to molid

    global viewpoints

    ## get the molid of the viewpoint to copy
    lassign [array get viewpoints $view_num,$index,0] key value
    lassign [split $key ","] x cpymol id

    ## Apply the viewpoints
    if [info exists viewpoints($view_num,$cpymol,0)] {
        molinfo $mol set rotate_matrix   $viewpoints($view_num,$cpymol,0)
        molinfo $mol set center_matrix   $viewpoints($view_num,$cpymol,1)
        molinfo $mol set scale_matrix   $viewpoints($view_num,$cpymol,2)
        molinfo $mol set global_matrix   $viewpoints($view_num,$cpymol,3)
    }
}

proc move_view {start end {morph_frames 50} {accel smooth} } {
    global viewpoints


    foreach mol [molinfo list] {

        if [info exists viewpoints($start,$mol,0)] {
            set old_rotate($mol)  $viewpoints($start,$mol,0)
            set old_center($mol) $viewpoints($start,$mol,1)
            set old_scale($mol) $viewpoints($start,$mol,2)
            set old_global($mol)  $viewpoints($start,$mol,3)
        } else {
            puts "Starting view $start was not saved"}

        if [info exists viewpoints($end,$mol,0)] {
            set new_rotate($mol) $viewpoints($end,$mol,0)
            set new_center($mol) $viewpoints($end,$mol,1)
            set new_scale($mol) $viewpoints($end,$mol,2)
            set new_global($mol)  $viewpoints($end,$mol,3)
        } else {
            puts "Ending view $end was not saved"}

        #leave if don't have both viewpoints
        if {! ([info exists viewpoints($start,$mol,0)] && [info exists viewpoints($end,$mol,0)]) } {
            error "move_view failed"
        }

        set old_rotate($mol) $viewpoints($start,$mol,0)
        set old_center($mol) $viewpoints($start,$mol,1)
        set old_scale($mol) $viewpoints($start,$mol,2)
        set old_global($mol)  $viewpoints($start,$mol,3)


        restore_viewpoint $start

        set needed_rotate($mol) [sub_mat  $new_rotate($mol) $old_rotate($mol)]


        set needed_center($mol) [sub_mat  $new_center($mol) $old_center($mol)]


        set needed_scale($mol) [sub_mat  $new_scale($mol) $old_scale($mol)]


        set needed_global($mol) [sub_mat  $new_global($mol) $old_global($mol)]

    }

    for {set j 0} {$j<= ($morph_frames - 1)} {incr j} {
        foreach mol [molinfo list] {
            #set scaling to apply for this individual frame
            if {$accel == "smooth"} {
                #accelerate smoothkly to start and stop
                set theta [expr 3.1415927 * (0.0 + $j)/($morph_frames - 1)]
                set scale_factor [expr (1 -cos ($theta) ) /2]

            } else {
                #infinite acceleration to start and stop
                set scale_factor [expr (0.0 + $j)/($morph_frames - 1)]
            }

            if {$j == $morph_frames} {
                #correct for roundoff errors, so ends in correct position
                set scale_factor 1.0
            }

            set current_rotate($mol) [add_mat $old_rotate($mol) [
                                                                 scale_mat $needed_rotate($mol) $scale_factor]
                                     ]

            set current_center($mol) [add_mat $old_center($mol) [
                                                                 scale_mat $needed_center($mol) $scale_factor]
                                     ]

            set current_scale($mol)  [add_mat $old_scale($mol) [
                                                                scale_mat $needed_scale($mol) $scale_factor]
                                     ]

            set current_global($mol) [add_mat $old_global($mol) [
                                                                 scale_mat $needed_global($mol) $scale_factor]
                                     ]

            molinfo $mol set rotate_matrix $current_rotate($mol)
            molinfo $mol set center_matrix $current_center($mol)
            molinfo $mol set scale_matrix $current_scale($mol)
            molinfo $mol set global_matrix $current_global($mol)


        }
        display update
    }
}




