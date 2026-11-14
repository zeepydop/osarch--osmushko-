#!/bin/sh
in=evidence/staff-broken.csv
out=evidence/staff-fixed.csv
iconv -f KZ-1048 -t UTF-8 "$in" > "$out"
printf '\357\273\277' | cat - "$out" > tmp && mv tmp "$out"
