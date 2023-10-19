#!/usr/bin/env bash

# Script to initialise Xfce config files, need to be run when Xfce4 not loaded (e.g. from Arch terminal)

currentTheme=""

if [[ "$1" == "railscasts" ]]; then
	echo "Loading Railscasts"
	currentTheme="railscasts"
elif [[ "$1" == "dracula" ]]; then
	echo "Loading Dracula"
	currentTheme="dracula"
else
	echo "Error, no colour scheme specified, please specify current colourscheme"
	echo "Options are:"
	echo "  railscasts"
	echo "  dracula"
	exit
fi

sed 's/GENERICUSERNAME/OUTPUTUSERNAME/g' ~/Programs/configure/xfce4/xfce4-panel-$currentTheme.xml > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
sed 's/GENERICUSERNAME/OUTPUTUSERNAME/g' ~/Programs/configure/xfce4/xfce4-keyboard-shortcuts-$currentTheme.xml > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml

cp ~/Programs/configure/xfce4/thunar.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
cp ~/Programs/configure/xfce4/xsettings-$currentTheme.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
cp ~/Programs/configure/xfce4/xfwm4-$currentTheme.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
cp ~/Programs/configure/xfce4/xfce4-screensaver-$currentTheme.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-screensaver.xml
