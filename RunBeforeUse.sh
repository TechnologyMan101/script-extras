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
	runcheck find $(dirname "$0") -type f -iname "*.sh" -print0 | xargs -0 chmod +x
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
	displayfunction
done
# End of Main Script
