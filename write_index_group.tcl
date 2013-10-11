proc write_index_group { outfile sel label { n_atoms_max 1000000000 } } {
    if { [${sel} num] == 0 } return

    ## Open file
    set fid [open $outfile w]

    ## Write out
    puts -nonewline ${fid} [format "\[ %s \]\n" ${label}]
    set line_buf 0
    set atom_count 0
    foreach num [${sel} get serial] {
        incr atom_count
        if { ${atom_count} > ${n_atoms_max} } break
        puts -nonewline ${fid} [format " %9d" ${num}]
        set line_buf [expr ${line_buf} + 10]
        if { ${line_buf} > 70 } {
            set line_buf 0
            puts -nonewline ${fid} "\n"
        }
    }

    if { ${line_buf} > 0 } {
        puts -nonewline ${fid} "\n"
    }

    puts -nonewline ${fid} "\n"

    ## Close file
    close $fid
}
