#!/usr/bin/env sh

# Script to manually refresh the 4 panel stream monitors

xfce4-panel --plugin-event=genmon-21:refresh:bool:true
xfce4-panel --plugin-event=genmon-23:refresh:bool:true
xfce4-panel --plugin-event=genmon-25:refresh:bool:true
xfce4-panel --plugin-event=genmon-27:refresh:bool:true
