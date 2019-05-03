#!/bin/sh
#========================================================
# Project      : Time Oriented Software Framework
#
# File Name    : arch0.sh
#
# Purpose      : Deploy arch0 (architecture 0)
#
# Author       : Peter Walsh, Vancouver Island University
#
# System       : Dash Shell Script (Linux)
#
#========================================================

printf "0\n1\n5070\nnone\n" > .k1 
xterm -fa 'Monospace' -fs 12 -geometry 68x20+0+300 -title "Hub" -hold -e "./main.pl .k1" &
sleep 3
printf "1\n0\n0\n" > .k2 
xterm -fa 'Monospace' -fs 12 -geometry 68x20+0+600 -title "Earth" -hold -e "./main.pl .k2" &
printf "1\n0\n1\n" > .k3 
xterm -fa 'Monospace' -fs 12 -geometry 70x20+420+600 -title "Wind" -hold -e "./main.pl .k3" &
printf "1\n0\n2\n" > .k4
xterm -fa 'Monospace' -fs 12 -geometry 70x20+900+300 -title "Fire" -hold -e "./main.pl .k4" &
printf "0\n0\nlocalhost\n5070\n" > .k5 
xterm -fa 'Monospace' -fs 12 -geometry 70x20+900+600 -title "Sniffer" -hold -e "./main.pl .k5" &

#sleep 3
#ssh -Y -l pwalsh otter.csci.viu.ca 'cd /home/faculty/pwalsh/XOX/HACK/EXAM/TosfDev/Perl/inetApp/ ; printf "0\n1\n5070\nnone\n" > .kk ; nohup xterm -ls -fa 'Monospace' -fs 12 -geometry 68x20+0+300 -title "Hub" -hold -e "./main.pl .kk" &  ' 
#
