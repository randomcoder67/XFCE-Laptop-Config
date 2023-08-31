#!/usr/bin/env bash

# Script to modify config files if I am setting up desktop PC with 1080p screen instead of laptop with 1400p screen

sed -i 's/Roboto Bold 12/Roboto Bold 10/g' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml
sed -i 's/Roboto 12/Roboto 10/g' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
sed -i 's/Roboto Mono 13/Roboto Mono 11/g' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
sed -i 's/Roboto Medium 16/Roboto Medium 13/g' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
sed -i 's/Roboto 16/Roboto 13/g' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
sed -i 's/Roboto Mono 15/Roboto Mono 12/g' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
sed -i 's/value="36"/value="30"/g' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
sed -i 's/size: 7/size: 11/g' ~/.config/alacritty/alacritty.yml
