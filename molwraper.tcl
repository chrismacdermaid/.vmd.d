## Wrap the mol command with some convenient
## options

proc moll { args } {

    set retval -1

    set cmd [lindex $args 0]
    set newargs [lrange $args 1 end]

    switch -- $cmd {

        new {
            set filename [lindex $newargs 0]

            if {[string match "*.data" $filename]} {
                ## Assume lammps data
                catch {topo readlammpsdata\
                  [file normalize [glob $filename]]} retval
            } else {
                catch {mol new [file normalize [glob $filename]]\
                           {*}[lrange $newargs 1 end]} retval
            }
        }

        addfile {

            lappend newargs waitfor all

            set filename [lindex $newargs 0]
            catch {mol addfile [file normalize [glob $filename]]\
                       {*}[lrange $newargs 1 end]} retval
        }

        -f {

            set retval [moll new [lindex $newargs 0]]

            ## Check for wildcards..
            foreach filename [lrange $newargs 1 end] {
                foreach f [striplist [lsort -dictionary [glob $filename]]] {
                    moll addfile $f
                }
            }
        }

        xst -
        xsc {

            ## Load an XSC file, quite a bit more convenient than pbctools
            set filename [lindex $newargs 0]
            if {[catch {exec tail -1 $filename} data]} {
                vmdcon -err "$data"
                return -code error -1
            }

            lassign $data id ax ay az bx by bz cx cy cz
            if {[catch {molinfo top set {a b c} [list $ax $by $cz]} msg]} {
                vmdcon -err "Can't set box dimensions: $msg"
                return -code error -1
            }

            ## Provide the dimensions as a return value
            set retval [list $ax $by $cz]
        }

        reload {
            if {[lsearch -ascii [info procs] reload] < 0} {
                return -code 1 "Reload command currently unavailable"
            }

            set retval [reload {*}$newargs]
        }

        default {set retval [mol {*}$args]}

    }

    return $retval
}
