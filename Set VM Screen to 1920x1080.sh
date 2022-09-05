#!/bin/bash
clear
# Start of Function Cluster
tput setaf 3
echo "Initializing functions..."
sleep 1.5
tput setaf 10
checkcompatibility () {
	if ! echo $XDG_SESSION_TYPE | grep -qi "x11"
	then
		sysreqfail
	fi
}
echo "Loaded checkcompatibility."
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
echo "Loaded sysreqfail."
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
echo "Loaded mainmenu."
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
quitscript () {
	tput sgr0
	clear
	exit
}
echo "Loaded quitscript."
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
echo "Loaded finish."
runscript () {
	clear
	tput setaf 3
	echo "Setting screen resolution to 1920x1080..."
	tput sgr0
	sleep 3
	clear
	runcheck xrandr --newmode "1920x1080"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
	runcheck xrandr --addmode Virtual1 1920x1080
	runcheck xrandr --output Virtual1 --mode 1920x1080
	finish
}
echo "Loaded runscript."
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
		echo "Oops! A fatal error has occurred and the program cannot continue. Returning to the main menu in 10 seconds..."
		tput setaf 3
		echo "Please try again later or if the problem persists, create an issue on GitHub."
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
