#!/bin/bash
# Start of Function Cluster
mainmenu () {
	clear
	tput setaf 3
	echo "====================================="
	echo " --- GNOME Reset App Grid Layout ---"
	echo "====================================="
	tput setaf 9
	echo "This should only be used on GNOME 3.38 and above!!!"
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
	echo "Resetting App Grid Layout..."
	tput sgr0
	sleep 3
	clear
	gsettings reset org.gnome.shell app-picker-layout
	busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart("Restarting…")'
	finish
}
# End of Function Cluster
# Start of Main Script
while true
do
	mainmenu
done
# End of Main Script
