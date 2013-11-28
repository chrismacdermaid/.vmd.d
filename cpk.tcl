## Use a repid id and create 3 copies with representations:
## 1. seltext and "C.*"
## 2. seltext and "O.*"
## 3. seltext and "N.*"

proc cpk {repid {molid top}} {

    if {$molid == "top"} {
        set molid [molinfo top]
    }

    ## Selection text
    set seltext [molinfo $molid get "{selection $repid}"]

    ## Color
    set colorid [molinfo $molid get "{color $repid}"]

    ## Molinfo properties
    catch {array unset rep}

    foreach x {rep material} {
        set rep($x) [molinfo $molid get "{$x $repid}"]
    } 

    ## Mol properties
    foreach x {numperiodic showperiodic
        scaleminmax smoothrep drawframes} {
        set rep($x) [list $molid $repid [mol $x $molid $repid]]
    }

    ## More mol properties (WTF? why reverse molid/repid?)
    foreach x {selupdate colupdate} {
	set rep($x) [list $repid $molid [mol $x $repid $molid]]
    }

    ## Create the selections and set properties
    foreach x {\"C.*\" \"O.*\" \"N.*\"} color [list $colorid "ColorID 1" "ColorID 0"] {
	mol selection "name $x and ($seltext)"
	mol color {*}$color
	mol addrep $molid
	foreach {prop val} [array get rep *] {
	    mol $prop {*}[join $val]
	}
    }
}


## Make a lookup of all reps in vmd indexed by {molid repid}
proc get_reps {{molid "all"}} {

    global reps

    catch {array unset reps}

    if {$molid == "all"} {
        set molid [molinfo list]
    }

    set N [molinfo $x get numreps]

    foreach x $molid {
        for {set i 0} {$i < $N} {incr i} {
            lassign [molinfo $x get "{rep $i} {selection $i}"] rep sel
            set reps([list $x $i]) [list $rep $sel]
        }
    }

    parray reps
}

proc set_reps {molid prop val {repids "all"}} {

    set N [molinfo $x get numreps]

    if {$repids == "all"} {
	set repids {}
	for {set i 0} {$i < $N} {incr i} {lappend repids $i}
    }

    foreach r $repids {
	mol $prop $molid $r {*}[join $val]
    }
}
