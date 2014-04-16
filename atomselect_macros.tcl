# +-----------------------+
# | Atom selection macros |
# +-----------------------+

atomselect macro p protein
atomselect macro l {lipid or resname OCT}
atomselect macro i ions
atomselect macro w {resname SOL TIP TIP3 TP3M TP3E TP3P TIP4 TIP5 ST2 SPC WAT H2O WTR}

# From Giacomo
atomselect macro noh { not hydrogen }
atomselect macro pnoh { protein noh }
atomselect macro bb { (backbone or name "H") }
atomselect macro bbnoh { ((name "C") or (name "N") or (name "CA")) }
atomselect macro Ca { alpha or (name "CA" and not resname "CA") }
atomselect macro side { sidechain or Ca }
atomselect macro side_noh { side and noh }
atomselect macro calcium { name "Ca\+" or resname "CA" or resname "CAL" }
atomselect macro sodium { name "Na\+" or resname "NA" }

# added Jerome's lipids and cholesterol
atomselect macro lipid { resname DLPE DMPC GPC LPPC PALM PC PGCL POPC POUC POPE CHL1 CLOL DPPC SAPC }
atomselect macro lnoh { lipid noh }

atomselect macro pchead {lipid and name N C13 C14 C15 C12 C11 P O13 O14 O11 O12 C1 C2 O21 C21 O22 C22 C3 O31 C31 C23 }
