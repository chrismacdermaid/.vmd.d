
proc colorscale_jet { {reverse 0} {count 0} } {
  display update off
  set mincolorid [expr [colorinfo num] - 1]
  set maxcolorid [expr [colorinfo max] - 1]
  set colrange [expr $maxcolorid - $mincolorid]
  set colhalf [expr $colrange / 2]

  for {set i $mincolorid} {$i < $maxcolorid} {incr i} {
    set x [expr ($i - $mincolorid) / double($colrange)]

    # quantize so we only get count unique colors, regardless
    # of the low level colorscale matrix size
    if { $count != 0 } {
      set nx [expr {int($count * $x) / double($count)}] 
      set x $nx
    }

    set r 0.0;
    if {$x >= 3.0/8.0 && $x < 5.0/8.0} {
      set r [expr 4.0 * $x - 3.0/2.0];
    } elseif {$x >= 5.0/8.0 && $x < 7.0/8.0} {
      set r 1.0;
    } elseif {$x >= 7.0/8.0} {
      set r [expr -4.0 * $x + 9.0/2.0];
    }

    set g 0.0;
    if {$x >= 1.0/8.0 && $x < 3.0/8.0} {
      set g [expr 4.0 * $x - 1.0/2.0];
    } elseif {$x >= 3.0/8.0 && $x < 5.0/8.0} {
      set g 1.0;
    } elseif {$x >= 5.0/8.0 && $x < 7.0/8.0} {
      set g [expr -4.0 * $x + 7.0/2.0];
    }

    set b 0.0;
    if {$x < 1.0/8.0} {
      set b [expr 4.0 * $x + 1.0/2.0];
    } elseif {$x >= 1.0/8.0 && $x < 3.0/8.0} {
      set b 1.0;
    } elseif {$x >= 3.0/8.0 && $x < 5.0/8.0} {
      set b [expr -4.0 * $x + 5.0/2.0];
    }

    if { $reverse } {
      color change rgb [expr $mincolorid + ($maxcolorid - $i)] $r $g $b 
    } else { 
      color change rgb $i $r $g $b 
    }
  }

  display update ui
  display update on
}


proc hsv2rgb { h s v } {
  set twopi 6.28318530717958647692;
  set t  [expr $twopi * $h];
  set rv [expr (1.0 + $s * sin($t + $twopi / 3.0)) * $v * 0.5];
  set gv [expr (1.0 + $s * sin($t - $twopi / 3.0)) * $v * 0.5];
  set bv [expr (1.0 + $s * sin($t)) * $v * 0.5];
  return [list $rv $gv $bv] 
}

proc colorscale_hsv { {reverse 0} {count 0} } {
  display update off
  set mincolorid [expr [colorinfo num] - 1]
  set maxcolorid [expr [colorinfo max] - 1]
  set colrange [expr $maxcolorid - $mincolorid]
  set colhalf [expr $colrange / 2]

  for {set i $mincolorid} {$i < $maxcolorid} {incr i} {
    set x [expr ($i - $mincolorid) / double($colrange)]

    # quantize so we only get count unique colors, regardless
    # of the low level colorscale matrix size
    if { $count != 0 } {
      set nx [expr {int($count * $x) / double($count)}] 
      set x $nx
    }

    set r 0.0;
    set g 0.0;
    set b 0.0;

    set rgb [hsv2rgb $x 1.0 1.0];
    foreach { r g b } $rgb { };

    if { $reverse } {
      color change rgb [expr $mincolorid + ($maxcolorid - $i)] $r $g $b 
    } else { 
      color change rgb $i $r $g $b 
    }
  }

  display update ui
  display update on
}


proc colorscale_hot { {reverse 0} {count 0} } {
  display update off
  set mincolorid [expr [colorinfo num] - 1]
  set maxcolorid [expr [colorinfo max] - 1]
  set colrange [expr $maxcolorid - $mincolorid]
  set colhalf [expr $colrange / 2]

  for {set i $mincolorid} {$i < $maxcolorid} {incr i} {
    set x [expr ($i - $mincolorid) / double($colrange)]

    # quantize so we only get count unique colors, regardless
    # of the low level colorscale matrix size
    if { $count != 0 } {
      set nx [expr {int($count * $x) / double($count)}] 
      set x $nx
    }

    set r 0.0;
    if {$x < 2.0/5.0} {
      set r [expr 5.0/2.0 * $x];
    } elseif {$x >= 2.0/5.0} {
      set r 1.0;
    }

    set g 0.0;
    if {$x >= 2.0/5.0 && $x < 4.0/5.0} {
      set g [expr 5.0/2.0 * $x - 1.0];
    } elseif {$x >= 4.0/5.0} {
      set g 1.0;
    }

    set b 0.0;
    if {$x >= 4.0/5.0} {
      set b [expr 5.0 * $x - 4.0];
    }

    if { $reverse } {
      color change rgb [expr $mincolorid + ($maxcolorid - $i)] $r $g $b 
    } else { 
      color change rgb $i $r $g $b 
    }
  }

  display update ui
  display update on
}


proc colorscale_cool { {reverse 0} {count 0} } {
  display update off
  set mincolorid [expr [colorinfo num] - 1]
  set maxcolorid [expr [colorinfo max] - 1]
  set colrange [expr $maxcolorid - $mincolorid]
  set colhalf [expr $colrange / 2]

  for {set i $mincolorid} {$i < $maxcolorid} {incr i} {
    set x [expr ($i - $mincolorid) / double($colrange)]

    # quantize so we only get count unique colors, regardless
    # of the low level colorscale matrix size
    if { $count != 0 } {
      set nx [expr {int($count * $x) / double($count)}] 
      set x $nx
    }

    set r $x;
    set g [expr 1.0 - $r];
    set b 1.0;

    if { $reverse } {
      color change rgb [expr $mincolorid + ($maxcolorid - $i)] $r $g $b 
    } else { 
      color change rgb $i $r $g $b 
    }
  }

  display update ui
  display update on
}


proc colorscale_spring { {reverse 0} {count 0} } {
  display update off
  set mincolorid [expr [colorinfo num] - 1]
  set maxcolorid [expr [colorinfo max] - 1]
  set colrange [expr $maxcolorid - $mincolorid]
  set colhalf [expr $colrange / 2]

  for {set i $mincolorid} {$i < $maxcolorid} {incr i} {
    set x [expr ($i - $mincolorid) / double($colrange)]

    # quantize so we only get count unique colors, regardless
    # of the low level colorscale matrix size
    if { $count != 0 } {
      set nx [expr {int($count * $x) / double($count)}] 
      set x $nx
    }

    set r 1.0;
    set g $x;
    set b [expr 1.0 - $g];

    if { $reverse } {
      color change rgb [expr $mincolorid + ($maxcolorid - $i)] $r $g $b 
    } else { 
      color change rgb $i $r $g $b 
    }
  }

  display update ui
  display update on
}


proc colorscale_summer { {reverse 0} {count 0} } {
  display update off
  set mincolorid [expr [colorinfo num] - 1]
  set maxcolorid [expr [colorinfo max] - 1]
  set colrange [expr $maxcolorid - $mincolorid]
  set colhalf [expr $colrange / 2]

  for {set i $mincolorid} {$i < $maxcolorid} {incr i} {
    set x [expr ($i - $mincolorid) / double($colrange)]

    # quantize so we only get count unique colors, regardless
    # of the low level colorscale matrix size
    if { $count != 0 } {
      set nx [expr {int($count * $x) / double($count)}] 
      set x $nx
    }

    set r $x;
    set g [expr 0.5 + $r / 2.0];
    set b 0.4;

    if { $reverse } {
      color change rgb [expr $mincolorid + ($maxcolorid - $i)] $r $g $b 
    } else { 
      color change rgb $i $r $g $b 
    }
  }

  display update ui
  display update on
}


proc colorscale_autumn { {reverse 0} {count 0} } {
  display update off
  set mincolorid [expr [colorinfo num] - 1]
  set maxcolorid [expr [colorinfo max] - 1]
  set colrange [expr $maxcolorid - $mincolorid]
  set colhalf [expr $colrange / 2]

  for {set i $mincolorid} {$i < $maxcolorid} {incr i} {
    set x [expr ($i - $mincolorid) / double($colrange)]

    # quantize so we only get count unique colors, regardless
    # of the low level colorscale matrix size
    if { $count != 0 } {
      set nx [expr {int($count * $x) / double($count)}] 
      set x $nx
    }

    set r 1.0;
    set g $x;
    set b 0.0;

    if { $reverse } {
      color change rgb [expr $mincolorid + ($maxcolorid - $i)] $r $g $b 
    } else { 
      color change rgb $i $r $g $b 
    }
  }

  display update ui
  display update on
}


proc colorscale_winter { {reverse 0} {count 0} } {
  display update off
  set mincolorid [expr [colorinfo num] - 1]
  set maxcolorid [expr [colorinfo max] - 1]
  set colrange [expr $maxcolorid - $mincolorid]
  set colhalf [expr $colrange / 2]

  for {set i $mincolorid} {$i < $maxcolorid} {incr i} {
    set x [expr ($i - $mincolorid) / double($colrange)]

    # quantize so we only get count unique colors, regardless
    # of the low level colorscale matrix size
    if { $count != 0 } {
      set nx [expr {int($count * $x) / double($count)}] 
      set x $nx
    }

    set r 0.0;
    set g $x;
    set b [expr 1.0 - $g / 2.0];

    if { $reverse } {
      color change rgb [expr $mincolorid + ($maxcolorid - $i)] $r $g $b 
    } else { 
      color change rgb $i $r $g $b 
    }
  }

  display update ui
  display update on
}


proc colorscale_gray { {reverse 0} {count 0} } {
  display update off
  set mincolorid [expr [colorinfo num] - 1]
  set maxcolorid [expr [colorinfo max] - 1]
  set colrange [expr $maxcolorid - $mincolorid]
  set colhalf [expr $colrange / 2]

  for {set i $mincolorid} {$i < $maxcolorid} {incr i} {
    set x [expr ($i - $mincolorid) / double($colrange)]

    # quantize so we only get count unique colors, regardless
    # of the low level colorscale matrix size
    if { $count != 0 } {
      set nx [expr {int($count * $x) / double($count)}] 
      set x $nx
    }

    set r $x;
    set g $x;
    set b $x;

    if { $reverse } {
      color change rgb [expr $mincolorid + ($maxcolorid - $i)] $r $g $b 
    } else { 
      color change rgb $i $r $g $b 
    }
  }

  display update ui
  display update on
}


proc colorscale_bone { {reverse 0} {count 0} } {
  display update off
  set mincolorid [expr [colorinfo num] - 1]
  set maxcolorid [expr [colorinfo max] - 1]
  set colrange [expr $maxcolorid - $mincolorid]
  set colhalf [expr $colrange / 2]

  for {set i $mincolorid} {$i < $maxcolorid} {incr i} {
    set x [expr ($i - $mincolorid) / double($colrange)]

    # quantize so we only get count unique colors, regardless
    # of the low level colorscale matrix size
    if { $count != 0 } {
      set nx [expr {int($count * $x) / double($count)}] 
      set x $nx
    }

    set r 0.0;
    if {$x < 3.0/4.0} {
      set r [expr 7.0/8.0 * $x];
    } elseif {$x >= 3.0/4.0} {
      set r [expr 11.0/8.0 * $x - 3.0/8.0];
    }
    
    set g 0.0;
    if {$x < 3.0/8.0} {
      set g [expr 7.0/8.0 * $x];
    } elseif {$x >= 3.0/8.0 && $x < 3.0/4.0} {
      set g [expr 29.0/24.0 * $x - 1.0/8.0];
    } elseif {$x >= 3.0/4.0} {
      set g [expr 7.0/8.0 * $x + 1.0/8.0];
    }

    set b 0.0;
    if {$x < 3.0/8.0} {
      set b [expr 29.0/24.0 * $x];
    } elseif {$x >= 3.0/8.0} {
      set b [expr 7.0/8.0 * $x + 1.0/8.0];
    }

    if { $reverse } {
      color change rgb [expr $mincolorid + ($maxcolorid - $i)] $r $g $b 
    } else { 
      color change rgb $i $r $g $b 
    }
  }

  display update ui
  display update on
}


proc colorscale_copper { {reverse 0} {count 0} } {
  display update off
  set mincolorid [expr [colorinfo num] - 1]
  set maxcolorid [expr [colorinfo max] - 1]
  set colrange [expr $maxcolorid - $mincolorid]
  set colhalf [expr $colrange / 2]

  for {set i $mincolorid} {$i < $maxcolorid} {incr i} {
    set x [expr ($i - $mincolorid) / double($colrange)]

    # quantize so we only get count unique colors, regardless
    # of the low level colorscale matrix size
    if { $count != 0 } {
      set nx [expr {int($count * $x) / double($count)}] 
      set x $nx
    }

    set r 0.0;
    if {$x < 4.0/5.0} {
      set r [expr 5.0/4.0 * $x];
    } elseif {$x >= 4.0/5.0} {
      set r 1.0;
    }
    
    set g [expr 4.0/5.0 * $x];
    set b [expr 0.5 * $x];

    if { $reverse } {
      color change rgb [expr $mincolorid + ($maxcolorid - $i)] $r $g $b 
    } else { 
      color change rgb $i $r $g $b 
    }
  }

  display update ui
  display update on
}


proc colorscale_pink { {reverse 0} {count 0} } {
  display update off
  set mincolorid [expr [colorinfo num] - 1]
  set maxcolorid [expr [colorinfo max] - 1]
  set colrange [expr $maxcolorid - $mincolorid]
  set colhalf [expr $colrange / 2]

  for {set i $mincolorid} {$i < $maxcolorid} {incr i} {
    set x [expr ($i - $mincolorid) / double($colrange)]

    # quantize so we only get count unique colors, regardless
    # of the low level colorscale matrix size
    if { $count != 0 } {
      set nx [expr {int($count * $x) / double($count)}] 
      set x $nx
    }

    set r 0.0;
    if {$x < 3.0/8.0} {
      set r [expr 14.0/9.0 * $x];
    } elseif {$x >= 3.0/8.0} {
      set r [expr 2.0/3.0 * $x + 1.0/3.0];
    }
    
    set g 0.0;
    if {$x < 3.0/8.0} {
      set g [expr 2.0/3.0 * $x];
    } elseif {$x >= 3.0/8.0 && $x < 3.0/4.0} {
      set g [expr 14.0/9.0 * $x - 1.0/3.0];
    } elseif {$x >= 3.0/4.0} {
      set g [expr 2.0/3.0 * $x + 1.0/3.0];
    }
    set b 0.0;
    if {$x < 3.0/4.0} {
      set b [expr 2.0/3.0 * $x];
    } elseif {$x >= 3.0/4.0} {
      set b [expr 2.0 * $x - 1.0];
    }

    if { $reverse } {
      color change rgb [expr $mincolorid + ($maxcolorid - $i)] $r $g $b 
    } else { 
      color change rgb $i $r $g $b 
    }
  }

  display update ui
  display update on
}


proc matlab_colorscale { {colorscale_name "jet"} {reverse 0} {count 0} } {
  if { ![string compare $colorscale_name "jet"] } {
    colorscale_jet $reverse $count
  } elseif { ![string compare $colorscale_name "hot"] } {
    colorscale_hot $reverse $count
  } elseif { ![string compare $colorscale_name "hsv"] } {
    colorscale_hsv $reverse $count
  } elseif { ![string compare $colorscale_name "cool"] } {
    colorscale_cool $reverse $count
  } elseif { ![string compare $colorscale_name "spring"] } {
    colorscale_spring $reverse $count
  } elseif { ![string compare $colorscale_name "summer"] } {
    colorscale_summer $reverse $count
  } elseif { ![string compare $colorscale_name "autumn"] } {
    colorscale_autumn $reverse $count
  } elseif { ![string compare $colorscale_name "winter"] } {
    colorscale_winter $reverse $count
  } elseif { ![string compare $colorscale_name "gray"] } {
    colorscale_gray $reverse $count
  } elseif { ![string compare $colorscale_name "bone"] } {
    colorscale_bone $reverse $count
  } elseif { ![string compare $colorscale_name "copper"] } {
    colorscale_copper $reverse $count
  } elseif { ![string compare $colorscale_name "pink"] } {
    colorscale_pink $reverse $count
  } elseif { ![string compare $colorscale_name "lines"] } {
    puts "Unsupported matlab colorscale name: $colorscale_name"
  } else {
    puts "Unknown matlab colorscale name: $colorscale_name"
    return
  }
}

proc colorscale_jet_sel { sel {reverse 0} {count 0} } {
  display update off
  set mincolorid [expr [colorinfo num] - 1]
  set maxcolorid [expr [colorinfo max] - 1]
  set colrange [expr $maxcolorid - $mincolorid]
  set colhalf [expr $colrange / 2]

  for {set i $mincolorid} {$i < $maxcolorid} {incr i} {
    set x [expr ($i - $mincolorid) / double($colrange)]

    # quantize so we only get count unique colors, regardless
    # of the low level colorscale matrix size
    if { $count != 0 } {
      set nx [expr {int($count * $x) / double($count)}] 
      set x $nx
    }

    set r 0.0;
    if {$x >= 3.0/8.0 && $x < 5.0/8.0} {
      set r [expr 4.0 * $x - 3.0/2.0];
    } elseif {$x >= 5.0/8.0 && $x < 7.0/8.0} {
      set r 1.0;
    } elseif {$x >= 7.0/8.0} {
      set r [expr -4.0 * $x + 9.0/2.0];
    }

    set g 0.0;
    if {$x >= 1.0/8.0 && $x < 3.0/8.0} {
      set g [expr 4.0 * $x - 1.0/2.0];
    } elseif {$x >= 3.0/8.0 && $x < 5.0/8.0} {
      set g 1.0;
    } elseif {$x >= 5.0/8.0 && $x < 7.0/8.0} {
      set g [expr -4.0 * $x + 7.0/2.0];
    }

    set b 0.0;
    if {$x < 1.0/8.0} {
      set b [expr 4.0 * $x + 1.0/2.0];
    } elseif {$x >= 1.0/8.0 && $x < 3.0/8.0} {
      set b 1.0;
    } elseif {$x >= 3.0/8.0 && $x < 5.0/8.0} {
      set b [expr -4.0 * $x + 5.0/2.0];
    }

    if { $reverse } {
      color change rgb [expr $mincolorid + ($maxcolorid - $i)] $r $g $b 
    } else { 
      color change rgb $i $r $g $b 
    }
  }

  display update ui
  display update on
}
