#!/bin/bash
# Start of Function Cluster
checkcompatibility () {
	if ! echo $XDG_SESSION_TYPE | grep -qi "x11"
	then
		sysreqfail
	fi
}
sysreqfail () {
	clear
	tput setaf 9
	echo "System requirements not met. This script supports systems logged in with Xorg!!!"
	tput setaf 10
	echo "Current Session Type: $XDG_SESSION_TYPE"
	tput sgr0
	echo "Hit any key to exit:"
	IFS=""
	read -sN1 answer
	quitscript
}
mainmenu () {
	clear
	tput setaf 3
	echo "================================="
	echo " --- Set Screen to 1920x1080 ---"
	echo "================================="
	tput setaf 10
	echo "Current Session Type: $XDG_SESSION_TYPE"
	tput setaf 9
	echo "This should only be used on a VM unless your actual computer refuses to set your desired resolution!!!"
	echo "This script will only work on Xorg!!!"
	tput setaf 10
	echo "This script can be modified to set a different resolution."
	tput setaf 3
	echo "Hit <return> to run this script."
	tput setaf 9
	echo "Press Q to quit."
	tput sgr0
	echo "Enter your selection:"
	IFS=""
	read -sN1 answer
	case $(echo "$answer" | tr A-Z a-z) in
		"")	runscript;;
		q)	quitscript;;
		*)	badoption;;
	esac
}
badoption () {
	clear
	tput setaf 9
	echo "Invalid Option!"
	tput setaf 3
	echo "Returning to Main Menu..."
	tput sgr0
	sleep 3
	mainmenu
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
	checkcompatibility
	mainmenu
done
# End of Main Script
