#!/bin/sh
#========================================================
# Project      : Time Oriented Software Framework
#
# File Name    : arch3.sh
#
# Purpose      : Deploy arch3 (architecture 3)
#
# Author       : Abdullah Alharbi
#                
# System       : Dash Shell Script (Linux)
#
#========================================================
printf "0\n2\n6070\nnone\n" > .k1 
xterm -fa 'Monospace' -fs 12 -geometry 68x20+0+300 -title "P2p 6070" -hold -e "./main.pl .k1" &

printf "0\n2\n6080\nnone\n" > .k2
xterm -fa 'Monospace' -fs 12 -geometry 68x20+0+300 -title "P2p 6080" -hold -e "./main.pl .k2" &

printf "0\n2\n6090\nnone\n" > .k3
xterm -fa 'Monospace' -fs 12 -geometry 68x20+0+300 -title "P2p 6090" -hold -e "./main.pl .k3" &

printf "0\n1\n5070\nnone\n" > .k4
xterm -fa 'Monospace' -fs 12 -geometry 68x20+0+300 -title "Hub 5070" -hold -e "./main.pl .k4" &

printf "0\n1\n5170\nnone\n" > .k5
xterm -fa 'Monospace' -fs 12 -geometry 68x20+0+300 -title "Hub 5170" -hold -e "./main.pl .k5" &

printf "0\n1\n5270\nnone\n" > .k6
xterm -fa 'Monospace' -fs 12 -geometry 68x20+0+300 -title "Hub 5270" -hold -e "./main.pl .k6" &

sleep 5

printf "1\n1\n0\n" > .k7
xterm -fa 'Monospace' -fs 12 -geometry 68x20+0+600 -title "R1" -hold -e "./main.pl .k7" &

printf "1\n1\n1\n" > .k8
xterm -fa 'Monospace' -fs 12 -geometry 68x20+0+600 -title "R2" -hold -e "./main.pl .k8" &

printf "1\n1\n2\n" > .k9
xterm -fa 'Monospace' -fs 12 -geometry 68x20+0+600 -title "R3" -hold -e "./main.pl .k9" &

printf "1\n1\n3\n" > .k10
xterm -fa 'Monospace' -fs 12 -geometry 70x20+420+600 -title "Earth" -hold -e "./main.pl .k10" &
printf "1\n1\n4\n" > .k11
xterm -fa 'Monospace' -fs 12 -geometry 70x20+420+600 -title "Wind" -hold -e "./main.pl .k11" &
printf "1\n1\n5\n" > .k12
xterm -fa 'Monospace' -fs 12 -geometry 70x20+900+300 -title "Fire" -hold -e "./main.pl .k12" &
printf "0\n0\nlocalhost\n5071\n" > .k13
xterm -fa 'Monospace' -fs 12 -geometry 70x20+900+300 -title "Sniffer" -hold -e "./main.pl .k13" &

printf "0\n0\nlocalhost\n5171\n" > .k14
xterm -fa 'Monospace' -fs 12 -geometry 70x20+900+300 -title "Sniffer2" -hold -e "./main.pl .k14" &


