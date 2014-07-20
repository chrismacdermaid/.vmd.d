## Make a psf file from a molid.Try to be intellegent
## about the fragments, segments etc.. No guarantees!
## check it when it's done.
proc make_psf {mollist {topologies def} {suffix clock}} {

    global env

    package require psfgen

    ## Reanalyze mol since we use some built in vmd macros below
    foreach mol $mollist {
        mol reanalyze $mol
    }

    ## Cleanup psfgen
    psfcontext reset

    ## If no topologies, load the defaults
    ## This could be abused, be careful and don't assume you're
    ## using the correct file.
    if {$topologies == "def"} {
        set topologies [glob -directory $env(HOME)/params/default top*.rtf]
    }

    ## Load the topologies
    foreach top $topologies {
        topology $top
    }

    ## Process each molid into a single psf
    ## Unique segment identifier per-residue name
    set segidx 0
    set segidx2 0

    foreach mol $mollist {

        ## Identify molecules with the same resnames, do waters
        ## separately since we need a lot of them per segment

        set sel [atomselect $mol "not (water or protein)"]
        set resnames [lsort -unique -ascii [$sel get resname]]

        set fragsperseg_list {}
        set opt_list {}
        if {[$sel num] > 0} {
            set fragsperseg_list [lrepeat [llength $resnames] 2000]
            set opt_list [lrepeat [llength $resnames] ""]
        }

        $sel delete

        set sel [atomselect $mol "water"]
        set solventnames [lsort -unique -ascii [$sel get resname]]
        $sel delete

        ## Special options for water
        if {[llength $solventnames] > 0} {
            set resnames [list {*}$resnames $solventnames]
            lappend fragsperseg_list 5000
            lappend opt_list "auto none"
        }

        foreach rn $resnames fragperseg $fragsperseg_list opt $opt_list {

            set sel [atomselect $mol "resname $rn"]
            set fragments [lsort -unique -increasing -integer -index 0 [$sel get fragment]]
            $sel delete

            ## Unique segment index fragment size
            set segidx2 0

            ## Total number of fragments with this residue name
            set nfragments [llength $fragments]

            for {set off 0} {$off < $nfragments} {incr off $fragperseg} {

                #Set the segment name to residue_seg_idx + seg_index
                set segname "$segidx$segidx2"

                ## Make the segments each having a maximum of fragsperseg fragments
                set subfragments [lrange $fragments $off [expr {$off+$fragperseg-1}]]

                segment $segname {

                    set outname [format "%s_%s.pdb" $segname $rn]
                    set sel [atomselect $mol "fragment $subfragments"]

                    ## Renumber the resids so they don't overlap.
                    set n1 [$sel num]; set n2 [llength $subfragments]

                    ## Check if n2 cleanly divides n1 (no missing atoms),
                    ## this is not fool-proof but should work most of the
                    ## time
                    if {[expr {$n1 % $n2}] != 0} { #; Slow, but OK for missing atoms
                        set resid 1
                        foreach f $subfragments {
                            set sel2 [atomselect $mol "fragment $f"]
                            $sel2 set resid $resid
                            $sel2 delete
                            incr resid
                        }

                    } else { #; Fast, but assumes all fragments have the same number of atoms

                        set n2 [expr {$n1 / $n2}]; # This assumes no missing atoms...
                        set resids {}
                        for {set i 1; set j 0} {$j < $n1} {incr i; incr j $n2} {lappend resids [lrepeat $n2 $i]};
                        $sel set resid [join $resids]
                    }

                    ## Writeout the PDB for the collection of fragments
                    $sel set segname $segname
                    $sel writepdb $outname
                    $sel delete

                    ## Segment dependent opts
                    eval $opt

                    ## Read pdb
                    pdb $outname

                    first none
                    last none
                }

                ## Load the coordinates into the segments
                set inname [format "%s_%s.pdb" $segname $rn]
                coordpdb $inname $segname

                ## delete the file since we don't need it anymore
                file delete -force $inname

                incr segidx2
            }

            incr segidx
        }

        set sel [atomselect $mol "protein"]
        set protein_fragments [lsort -unique -integer -increasing [$sel get fragment]]
        $sel delete

        ## Each protein gets its own segment
        if {[llength $protein_fragments] > 0} {
            foreach fragment $protein_fragments {

                #Set the segment name to residue_seg_idx + seg_index
                set segname "$segidx$segidx2"

                segment $segname {
                    set outname [format "%s_%s.pdb" $segname $fragment]
                    set sel [atomselect $mol "fragment $fragment"]

                    ## Writeout the PDB for the collection of fragments
                    $sel set segname $segname
                    $sel writepdb $outname
                    $sel delete

                    ## Read pdb
                    pdb $outname

                    if {0} {
                        first NTER
                        last CTER
                    } else { ;#Acelyated N terminus, amidated c terminus
                        first ACE
                        last CT2
                    }

                }
                coordpdb $outname $segname

                ## delete the file since we don't need it anymore
                file delete -force $outname

                incr segidx2
            }
        }
        incr segidx
    }

    ## Guess missing coordinates
    guesscoord

    foreach mol $mollist {
        lassign [molinfo $mol get name] pdb
        lappend names [file rootname $pdb]
    }

    set fname [join $names "-"]
    if {$suffix == "clock"} { 
     set suffix "_[clock seconds]"
    }
   
    #set psf $fname$suffix\.psf
    #set pdb $fname$suffix\.pdb
   
    set psf $suffix\.psf
    set pdb $suffix\.pdb

    writepsf $psf
    writepdb $pdb

    if {[catch {mol new $psf type psf waitfor all} newmol]} {
        vmdcon -err "Unable to load file $psf: $newmol"
        return
    }
    mol addfile $pdb type pdb waitfor all molid $newmol

    return $newmol
}

## Assumes only one 1 residue in the mol
## or that there are no residue number dupes
## and that there are < 9999 of them
proc make_psf_1res {mol {topologies def}} {

    global env

    package require psfgen

    ## Cleanup psfgen
    psfcontext reset

    ## If no topologies, load the defaults
    ## This could be abused, be careful and don't assume you're
    ## using the correct file.
    if {$topologies == "def"} {
        set topologies [glob -directory $env(HOME)/params/default top*.rtf]
    }

    ## Load the topologies
    foreach top $topologies {
        topology $top
    }

    set segname 0000

    set sel [atomselect $mol "all"]
    #set segname [lsort -unique [$sel get resname]]
    #$sel set resid 1
    $sel writepdb /tmp/$segname\.pdb
    #$sel delete

    segment $segname {

        ## Read pdb
        pdb /tmp/$segname\.pdb

        first none
        last none
    }

    coordpdb /tmp/$segname\.pdb $segname

    ## Guess missing coordinates
    guesscoord

    ## delete the file since we don't need it anymore
    file delete -force /tmp/$segname\.pdb

    ## Write out PSF/PDB and load it up
    lassign [molinfo $mol get name] pdb
    set fname [file rootname $pdb]

    set seconds [clock seconds]

    set psf $fname\_$seconds\.psf
    set pdb $fname\_$seconds\.pdb

    writepsf $psf
    writepdb $pdb

    if {[catch {mol new $psf type psf waitfor all} newmol]} {
        vmdcon -err "Unable to load file $psf: $newmol"
    }
    mol addfile $pdb type pdb waitfor all molid $newmol

    return $newmol
}
