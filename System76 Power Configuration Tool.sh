#!/bin/bash
clear
# Start of Function Cluster
tput setaf 3
echo "Initializing functions..."
sleep 1.5
tput setaf 10
checkcompatibility () {
	isinstalled="false"
	if ! type system76-power &>/dev/null
	then
		sysreqfail
	fi
	isinstalled="true"
	nvidiastatus="false"
	if lspci | grep -qi "nvidia"
	then
		nvidiastatus="true"
	elif lsusb | grep -qi "nvidia"
	then
		nvidiastatus="true"
	fi
}
echo "Loaded checkcompatibility."
sysreqfail () {
	clear
	tput setaf 9
	echo "We have detected that System76 Power is not installed on your computer. Please install System76 Power to use this configuration tool."
	tput sgr0
	echo "Hit any key to exit:"
	IFS=""
	read -sN1 answer
	quitscript
}
echo "Loaded sysreqfail."
mainmenu () {
	clear
	tput setaf 3
	echo "==========================================="
	echo " --- System76 Power Configuration Tool ---"
	echo "==========================================="
	tput setaf 10
	echo "System76 Power Installed: $isinstalled"
	tput setaf 3
	echo "This script was made for non-GNOME desktops as there is no System76 Power extension for DEs other than GNOME. This script can still be used on all DEs and systems."
	tput setaf 9
	echo "You MUST have system76-power installed to use this script!!!"
	tput setaf 3
	echo "Press 1 to set or check current performance profile."
	echo "Press 2 to set or check current graphics profile. (NVIDIA Optimus ONLY!!!)"
	tput setaf 9
	echo "Press Q to quit." 
	tput sgr0
	echo "Enter your selection:"
	IFS=""
	read -sN1 answer
	case $(echo "$answer" | tr A-Z a-z) in
		1)	performancemenu;;
		2)	graphicsmenu;;
		q)	quitscript;;
		*)	badoption;;
	esac
}
echo "Loaded mainmenu."
quitscript () {
	tput sgr0
	clear
	exit
}
echo "Loaded quitscript."
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
echo "Loaded badoption."
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
echo "Loaded badoption2."
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
echo "Loaded badoption3."
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
	echo "Enter your selection:"
	IFS=""
	read -sN1 answer
	case $(echo "$answer" | tr A-Z a-z) in
		1)	checkperformance;;
		2)	setbattery;;
		3)	setbalanced;;
		4)	setperformance;;
		q)	mainmenu;;
		*)	badoption2;;
	esac
}
echo "Loaded performancemenu."
checkperformance () {
	clear
	runcheck system76-power profile
	tput setaf 3
	echo "Press any key to return to Performance Profile Settings."
	IFS=""
	read -sN1 answer
	performancemenu
}
echo "Loaded checkperformance."
setbattery () {
	clear
	runcheck system76-power profile battery
	tput setaf 3
	finishperformance
}
echo "Loaded setbattery."
setbalanced () {
	clear
	runcheck system76-power profile balanced
	tput setaf 3
	finishperformance
}
echo "Loaded setbalanced."
setperformance () {
	clear
	runcheck system76-power profile performance
	tput setaf 3
	finishperformance
}
echo "Loaded setperformance."
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
echo "Loaded finishperformance."
graphicsmenu () {
	clear
	tput setaf 3
	echo "==================================="
	echo " --- Graphics Profile Settings ---"
	echo "==================================="
	tput setaf 10
	echo "NVIDIA Hardware Detected: $nvidiastatus"
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
	echo "Enter your selection:"
	IFS=""
	read -sN1 answer
	case $(echo "$answer" | tr A-Z a-z) in
		1)	checkgraphics;;
		2)	setintegrated;;
		3)	setcompute;;
		4)	sethybrid;;
		5)	setnvidia;;
		q)	mainmenu;;
		*)	badoption3;;
	esac
}
echo "Loaded graphicsmenu."
checkgraphics () {
	clear
	runcheck system76-power graphics
	tput setaf 3
	echo "Press any key to return to Graphics Profile Settings."
	IFS=""
	read -sN1 answer
	graphicsmenu
}
echo "Loaded checkgraphics."
setintegrated () {
	clear
	runcheck system76-power graphics integrated
	finishgraphics
}
echo "Loaded setintegrated."
setcompute () {
	clear
	runcheck system76-power graphics compute
	finishgraphics
}
echo "Loaded setcompute."
sethybrid () {
	clear
	runcheck system76-power graphics hybrid
	finishgraphics
}
echo "Loaded sethybrid."
setnvidia () {
	clear
	runcheck system76-power graphics nvidia
	finishgraphics
}
echo "Loaded setnvidia."
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
echo "Loaded finishgraphics."
runcheck () {
	IFS=$'\n'
	command="$*"
	retval=1
	attempt=1
	until [[ $retval -eq 0 ]] || [[ $attempt -gt 5 ]]; do
		(
			set +e
			$command
		)
		retval=$?
		attempt=$(( $attempt + 1 ))
		if [[ $retval -ne 0 ]]; then
			clear
			tput setaf 9
			echo "Oops! Something went wrong! Retrying in 3 seconds..."
			tput sgr0
			sleep 3
			clear
		fi
	done
	if [[ $retval -ne 0 ]] && [[ $attempt -gt 5 ]]; then
		clear
		tput setaf 9
		echo "Oops! A fatal error has occured and the program cannot continue. Returning to the main menu in 10 seconds..."
		tput setaf 3
		echo "Please try again later or if the problem persists, create an issue on GitHub."
		echo "Note that you may not have NVIDIA Optimus if you were trying to switch graphics modes."
		tput sgr0
		sleep 10
		clear
		mainmenu
	fi
	IFS=""
}
echo "Loaded runcheck."
tput setaf 3
echo "Continuing..."
tput sgr0
sleep 1.5
# End of Function Cluster
# Start of Main Script
while true
do
	checkcompatibility
	mainmenu
done
# End of Main Script
