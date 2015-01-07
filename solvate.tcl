# A Better solvation script?

proc mysolvate {molid {minmax box} {orient 1} {trim 1} {pad {0 0 0}} {waterbox {psf pdb}}} {

    package require topotools

    ## Default Waterbox location pdb and psf
    set wbpath $::env(VMD_HOME)/lib/plugins/noarch/tcl/solvate1.6
    set wbpsf "$wbpath/wat.psf"
    set wbpdb "$wbpath/wat.pdb"

    if {[string match "top" $molid]} {
        set molid [molinfo top]
    }

    ## Orient the solute so that its inertial axis corresponds with the laboratory axis
    ## This minimizes the volume of the subsequent solvent box
    if {$orient} {

        set niter 100; # Maximum number of alignment iterations
        set sel [atomselect top "all"]

        ## Bring molecule com to origin
        $sel moveby [vecinvert [measure center $sel weight mass]]

        ## Force alignment convergence
        ## I'm not sure why this can't be done in one-shot? wtf?
        set n 0; set vx2 0.0; set vz2 0.0
        while { $n < $niter && $vx2 < 0.99 && $vz2 < 0.99} {

            ## Align the x principle axes with the laboratory x-axis
            set m [measure inertia $sel]; set v [lindex $m {1 0}]; $sel move [mytransvecinv x $v]
            lassign $v vx1 vy1 vz1

            ## Align the z principle axes with the laboratory z-axis
            set m [measure inertia $sel]; set v [lindex $m {1 2}]; $sel move [mytransvecinv z $v]
            lassign $v vx2 vy2 vz2

            incr n
        }

        vmdcon -info "Aligned inertial axes in $n steps"

        $sel delete
    }

    ## Calculate the solute box dimensions, solvate will fill this
    ## volume by default
    if {[string match "box" $minmax]} {
        ## Get solvent box dimensions from pbc dimenstions
        set box [molinfo $molid get {a b c}]
        set box [vecadd $box [vecscale 2.0 $pad]]

    } elseif {[string match "guess" $minmax]} {
        ## Guess the dimensions based on the solute
        set sel [atomselect $molid "all"]
        set minmax [measure minmax $sel -withradii]
        set box [vecinvert [vecsub {*}$minmax]]
        set box [vecadd $box [vecscale 2.0 $pad]]
        $sel delete

    } else {
        ## Use the user-specified values
        set box [vecinvert [vecsub {*}$minmax]]
        set box [vecadd $box [vecscale 2.0 $pad]]
    }

    ## Set mix/max values based on determined box dimensions
    ## {{xmin ymin zmin} {xmax ymax zmax}}
    set boxby2 [vecscale $box 0.5]
    set minmax [list [vecinvert $boxby2] $boxby2]

    ## Check for weird/no box dimensions
    if {[vecsum $box] < 1.0} {vmdcon -err "Check box dimensions"; return}

    ## Check what solvent box we're using, waterbox by default
    if {[string compare $waterbox "psf pdb"] != 0} {
        lassign $waterbox wbpsf wbpdb
    }

    if {[catch {mol new $wbpsf type psf waitfor all} wb]} {
        vmdcon -err "Can't find solvent box template: $wb"
        return -code error
    }

    if {[catch {mol addfile $wbpdb type pdb mol $wb} wb]} {
        vmdcon -err "Can't find solvent box template: $wb"
        return -code error
    }

    ## Make sure the waterbox is at the origin
    set sel [atomselect $wb "all"]
    $sel moveby [vecinvert [measure center $sel weight mass]]

    ## Get the template waterbox dimensions, set the pbc size
    set wbdims [vecinvert [vecsub {*}[measure minmax $sel]]]
    molinfo $wb set {a b c} $wbdims

    $sel delete

    ## Calculate fractional units of the pbc-box w.r.t. the solvent box
    set frac {}
    foreach x $box y $wbdims {
        lappend frac [expr {ceil(abs($x / $y))}]
    }

    ## Check if we need to replicate the box
    if {[vecsum $frac] > 3} {
        vmdcon -info "Replicating Solvent Template [join $frac x]"
        set wb_new [::TopoTools::replicatemol $wb {*}$frac]
        mol delete $wb; set wb $wb_new
    }

    ## Make sure the minimums correspond so that if we specify a minimum,
    ## that is an absolute minimum for which water molecules will be added
    set sel [atomselect $wb "all"]
    $sel moveby [vecsub [lindex $minmax 0] [lindex [measure minmax $sel] 0]]
    $sel delete

    set solute [atomselect $molid "all"]
    set nsolute [$solute num]
    atomselect macro solute "index < $nsolute"
    atomselect macro solvent "index >= $nsolute"

    ## Trim the box dimensions with a selection
    lassign [join $minmax] xmin ymin zmin xmax ymax zmax
    set wbsel [atomselect $wb "same residue as (x >= $xmin and x <= $xmax and y >= $ymin\
                            and y <= $ymax and z >= $zmin and z <= $zmax)"]

    ## Combine the molecules
    if {[catch {::TopoTools::selections2mol [list $solute $wbsel]} newmol]} {
        vmdcon -err "Can't catenate solvent box and solute molecules"
        return -code error $newmol
    }

    ## Cleanup
    $wbsel delete
    $solute delete
    mol delete $wb

    ## Remove solvent molcules within 2.4 A of the solute
    if {$trim} {

        set sel [atomselect $newmol "not (same residue as ((within 2.4 of solute) and solvent))"]

        if {[catch {::TopoTools::selections2mol $sel} mol]} {
            vmdcon -err "Can't trim the solvent from around the solute"
            return -code error $mol
        }

        $sel delete
        mol delete $newmol
        set newmol $mol
    }

    ### Set the box dimensions
    set sel [atomselect $newmol "all"]
    molinfo $newmol set {a b c} [vecinvert [vecsub {*}[measure minmax $sel -withradii]]]
    $sel delete

    ## Return created molecule
    return $newmol
}
