# Panel Setup (Items and Settings)

Set Row Size to `36`  
Turn on Asjust Icon Size Automatically  
Set background to `Solid colour` with colour `#2B2B2B`

## Program Management

Applications Menu  
Window Buttons:   
	-  Untick `Group Windows By Application`  
Seperator  
	- Transparent and Expand  
Workspace Switcher 

## Livestream Monitors 

`echo "<img>HOME/Programs/output/.pictures/destinyPanel.jpg</img><tool>Destiny</tool>"`  
`HOME/Programs/system/panel/panelDestiny.sh`  
`echo "<img>HOME/Programs/output/.pictures/chudlogicPanel.jpg</img><tool>Chud Logic</tool>"`  
`HOME/Programs/system/panel/panelChudLogic.sh`  
`echo "<img>HOME/Programs/output/.pictures/nerdcubedPanel.jpg</img><tool>NerdCubed</tool>"`  
`HOME/Programs/system/panel/panelNerdCubed.sh`  
`echo "<img>HOME/Programs/output/.pictures/matnPanel.jpg</img><tool>Many A True Nerd</tool>"`  
`HOME/Programs/system/panel/panelMATN.sh`

Refresh time set to 300 seconds, font size set to `Roboto 16` (doesn't matter for images)

## System Monitors 

`echo "<txt><span foreground='#6d9cbe'> </span></txt><tool>CPU Usage</tool>"`  
`python3 HOME/Programs/system/panel/cpu.py`  
`echo "<txt><span foreground='#da4939'> </span></txt><tool>CPU Temperature</tool>"`  
`HOME/Programs/system/panel/cputemp.sh`  
`echo "<txt><span foreground='#ffc66d'> </span></txt><tool>RAM Usage</tool>"`  
`HOME/Programs/system/panel/ram.sh`  
`echo "<txt><span foreground='#b3b3ed'> </span></txt><tool>Network Download</tool>"`  
`HOME/Programs/system/panel/networkDown.sh`

Refresh time set to 2 seconds, font size `Roboto 16` for icons, `Roboto Mono 15` for scripts

## Date 

Timezone: `Europe/London`  
Layout: `Date Only`  
Date:  
	Font: `Roboto Medium 16`  
	Format: `Custom Format`  
	`%b, %a %d`
	
## System Tools 

Power Manager Plugin  
PulseAudio Plugin  
Notification Plugin

## Clocks 

### New York

Timezone: `America/New_York`
Tooltip format: `Custom Format`
	`New York (%Z)`
Layout: `Time Only`
Font: `Roboto Medium 16`
Format: `Custom Format`
	`%H:%M |`

### London

Timezone: `Europe/London`
Tooltip format: `Custom Format`
	`London (%Z)`
Layout: `Time Only`
Font: `Roboto Medium 16`
Format: `Custom Format`
	`%H:%M |`

### Japan

Timezone: `Asia/Tokyo`
Tooltip format: `Custom Format`
	`Tokyo (%Z)`
Layout: `Time Only`
Font: `Roboto Medium 16`
Format: `Custom Format`
	`%H:%M `
