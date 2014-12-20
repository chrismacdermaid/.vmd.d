## Resort atom names for each residue
proc lsortnames {args} {
  set newargs [lrange $args 0 end-1]
  set s [lindex $args end]
  return [lsort {*}$newargs -command ::aanameCompare $s] 
}

## Comparison function for aa atom names 
proc aanameCompare {a b} {

  set rank {N CA CB CG SG OG CG1 OG1 CG2 CD SD CD1 ND1\
    OD1 CD2 OD2 ND2 CE NE CE1 OE1 NE1 CE2 OE2 NE2\
    CE3 CZ CZ2 CZ3 NZ OH CH2 NH1 NH2 C O}

  set aidx [lsearch -exact -ascii $rank $a]
  set bidx [lsearch -exact -ascii $rank $b]

  if {$aidx == -1 || $bidx == -1} {
      return [string compare $a $b]
  }

  if {$aidx > $bidx} {return 1} elseif {$aidx < $bidx} {return -1}

  return [string compare $a $b]
}
