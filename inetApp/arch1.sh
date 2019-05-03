#!/bin/sh
#========================================================
# Project      : Time Oriented Software Framework
#
# File Name    : arch1.sh
#
# Purpose      : Deploy arch1 (architecture 1)
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Dash Shell Script (Linux)
#
#========================================================
printf "0\n3\n5073\nnone\n" > .k1 
xterm -fa 'Monospace' -fs 12 -geometry 68x20+0+300 -title "Switch" -hold -e "./main.pl .k1" &
sleep 3
printf "0\n1\n5069\nlocalhost\n5074\n" > .k2 
xterm -fa 'Monospace' -fs 12 -geometry 68x20+0+300 -title "Hub" -hold -e "./main.pl .k2" &
sleep 3
printf "1\n0\n0\n" > .k3 
xterm -fa 'Monospace' -fs 12 -geometry 68x20+0+600 -title "Earth" -hold -e "./main.pl .k3" &
printf "1\n0\n1\n" > .k4 
xterm -fa 'Monospace' -fs 12 -geometry 70x20+420+600 -title "Wind" -hold -e "./main.pl .k4" &
printf "1\n0\n2\n" > .k5
xterm -fa 'Monospace' -fs 12 -geometry 70x20+900+300 -title "Fire" -hold -e "./main.pl .k5" &
printf "0\n0\nlocalhost\n5069\n" > .k6 
xterm -fa 'Monospace' -fs 12 -geometry 70x20+900+600 -title "Sniffer1" -hold -e "./main.pl .k6" &
printf "0\n0\nlocalhost\n5076\n" > .k7 
xterm -fa 'Monospace' -fs 12 -geometry 70x20+900+600 -title "Sniffer2" -hold -e "./main.pl .k7" &

