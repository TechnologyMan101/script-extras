#!/bin/bash
# Start of Function Cluster
mainmenu () {
	clear
	tput setaf 3
	echo "================================="
	echo " --- Set Screen to 1920x1080 ---"
	echo "================================="
	tput setaf 9
	echo "This should only be used on a VM!!!"
	tput setaf 10
	echo "This script can be modified to set a different resolution."
	tput setaf 3
	echo "Hit <return> to run this script."
	tput setaf 9
	echo "Press Q followed by <return> to quit."
	tput sgr0
	echo "Enter your selection followed by <return>:"
	read answer
	case "$answer" in
		q) quitscript;;
		Q) quitscript;;
	esac
	runscript
}
quitscript () {
	tput sgr0
	clear
	exit
}
finish () {
	clear
	tput setaf 10
	echo "Done..."
	tput setaf 9
	echo "Quitting..."
	tput sgr0
	sleep 3
	clear
	quitscript
}
runscript () {
	clear
	tput setaf 3
	echo "Setting screen resolution to 1920x1080..."
	tput sgr0
	sleep 3
	clear
	xrandr --newmode "1920x1080"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
	xrandr --addmode Virtual1 1920x1080
	xrandr --output Virtual1 --mode 1920x1080
	finish
}
# End of Function Cluster
# Start of Main Script
while true
do
	mainmenu
done
# End of Main Script
