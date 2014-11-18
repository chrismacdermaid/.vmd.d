# A Better solvation script

proc mysolvate {molid {minmax box} {trim 0}} {

    package require topotools

    if {[string match "top" $molid]} {
	set molid [molinfo top]
    }

    ## Calculate the solute box dimensions, solvate will fill this
    ## volume by default
    if {[string match "box" $minmax]} {
	set box [molinfo $molid get {a b c}]
	set boxby2 [vecscale $box 0.5]

	## {{xmin ymin zmin} {xmax ymax zmax}}
	set minmax [list [vecinvert $boxby2] $boxby2]

    } else {
	set box [vecinvert [vecsub {*}$minmax]]
	set boxby2 [vecscale $box 0.5]
    }
    
    ## Waterbox location
    set wbpath $::env(VMD_HOME)/lib/plugins/noarch/tcl/solvate1.6 

    if {[catch {mol new $wbpath/wat.psf type psf} wb]} {
	vmdcon -err "Can't find waterbox template: $wb"
	return -code error
    }

    if {[catch {mol addfile $wbpath/wat.pdb type pdb mol $wb} wb]} {
	vmdcon -err "Can't find waterbox template: $wb"
	return -code error
    }

    ## Make sure the waterbox is at the origin
    set sel [atomselect $wb "all"]
    $sel moveby [vecinvert [measure center $sel weight mass]]
    
    ## Get the template waterbox dimensions, set the pbc size
    set wbdims [vecinvert [vecsub {*}[measure minmax $sel]]]
    molinfo $wb set {a b c} $wbdims

    ## Give the solvent a unique identifier
    $sel set segname TK421
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

    ## Trim the box dimensions with a selection 
    lassign [join $minmax] xmin ymin zmin xmax ymax zmax
    set wbsel [atomselect $wb "same residue as (x >= $xmin and x <= $xmax and y >= $ymin\
 and y <= $ymax and z >= $zmin and z <= $zmax)"]

    ## Combine the molecules and return
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

	set sel [atomselect $newmol "same residue as (within 2.4 of (not segname TK421)) and segname TK421"]

	if {[catch {::TopoTools::selections2mol $sel} mol]} {
	    vmdcon -err "Can't trim the solvent from around the solute"
	    return -code error $mol
	}

	$sel delete
	mol delete $newmol
	set newmol $mol
    }

    ## Set the box dimensions
    set sel [atomselect $newmol "all"]
    molinfo $newmol set {a b c} [vecinvert [vecsub {*}[measure minmax $sel -withradii]]]
    $sel delete

    ## Return created molecule
    return $newmol
}
