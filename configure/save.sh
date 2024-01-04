#!/usr/bin/env bash

# Script to save current dotfiles as a given theme in git repo

currentTheme=""

if [[ "$1" == "railscasts" ]]; then
	echo "Saving current as Railscasts"
	currentTheme="railscasts"
elif [[ "$1" == "dracula" ]]; then
	echo "Saving current as Dracula"
	currentTheme="dracula"
else
	echo "Error, no colour scheme specified, please specify current colourscheme"
	echo "Options are:"
	echo "  railscasts"
	echo "  dracula"
	exit
fi

[ -d ~/Programs/configure/home ] || mkdir ~/Programs/configure/home
[ -d ~/Programs/configure/root ] || mkdir ~/Programs/configure/root

[ -d ~/Programs/configure/home/.config ] || mkdir ~/Programs/configure/home/.config
[ -d ~/Programs/configure/home/.local ] || mkdir ~/Programs/configure/home/.local

cp ~/.bashrc ~/Programs/configure/home/
cp ~/.inputrc ~/Programs/configure/home/
cp ~/.profile ~/Programs/configure/home/

[ -d ~/Programs/configure/home/.config/systemd/user ] || mkdir -p ~/Programs/configure/home/.config/systemd/user
cp ~/.config/systemd/user/files.service ~/Programs/configure/home/.config/systemd/user/
cp ~/.config/systemd/user/files.timer ~/Programs/configure/home/.config/systemd/user/
cp ~/.config/systemd/user/panelRefresh.service ~/Programs/configure/home/.config/systemd/user/
cp ~/.config/systemd/user/panelRefresh.timer ~/Programs/configure/home/.config/systemd/user/

[ -d ~/Programs/configure/home/.config/ranger ] || mkdir ~/Programs/configure/home/.config/ranger
cp ~/.config/ranger/rc.conf ~/Programs/configure/home/.config/ranger/rc.conf
cp ~/.config/ranger/scope.sh ~/Programs/configure/home/.config/ranger/scope.sh
chmod -x ~/Programs/configure/home/.config/ranger/scope.sh

[ -d ~/Programs/configure/home/.config/alacritty ] || mkdir ~/Programs/configure/home/.config/alacritty
cp ~/.config/alacritty/alacritty.toml "$HOME/Programs/configure/home/.config/alacritty/$currentTheme.toml"
[ -d ~/Programs/configure/home/.config/btop ] || mkdir ~/Programs/configure/home/.config/btop
cp ~/.config/btop/btop.conf ~/Programs/configure/home/.config/btop/$currentTheme.conf
[ -d ~/Programs/configure/home/.config/Code\ -\ OSS/User ] || mkdir -p ~/Programs/configure/home/.config/Code\ -\ OSS/User
cp ~/.config/Code\ -\ OSS/User/settings.json "$HOME/Programs/configure/home/.config/Code - OSS/User/$currentTheme.json"
[ -d ~/Programs/configure/home/.config/glow ] || mkdir ~/Programs/configure/home/.config/glow
cp ~/.config/glow/glow.yml ~/Programs/configure/home/.config/glow/
cp ~/.config/glow/theme.json "$HOME/Programs/configure/home/.config/glow/$currentTheme.json"
[ -d ~/Programs/configure/home/.config/gtk-3.0 ] || mkdir ~/Programs/configure/home/.config/gtk-3.0
cp ~/.config/gtk-3.0/gtk.css "$HOME/Programs/configure/home/.config/gtk-3.0/$currentTheme.css"
[ -d ~/Programs/configure/home/.config/htop ] || mkdir ~/Programs/configure/home/.config/htop
cp ~/.config/htop/htoprc ~/Programs/configure/home/.config/htop/
[ -d ~/Programs/configure/home/.config/mpv ] || mkdir ~/Programs/configure/home/.config/mpv
[ -d ~/Programs/configure/home/.config/mpv/scripts ] || mkdir ~/Programs/configure/home/.config/mpv/scripts
cp ~/.config/mpv/mpv.conf ~/Programs/configure/home/.config/mpv/
cp ~/.config/mpv/input.conf ~/Programs/configure/home/.config/mpv/
cp ~/.config/mpv/scripts/oscPeek.lua ~/Programs/configure/home/.config/mpv/scripts/oscPeek.lua
cp ~/.config/mpv/scripts/lockSize.lua ~/Programs/configure/home/.config/mpv/scripts/lockSize.lua
cp ~/.config/mpv/scripts/osc_tethys.lua ~/Programs/configure/home/.config/mpv/scripts/osc_tethys.lua
[ -d ~/Programs/configure/home/.config/neofetch ] || mkdir ~/Programs/configure/home/.config/neofetch
cp ~/.config/neofetch/config.conf ~/Programs/configure/home/.config/neofetch/
[ -d ~/Programs/configure/home/.config/qalculate ] || mkdir ~/Programs/configure/home/.config/qalculate
[ -d ~/Programs/configure/home/.config/zathura ] || mkdir ~/Programs/configure/home/.config/zathura
cp ~/.config/zathura/zathurarc ~/Programs/configure/home/.config/zathura/zathurarc

cp ~/.config/qalculate/qalc.cfg ~/Programs/configure/home/.config/qalculate/
[ -d ~/Programs/configure/home/.config/rofi ] || mkdir ~/Programs/configure/home/.config/rofi
cp ~/.config/rofi/config.rasi ~/Programs/configure/home/.config/rofi/
[ -d ~/Programs/configure/home/.config/songrec ] || mkdir ~/Programs/configure/home/.config/songrec
cp ~/.config/songrec/preferences.toml ~/Programs/configure/home/.config/songrec/
[ -d ~/Programs/configure/home/.config/npm ] || mkdir ~/Programs/configure/home/.config/npm
cp ~/.config/npm/npmrc ~/Programs/configure/home/.config/npm/
[ -d ~/Programs/configure/home/.config/micro ] || mkdir ~/Programs/configure/home/.config/micro
[ -d ~/Programs/configure/home/.config/micro/colorschemes ] || mkdir ~/Programs/configure/home/.config/micro/colorschemes
cp ~/.config/micro/bindings.json ~/Programs/configure/home/.config/micro/
cp ~/.config/micro/settings.json ~/Programs/configure/home/.config/micro/settings-$currentTheme.json
cp ~/.config/micro/colorschemes/railscastscustom.micro ~/Programs/configure/home/.config/micro/colorschemes/
cp ~/.config/micro/colorschemes/draculacustom.micro ~/Programs/configure/home/.config/micro/colorschemes/
[ -d ~/Programs/configure/home/.config/cava ] || mkdir ~/Programs/configure/home/.config/cava
cp ~/.config/cava/config ~/Programs/configure/home/.config/cava/
[ -d ~/Programs/configure/home/.config/vis ] || mkdir ~/Programs/configure/home/.config/vis
cp ~/.config/vis/config ~/Programs/configure/home/.config/vis/
[ -d ~/Programs/configure/home/.config/cool-retro-term ] || mkdir ~/Programs/configure/home/.config/cool-retro-term
cp ~/.config/cool-retro-term/cool-retro-term.conf ~/Programs/configure/home/.config/cool-retro-term/

[ -d ~/Programs/configure/home/.local/share/gtksourceview-3.0/styles ] || mkdir -p ~/Programs/configure/home/.local/share/gtksourceview-3.0/styles
[ -d ~/Programs/configure/home/.local/share/gtksourceview-4/styles ] || mkdir -p ~/Programs/configure/home/.local/share/gtksourceview-4/styles
cp ~/.local/share/gtksourceview-3.0/styles/railscasts.xml ~/Programs/configure/home/.local/share/gtksourceview-3.0/styles/
cp ~/.local/share/gtksourceview-3.0/styles/dracula.xml ~/Programs/configure/home/.local/share/gtksourceview-3.0/styles/
cp ~/.local/share/gtksourceview-4/styles/railscasts.xml ~/Programs/configure/home/.local/share/gtksourceview-4/styles/
cp ~/.local/share/gtksourceview-4/styles/dracula.xml ~/Programs/configure/home/.local/share/gtksourceview-4/styles/
[ -d ~/Programs/configure/home/.local/share/rofi/themes ] || mkdir -p ~/Programs/configure/home/.local/share/rofi/themes
cp ~/.local/share/rofi/themes/harris.rasi "$HOME/Programs/configure/home/.local/share/rofi/themes/$currentTheme.rasi"
#[ -d ~/Programs/configure/root/usr/share/gtksourceview-4/language-specs ] || mkdir -p ~/Programs/configure/root/usr/share/gtksourceview-4/language-specs
#cp /usr/share/gtksourceview-4/language-specs/csv.lang ~/Programs/configure/root/usr/share/gtksourceview-4/language-specs/
[ -d ~/Programs/configure/root/etc/udev/hwdb.d ] || mkdir -p ~/Programs/configure/root/etc/udev/hwdb.d
cp /etc/udev/hwdb.d/65-keyboard-custom.hwdb ~/Programs/configure/root/etc/udev/hwdb.d/

# Xfce stuff 

[ -d ~/Programs/configure/xfce4  ] || mkdir ~/Programs/configure/xfce4 

sed 's/USERNAMEA/GENERICUSERNAME/g' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml | sed '/		<value type="string" value="wi-fi network connection/d' | sed '/		<value type="string" value="configuring wi-fi network connection/d' | sed '/		<value type="string" value="requesting a wi-fi network address for/d' | sed '/		<value type="string" value="preparing wi-fi network connection/d' > ~/Programs/configure/xfce4/xfce4-panel-$currentTheme.xml
sed 's/USERNAMEA/GENERICUSERNAME/g' ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-keyboard-shortcuts.xml > ~/Programs/configure/xfce4/xfce4-keyboard-shortcuts-$currentTheme.xml

cp ~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml ~/Programs/configure/xfce4/
cp ~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml ~/Programs/configure/xfce4/xsettings-$currentTheme.xml
cp ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml ~/Programs/configure/xfce4/xfwm4-$currentTheme.xml
cp ~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-screensaver.xml ~/Programs/configure/xfce4/xfce4-screensaver-$currentTheme.xml
