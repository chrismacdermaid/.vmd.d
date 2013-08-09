proc write_index_group { output sel label { n_atoms_max 1000000000 } } {
    if { [${sel} num] == 0 } return
    puts -nonewline ${output} [format "\[ %s \]\n" ${label}]
    set line_buf 0
    set atom_count 0
    foreach num [${sel} get serial] {
        incr atom_count
        if { ${atom_count} > ${n_atoms_max} } break
        puts -nonewline ${output} [format " %9d" ${num}]
        set line_buf [expr ${line_buf} + 10]
        if { ${line_buf} > 70 } {
            set line_buf 0
            puts -nonewline ${output} "\n"
        }
    }
    if { ${line_buf} > 0 } {
        puts -nonewline ${output} "\n"
    }
    puts -nonewline ${output} "\n"
}
