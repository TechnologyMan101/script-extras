#!/bin/bash
# Start of Function Cluster
mainmenu () {
	clear
	tput setaf 3
	echo "==========================================="
	echo " --- System76 Power Configuration Tool ---"
	echo "==========================================="
	echo "This script was made for non-GNOME desktops as there is no System76 Power extension for DEs other than GNOME. This script can still be used on all DEs and systems."
	tput setaf 9
	echo "You MUST have system76-power installed to use this script!!!"
	tput setaf 3
	echo "Press 1 to set or check current performance profile."
	echo "Press 2 to set or check current graphics profile. (NVIDIA Optimus ONLY!!!)"
	tput setaf 9
	echo "Press Q to quit." 
	tput sgr0
	echo "Enter your selection followed by <return>:"
	read answer
	case "$answer" in
		1) performancemenu;;
		2) graphicsmenu;;
		q) quitscript;;
		Q) quitscript;;
	esac
	badoption
}
quitscript () {
	tput sgr0
	clear
	exit
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
badoption2 () {
	clear
	tput setaf 9
	echo "Invalid Option!"
	tput setaf 3
	echo "Returning to Performance Profile Settings..."
	tput sgr0
	sleep 3
	performancemenu
}
badoption3 () {
	clear
	tput setaf 9
	echo "Invalid Option!"
	tput setaf 3
	echo "Returning to Graphics Profile Settings..."
	tput sgr0
	sleep 3
	graphicsmenu
}
failed () {
	clear
	tput setaf 9
	echo "Failed..."
	tput setaf 3
	echo "Returning to Main Menu..."
	tput sgr0
	sleep 3
	mainmenu
}
performancemenu () {
	clear
	tput setaf 3
	echo "======================================"
	echo " --- Performance Profile Settings ---"
	echo "======================================"
	echo "Press 1 to check current performance profile."
	echo "Press 2 to set performance profile to Battery Saver."
	echo "Press 3 to set performance profile to Balanced."
	echo "Press 4 to set performance profile to High Performance"
	tput setaf 9
	echo "Press Q to return to main menu." 
	tput sgr0
	echo "Enter your selection followed by <return>:"
	read answer
	case "$answer" in
		1) checkperformance;;
		2) setbattery;;
		3) setbalanced;;
		4) setperformance;;
		q) mainmenu;;
		Q) mainmenu;;
	esac
	badoption2
}
checkperformance () {
	clear
	system76-power profile || failed
	tput setaf 3
	echo "Press <return> to return to Performance Profile Settings."
	read answer
	performancemenu
}
setbattery () {
	clear
	system76-power profile battery || failed
	tput setaf 3
	finishperformance
}
setbalanced () {
	clear
	system76-power profile balanced || failed
	tput setaf 3
	finishperformance
}
setperformance () {
	clear
	system76-power profile performance || failed
	tput setaf 3
	finishperformance
}
finishperformance () {
	clear
	tput setaf 10
	echo "Done!!!"
	tput setaf 3
	echo "Returning to Performance Profile Settings..."
	tput sgr0
	sleep 3
	performancemenu
}
graphicsmenu () {
	clear
	tput setaf 3
	echo "==================================="
	echo " --- Graphics Profile Settings ---"
	echo "==================================="
	tput setaf 9
	echo "This script will not work if you DO NOT have NVIDIA Optimus/Switchable Graphics!"
	echo "The only option that will work regardless is checking the current profile."
	tput setaf 3
	echo "Press 1 to check current graphics profile."
	echo "Press 2 to set graphics profile to Integrated Graphics."
	echo "Press 3 to set graphics profile to Compute Graphics."
	echo "Press 4 to set graphics profile to Hybrid Graphics."
	echo "Press 5 to set graphics profile to NVIDIA Graphics."
	tput setaf 9
	echo "Press Q to return to main menu." 
	tput sgr0
	echo "Enter your selection followed by <return>:"
	read answer
	case "$answer" in
		1) checkgraphics;;
		2) setintegrated;;
		3) setcompute;;
		4) sethybrid;;
		5) setnvidia;;
		q) mainmenu;;
		Q) mainmenu;;
	esac
	badoption3
}
checkgraphics () {
	clear
	system76-power graphics || failed
	tput setaf 3
	echo "Press <return> to return to Graphics Profile Settings."
	read answer
	graphicsmenu
}
setintegrated () {
	clear
	system76-power graphics integrated || failed
	finishgraphics
}
setcompute () {
	clear
	system76-power graphics compute || failed
	finishgraphics
}
sethybrid () {
	clear
	system76-power graphics hybrid || failed
	finishgraphics
}
setnvidia () {
	clear
	system76-power graphics nvidia || failed
	finishgraphics
}
finishgraphics () {
	clear
	tput setaf 10
	echo "Done!!!"
	tput setaf 3
	echo "Returning to Graphics Profile Settings..."
	tput sgr0
	sleep 3
	graphicsmenu
}
# End of Function Cluster
# Start of Main Script
while true
do
	mainmenu
done
# End of Main Script
