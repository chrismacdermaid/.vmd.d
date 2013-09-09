## Wrap the mol command with some convenient
## options

proc moll { args } {

    set retval -1

    set cmd [lindex $args 0]
    set newargs [lrange $args 1 end]

    switch -- $cmd {

        new {
            set filename [lindex $newargs 0]
            set retval [mol new [file normalize $filename] {*}[lrange $newargs 1 end]]
        }

        addfile {

	    lappend newargs waitfor all

            set filename [lindex $newargs 0]
            set retval [mol addfile [file normalize $filename] {*}[lrange $newargs 1 end]]
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
