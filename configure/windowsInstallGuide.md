# Windows 11 Setup

## Installation

Recommended to use [Ventoy](https://www.ventoy.net/en/index.html) if installing from Linux.  
ISO can be downloaded from [Microsoft website](https://www.microsoft.com/software-download/windows11).  
If you want English (Non-US) download English International. 

### Dual Booting with Arch

Install Windows first on a seperate drive, with main drive disconnected. Then disconnect Windows drive and reconnect main, and [install Arch](archInstallGuide.md). 

## Setup

### NVidia GPU Drivers

Download [DDU](https://www.guru3d.com/download/display-driver-uninstaller-download/) and the correct [NVidia Drivers](https://www.nvidia.co.uk/Download/index.aspx?lang=en-uk)  
Reboot into Safe Mode (shift+click on reboot, option 4 in advanced boot)  
Run DDU to uninstall current drivers, using reboot option  
Once rebooted, install NVidia drivers, deselecting NVidia experience options. Sometimes it fails, just run the installer again, that normally fixes it  

### Installation

[Git](https://git-scm.com/downloads)  
[7Zip](https://www.7-zip.org/)  
[Steam](https://store.steampowered.com/about/)  
[mpv](https://mpv.io/installation/)  
[Firefox](https://www.mozilla.org/en-GB/firefox/new/)  
[Python 3](https://www.python.org/downloads/windows/)  
[Golang](https://go.dev/doc/install)  
[MSI Afterburner](https://www.msi.com/Landing/afterburner/graphics-cards)  
[Microsoft PowerToys](https://learn.microsoft.com/en-us/windows/powertoys/)  
[Alacritty](https://alacritty.org/)  
[TranslucentTB](https://github.com/TranslucentTB/TranslucentTB)  
[GIMP](https://www.gimp.org/)  
[Audacity](https://www.audacityteam.org/)  
[VSCode](https://code.visualstudio.com/)  
[Notepad++](https://notepad-plus-plus.org/)  
[ImageMagick](https://imagemagick.org/index.php)  
[yt-dlp](https://github.com/yt-dlp/yt-dlp)  
[ffmpeg](https://ffmpeg.org/download.html)  
[MediaInfo](https://mediaarea.net/en/MediaInfo)  
[aria2](https://aria2.github.io/)  
[OBS](https://obsproject.com/)  
[SpecialK](https://www.special-k.info/)  

### Windows Subsystem for Linux (WSL)

In PowerShell: `wls --install`

`sudo apt install btop htop cava micro qalc bat ncdu duf neofetch pass jq glow tokei dust nethogs `

