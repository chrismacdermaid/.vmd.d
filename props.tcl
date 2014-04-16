## Calculate density

proc get_density {molid} {

 ##Volume (\A**3)
 lassign [molinfo $molid get {a b c}] a b c
 set V [expr {$a * $b * $c}]

 ## Mass (g/mol)
 set sel [atomselect $molid "all"]      
 set mass [vecsum [$sel get mass]]
 $sel delete 

return [expr {$mass / $V * 1.660539}] 

}
