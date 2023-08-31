#!/usr/bin/env bash

# Script to initialise Xfce config files, need to be run when Xfce4 not loaded (e.g. from Arch terminal)

sed 's/GENERICUSERNAME/OUTPUTUSERNAME/g' ~/Programs/configure/xfce4/xfce4-panel.xml > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
sed 's/GENERICUSERNAME/OUTPUTUSERNAME/g' ~/Programs/configure/xfce4/xfce4-keyboard-shortcuts.xml > ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml

cp ~/Programs/configure/xfce4/thunar.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml
cp ~/Programs/configure/xfce4/xsettings.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
cp ~/Programs/configure/xfce4/xfwm4.xml ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
