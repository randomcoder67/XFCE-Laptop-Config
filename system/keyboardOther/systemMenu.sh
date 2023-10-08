#!/usr/bin/env bash

# Shutdown with confirmation
shutdown () {
	read -p "Shutdown? (y/N) " yesOrNoShutdown
	[[ "$yesOrNoShutdown" == "y" ]] && xfce4-session-logout -h
}

# Reboot with confirmation
reboot () {
	read -p "Reboot? (y/N) " yesOrNoReboot
	[[ "$yesOrNoReboot" == "y" ]] && xfce4-session-logout -r
}

# Hibernate to disk with confirmation
hibernate () {
	read -p "Hibernate? (y/N) " yesOrNoHibernate
	[[ "$yesOrNoHibernate" == "y" ]] && xfce4-session-logout -i
}

# Hybrid-Sleep with confirmation, i.e. sleep to RAM and disk in case battery dies
hybrid-sleep () {
	read -p "Hybrid-Sleep? (y/N) " yesOrNoHybridSleep
	[[ "$yesOrNoHybridSleep" == "y" ]] && xfce4-session-logout -b
}

# Sleep with confirmation (i.e. RAM only)
qsleep () {
	read -p "Sleep? (y/N) " yesOrNoQSleep
	[[ "$yesOrNoQSleep" == "y" ]] && xfce4-session-logout -s
}

# Log Out with confirmation
log-out () {
	read -p "Log Out? (y/N) " yesOrNoLogOut
	[[ "$yesOrNoLogOut" == "y" ]] && xfce4-session-logout -l
}

# Lock screen with confirmation
lock () {
	read -p "Lock Screen? (y/N) " yesOrNoLock
	[[ "$yesOrNoLock" == "y" ]] && xfce4-screensaver-command -l
}

black='\033[0;30m'
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
blue='\033[0;34m'
magenta='\033[0;35m'
cyan='\033[0;36m'
white='\033[0;37m'
colourOff='\033[0m'

echo -e "${magenta}System Functions:${colourOff}"
echo -e "${cyan}sd:${colourOff} ${red}Shutdown${colourOff}"
echo -e "${cyan}r:${colourOff}  ${red}Reboot${colourOff}"
echo -e "${cyan}s:${colourOff}  ${yellow}Sleep${colourOff}"
echo -e "${cyan}h:${colourOff}  ${red}Hibernate${colourOff}"
echo -e "${cyan}hs:${colourOff} ${yellow}Hybrid-Sleep${colourOff}"
echo -e "${cyan}lo:${colourOff} ${red}Log Out${colourOff}"
echo -e "${cyan}l:${colourOff}  ${yellow}Lock${colourOff}"
echo -e "${cyan}v:${colourOff}  ${blue}Arch Terminal${colourOff}"

read -p "Enter Command: " inputCommand

[[ "$inputCommand" == "sd" ]] && shutdown
[[ "$inputCommand" == "r" ]] && reboot
[[ "$inputCommand" == "s" ]] && qsleep
[[ "$inputCommand" == "h" ]] && hibernate
[[ "$inputCommand" == "hs" ]] && hybrid-sleep
[[ "$inputCommand" == "lo" ]] && log-out
[[ "$inputCommand" == "l" ]] && lock
[[ "$inputCommand" == "v" ]] && sudo chvt 2

exit
