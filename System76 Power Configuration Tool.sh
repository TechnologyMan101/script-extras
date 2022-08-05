#!/bin/bash
# Start of Function Cluster
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
checkperformance () {
	clear
	runcheck system76-power profile
	tput setaf 3
	echo "Press any key to return to Performance Profile Settings."
	IFS=""
	read -sN1 answer
	performancemenu
}
setbattery () {
	clear
	runcheck system76-power profile battery
	tput setaf 3
	finishperformance
}
setbalanced () {
	clear
	runcheck system76-power profile balanced
	tput setaf 3
	finishperformance
}
setperformance () {
	clear
	runcheck system76-power profile performance
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
checkgraphics () {
	clear
	runcheck system76-power graphics
	tput setaf 3
	echo "Press any key to return to Graphics Profile Settings."
	IFS=""
	read -sN1 answer
	graphicsmenu
}
setintegrated () {
	clear
	runcheck system76-power graphics integrated
	finishgraphics
}
setcompute () {
	clear
	runcheck system76-power graphics compute
	finishgraphics
}
sethybrid () {
	clear
	runcheck system76-power graphics hybrid
	finishgraphics
}
setnvidia () {
	clear
	runcheck system76-power graphics nvidia
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
runcheck () {
	IFS=" "
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
# End of Function Cluster
# Start of Main Script
while true
do
	checkcompatibility
	mainmenu
done
# End of Main Script
