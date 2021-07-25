#!/bin/bash
# Start of Function Cluster
displayfunction () {
	clear
	tput setaf 3
	echo "Making all scripts executable..."
	tput sgr0
	sleep 3
	makeallexecutable
}
makeallexecutable () {
	find $(dirname "$0") -type f -iname "*.sh" -print0 | xargs -0 chmod +x
	finish
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
quitscript () {
	tput sgr0
	clear
	exit
}
# End of Function Cluster
# Start of Main Script
while true
do
	displayfunction
done
# End of Main Script
