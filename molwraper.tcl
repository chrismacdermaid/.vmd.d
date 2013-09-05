## Wrap the mol command with some convenient 
## options

proc molwrap { args } {

            set cmd [lindex $args 0]
	    set newargs [lrange $args 1 end]

    switch -- $cmd {

        new {
	    set filename [lindex $newargs 0]
	    set retval [mol new [file normalize $filename] {*}[lrange $newargs 1 end]]
        }

	addfile {
	    set filename [lindex $newargs 0]
            set retval [mol addfile [file normalize $filename] {*}[lrange $newargs 1 end]]
	}

        help -
        default {
            mol
        }

    }

    return $retval
}



