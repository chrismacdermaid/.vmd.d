## Copies/saves/restores representations without
## having to deal with the save state stuff

global molreps;  ## Array for storing representations 

proc save_rep {index {mollist all}} {

  ## Saves representations to an array

  global molreps

  ## Clear reps stored in the index slot
  
  foreach {key rep} [array get molreps [list $index*]] {
     unset molreps($key)
  }


  if {$mollist == "all"} {
      set mollist [molinfo list] 
  }

  set j 0;
  foreach mol $mollist {
    set numreps [molinfo $mol get numreps]

    for {set i 0} {$i < $numreps} {incr i} {
      set rep [molinfo $mol get "{rep $i} {selection $i} {color $i} {material $i}"]
      lappend rep [mol showperiodic $mol $i]
      lappend rep [mol numperiodic $mol $i]
      lappend rep [mol showrep $mol $i]
      lappend rep [mol selupdate $i $mol]
      lappend rep [mol colupdate $i $mol]
      lappend rep [mol scaleminmax $mol $i]
      lappend rep [mol smoothrep $mol $i]
      lappend rep [mol drawframes $mol $i]
      set molreps([list $index $j $i $numreps]) $rep
      set rep {}
    }
    
    incr j
  }
}

proc restore_rep {index index2 {mollist all}} {

  global molreps

  if {$mollist == "all"} {
      set mollist [molinfo list] 
  }

  ## First clear all the existing representations
  foreach mol $mollist {
    set numreps [molinfo $mol get numreps]
    
    for {set i 0} {$i < $numreps} {incr i} {
      mol delrep 0 $mol
    }
  }      

  ## Restore representation to mol(s)
  foreach mol $mollist { 
    set j 0
     foreach key [lsort -integer -increasing -index 2 [array names molreps [list $index $index2*]]] {
        
        lassign $key aindex bindex i numreps   
        if {$j >= $numreps} {break}  
  
        lassign $molreps($key) r s c m pbc numpbc on selupd colupd colminmax smooth framespec

                eval "mol representation $r"
                eval "mol color $c"
                eval "mol selection {$s}"
                eval "mol material $m"
                eval "mol addrep $mol"
                if {[string length $pbc]} {
                  eval "mol showperiodic $mol $i $pbc"
                  eval "mol numperiodic $mol $i $numpbc"
                }

                eval "mol selupdate $i $mol $selupd"
                eval "mol colupdate $i $mol $colupd"
                eval "mol scaleminmax $mol $i $colminmax"
                eval "mol smoothrep $mol $i $smooth"
                eval "mol drawframes $mol $i {$framespec}"
                if { !$on } {
                  eval "mol showrep $mol $i 0"
        
                }
      
           incr j;     
        }
   }
}

proc restore_rep_all_2_all {index {mollist all}} {

  global molreps

  if {$mollist == "all"} {
      set mollist [molinfo list] 
  }

  ## First clear all the existing representations
  foreach mol $mollist {
    set numreps [molinfo $mol get numreps]
    
    for {set i 0} {$i < $numreps} {incr i} {
      mol delrep 0 $mol
    }
  }      

  ## Restore representation to mol(s)
  set k 0
  foreach mol $mollist {
    set j 0
     foreach key [lsort -integer -increasing -index 2 [array names molreps [list $index $k*]]] {
        
        lassign $key aindex bindex i numreps
        if {$j >= $numreps} {break}  
  
        lassign $molreps($key) r s c m pbc numpbc on selupd colupd colminmax smooth framespec

                eval "mol representation $r"
                eval "mol color $c"
                eval "mol selection {$s}"
                eval "mol material $m"
                eval "mol addrep $mol"
                if {[string length $pbc]} {
                  eval "mol showperiodic $mol $i $pbc"
                  eval "mol numperiodic $mol $i $numpbc"
                }

                eval "mol selupdate $i $mol $selupd"
                eval "mol colupdate $i $mol $colupd"
                eval "mol scaleminmax $mol $i $colminmax"
                eval "mol smoothrep $mol $i $smooth"
                eval "mol drawframes $mol $i {$framespec}"
                if { !$on } {
                  eval "mol showrep $mol $i 0"
        
                }
      
           incr j     
        }

        incr k
    }
}


proc write_rep {fname {index *}} {

  ## Write representation array to a file

  global molreps

  set outFile [open $fname w] 
   
  puts $outFile [list array set molreps [array get molreps [list $index*]]] 
  
  close $outFile 
}

proc read_rep {fname} {

  ## Restore representation array from file

  global molreps

  array unset molreps

  source $fname
}
