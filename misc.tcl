## Some useful one-liners for vmd

## Display Active Windows with filename
#proc showme {} {draw color yellow; set gid [graphics top text {0 0 0} [molinfo top get name] size 2]; display update; after 1000; graphics top delete $gid}

## Blink Active Window
proc showme {} {color Display {Background} white; display update; after 100; color Display {Background} black}
