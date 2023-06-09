# XFCE 4 Config

## Screenshots 

![Screenshot 1](configure/screenshots/screenshot1.png)
![Screenshot 2](configure/screenshots/screenshot2.png)

## Installation 

### Dependancies

Installed when installing Arch: 

`sudo pacman -S base linux linux-firmware nano networkmanager sudo xorg-server xfce4 lightdm lightdm-gtk-greeter intel-ucode/amd-ucode grub efibootmgr`

Installed when installing programs:

`sudo pacman -S papirus-icon-theme xfce4-genmon-plugin mousepad xfce4-screenshooter firefox rofi sassc unzip thunar-archive-plugin man xfce4-pulseaudio-plugin meson ninja python-pip gcc imagemagick xclip bc xdg-utils base-devel trash-cli libxtst pkg-config libqalculate btop htop make bat ncdu duf mpv ffmpeg mediainfo yt-dlp hyperfine xdotool aspell-en songrec pavucontrol alsa-firmware sof-firmware pulseaudio-alsa glow jq intel-gpu-tools intel-media-driver progress ristretto neofetch gimp expect pass fuse alacritty gnome-keyring rsync go`

Also needed: 

* Greybird Dark theme 
* Font Awesome free font 
* Roboto 
* Roboto Mono 
* ksuperkey 

Wallpapers are mainly from here:  
[NASA Image of the Day](https://www.nasa.gov/multimedia/imagegallery/iotd.html)

### Setup 

Clone this repositry into a folder named `~/Programs`  
`sed -i 's/$HOME/\/home\/YOUR_USERNAME/g' ~/Programs/configure/init.sh  
Run `~/Programs/configure/init.sh` file

## Usage 

[See README in configure folder](https://github.com/randomcoder67/XFCE-Laptop-Config/tree/main/configure#readme)
