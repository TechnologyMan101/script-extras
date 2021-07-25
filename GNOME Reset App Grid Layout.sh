#!/bin/bash
# Start of Function Cluster
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
runscript () {
	clear
	tput setaf 3
	echo "Resetting App Grid Layout..."
	tput sgr0
	sleep 3
	gsettings reset org.gnome.shell app-picker-layout
	if echo $XDG_SESSION_TYPE | grep -qi "x11"
	then
		busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart("Restarting…")' > /dev/null
		sleep 3
	elif echo $XDG_SESSION_TYPE | grep -qi "wayland"
	then
		waylandwarning
	fi
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
