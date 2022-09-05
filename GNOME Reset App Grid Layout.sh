#!/bin/bash
clear
# Start of Function Cluster
tput setaf 3
echo "Initializing functions..."
sleep 1.5
tput setaf 10
checkcompatibility () {
	# Set isgnome variable
	isgnome=false
	if echo $XDG_CURRENT_DESKTOP | grep -qi "gnome"
	then
		isgnome=true
		gnomeversion=$(gnome-shell --version | sed 's/GNOME Shell *//')
	fi
	
	# Check for correct DE and version
	if ! gnome-shell --version | grep -qe "3\.38" -e "[4-9][0-9]\."
	then
		sysreqfail
	fi
}
echo "Loaded checkcompatibility."
sysreqfail () {
	clear
	tput setaf 9
	echo "System requirements not met. This script supports GNOME DE with versions 3.38 and above using X11 or Wayland!!!"
	tput setaf 10
	echo "Current DE is GNOME-based: $isgnome"
	echo "Your current DE is $XDG_CURRENT_DESKTOP."
	if echo $XDG_CURRENT_DESKTOP | grep -qi "gnome"
	then
		echo "Your GNOME version is $gnomeversion."
	fi
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
	echo "====================================="
	echo " --- GNOME Reset App Grid Layout ---"
	echo "====================================="
	tput setaf 10
	echo "Current DE is GNOME-based: $isgnome"
	echo "Your current DE is $XDG_CURRENT_DESKTOP."
	if echo $XDG_CURRENT_DESKTOP | grep -qi "gnome"
	then
		echo "Your GNOME version is $gnomeversion."
	fi
	echo "Current Session Type: $XDG_SESSION_TYPE"
	tput setaf 3
	echo "Supported GNOME Versions: 3.38 and above"
	echo "This script resets the GNOME App Grid to the default."
	echo "Note that certain extensions may infere with this script or make the script unnecessary. Such extensions include ones that force the app grid into alphabetical sorting or replace the app grid entirely."
	tput setaf 9
	echo "If you are using this script on Wayland, you will have to restart the desktop manually by relogging or restarting the computer!!!"
	tput setaf 3
	echo "X11 users are not affected by this."
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
waylandwarning () {
	clear
	tput setaf 3
	echo "We noticed that you are using Wayland as your session type."
	echo "While a desktop restart is needed, this script WILL NOT restart the desktop for you as you are using Wayland."
	tput setaf 9
	echo "Restarting the desktop on Wayland will cause everything to close and may potentially lead to data loss."
	tput setaf 3
	echo "Please restart the desktop yourself by relogging or restarting the computer (after saving your work)."
	tput sgr0
	echo "Hit any key to continue:"
	IFS=""
	read -sN1 answer
}
echo "Loaded waylandwarning."
runscript () {
	clear
	tput setaf 3
	echo "Resetting App Grid Layout..."
	tput sgr0
	sleep 3
	runcheck gsettings reset org.gnome.shell app-picker-layout
	if echo $XDG_SESSION_TYPE | grep -qi "x11"
	then
		runcheck busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart("Restarting…")' > /dev/null
		sleep 3
	elif echo $XDG_SESSION_TYPE | grep -qi "wayland"
	then
		waylandwarning
	fi
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
