#!/bin/bash
clear
# Start of Function Cluster
tput setaf 3
echo "Initializing functions..."
sleep 1.5
tput setaf 10
checkcompatibility () {
	# Set variables
	islinux=false
	issudo=false
	isiptables=false
	ischromiumos=false
	
	# Check for Linux
	if ! uname -a | grep -qi "Linux"
	then
		sysreqfail
	fi
	islinux=true
	
	# Check for sudo
	if ! type sudo &>/dev/null
	then
		sysreqfail
	fi
	issudo=true
	
	# Check for iptables
	if ! type iptables &>/dev/null
	then
		sysreqfail
	fi
	isiptables=true
	
	# Check for Chrome OS/Chromium OS
	if grep -qi "chromiumos" /etc/os-release
	then
		ischromiumos=true
		sysreqfail
	fi
}
echo "Loaded checkcompatibility."
sysreqfail () {
	clear
	tput setaf 9
	echo "System requirements not met. This script supports Linux systems with sudo and iptables!!! Additionally, not all ChromiumOS-based systems in developer mode will have iptables with the required features. However, it has been verified that iptables is fully working on ChromeOS using the Brunch Framework."
	tput setaf 10
	echo "Is Linux: $islinux"
	if echo $islinux | grep -qi "true"
	then
		echo "sudo accessible: $issudo"
		echo "iptables accessible: $isiptables"
		echo "Chromium OS-based: $ischromiumos"
		tput setaf 6
		echo "Note that certain Linux systems, such as Debian and ChromiumOS in developer mode, do not expose iptables unless running as root or using sudo. If you are sure that your system has iptables accessible, press <return> to bypass this prompt."
		echo "If you are running a ChromiumOS-based system and you are sure that iptables has the correct features, press <return> to bypass this prompt."
	fi
	tput sgr0
	echo "Hit any key to exit or press <return> to bypass this prompt:"
	IFS=""
	read -sN1 answer
	case $(echo "$answer" | tr A-Z a-z) in
		"")	mainmenu;;
		*)	quitscript;;
	esac
}
echo "Loaded sysreqfail."
mainmenu () {
	clear
	tput setaf 3
	echo "====================================="
	echo " --- Linux Tether TTL 65 Bypass ---"
	echo "====================================="
	echo "Supports all Linux with iptables (manual usage on routers using WRT)"
	tput setaf 10
	echo "Is Linux: $islinux"
	echo "sudo accessible: $issudo"
	echo "iptables accessible: $isiptables"
	echo "Chromium OS-based: $ischromiumos"
	tput setaf 6
	echo "Please note that the bypass will only stay applied until the system is rebooted. To use the bypass again, simply run the script again. In addition, this bypass is valid for tethering from both Android and iOS, and does not need a VPN to make the bypass work."
	echo "For use on routers, it is recommended to take the 4 commands used in the bypass (noted with comments) and paste them into custom iptables firewall rules in the router web interface. Make sure to remove the beginning runcheck and sudo! If your router does not have the applicable web interface for rules, make sure to insert the commands in a file that the router uses for startup commands."
	tput setaf 3
	echo "Press 1 to apply the bypass."
	echo "Press 2 to flush iptables rules."
	tput setaf 9
	echo "Press Q to quit." 
	tput sgr0
	echo "Enter your selection:"
	IFS=""
	read -sN1 answer
	case $(echo "$answer" | tr A-Z a-z) in
		1)	applybypass;;
		2)	flushtables;;
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
	echo "Action successfully completed."
	tput setaf 3
	echo "Press any key to exit..."
	tput sgr0
	IFS=""
	read -sN1 answer
	quitscript
}
echo "Loaded finish."
applybypass () {
	clear
	tput setaf 3
	echo "Applying Bypass..."
	sleep 3
	clear
	tput sgr0
	runcheck sudo iptables -t mangle -I POSTROUTING -j TTL --ttl-set 65
	runcheck sudo iptables -t mangle -I PREROUTING -j TTL --ttl-set 65
	runcheck sudo ip6tables -t mangle -I POSTROUTING ! -p icmpv6 -j HL --hl-set 65
	runcheck sudo ip6tables -t mangle -I PREROUTING ! -p icmpv6 -j HL --hl-set 65
	sleep 3
	finish
}
echo "Loaded applybypass."
flushtables () {
	clear
	tput setaf 3
	echo "Flushing iptables Rules..."
	sleep 3
	clear
	tput sgr0
	runcheck sudo iptables -F
	runcheck sudo ip6tables -F
	sleep 3
	finish
}
echo "Loaded flushtables."
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
		echo "Oops! A fatal error has occurred and the program case $(echo "$answer" | tr A-Z a-z) in
		1)	applybypass;;
		2)	flushtables;;
		q)	quitscript;;
		*)	badoption;;
	esaccannot continue. Returning to the main menu in 10 seconds..."
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
