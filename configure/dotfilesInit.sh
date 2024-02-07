#!/usr/bin/env bash

# Script to initalise dotfiles in given theme

currentTheme=""

if [[ "$1" == "railscasts" ]]; then
	echo "Loading Railscasts"
	currentTheme="railscasts"
elif [[ "$1" == "dracula" ]]; then
	echo "Loading Dracula"
	currentTheme="dracula"
else
	echo "Error, no colour scheme specified, please specify desired colourscheme"
	echo "Options are:"
	echo "  railscasts"
	echo "  dracula"
	exit
fi

mkdir ~/Programs
mkdir ~/Programs/output
mkdir ~/Programs/output/log
mkdir ~/Programs/output/money
mkdir ~/Programs/output/schedule
mkdir ~/Programs/output/youtubeHistory
mkdir ~/Programs/output/.streams
mkdir ~/Programs/output/.streams/panel
mkdir ~/Programs/output/.streams/destinyDownload
mkdir ~/Programs/output/.streams/streamsCheck
mkdir ~/Programs/output/.timers
mkdir ~/Programs/output/.pictures
mkdir ~/Programs/output/.sounds
mkdir ~/Programs/output/.temp
mkdir ~/Programs/output/updated

mkdir ~/Downloads/BackupMount
mkdir ~/Downloads/USBDrive

echo "$currentTheme" > ~/Programs/output/updated/currentTheme.txt

mkdir -p ~/.config/systemd/user

cp ~/Programs/configure/output/* ~/Programs/output/.pictures/

localectl set-x11-keymap gb
mkdir ~/Documents
mkdir ~/Downloads
mkdir ~/Pictures
mkdir ~/Videos
mkdir ~/Music
mkdir ~/Work
mkdir ~/Pictures/mpv

mkdir -p ~/.local/share/rofi/themes
mkdir -p ~/.local/share/gtksourceview-3.0/styles
mkdir -p ~/.local/share/gtksourceview-4/styles
mkdir -p ~/.local/share/fonts
mkdir -p ~/.local/share/themes

mkdir ~/.config/htop
mkdir ~/.config/rofi
mkdir ~/.config/glow
mkdir ~/.config/mpv
mkdir ~/.config/mpv/scripts
mkdir ~/.config/btop
mkdir ~/.config/songrec
mkdir ~/.config/neofetch
mkdir ~/.config/qalculate
mkdir ~/.config/gtk-3.0
mkdir -p ~/.config/Code\ -\ OSS/User/
mkdir ~/.config/alacritty
mkdir ~/.config/npm
mkdir ~/.config/micro
mkdir ~/.config/micro/colorschemes
mkdir ~/.config/cava
mkdir ~/.config/vis
mkdir ~/.config/cool-retro-term
mkdir ~/.config/zathura

mkdir ~/.local/share/gnupg
chmod 700 ~/.local/share/gnupg
chmod 600 ~/.local/share/gnupg/*

cp ~/Programs/configure/$currentTheme.css ~/.local/share/themes/Greybird-dark/gtk-3.0/gtk.css

#	cp -r Programs ~/

cp ~/Programs/configure/home/.bashrc ~/.bashrc
cp ~/Programs/configure/home/.inputrc ~/.inputrc
cp ~/Programs/configure/home/.profile ~/.profile

cp ~/Programs/configure/home/.config/systemd/user/files.service ~/.config/systemd/user/files.service
cp ~/Programs/configure/home/.config/systemd/user/files.timer ~/.config/systemd/user/files.timer
cp ~/Programs/configure/home/.config/systemd/user/panelRefresh.service ~/.config/systemd/user/panelRefresh.service
cp ~/Programs/configure/home/.config/systemd/user/panelRefresh.timer ~/.config/systemd/user/panelRefresh.timer
cp ~/Programs/configure/home/.config/alacritty/$currentTheme.toml ~/.config/alacritty/alacritty.toml
cp ~/Programs/configure/home/.config/ranger/rc.conf ~/.config/ranger/rc.conf
cp ~/Programs/configure/home/.config/ranger/scope.sh ~/.config/ranger/scope.sh
chmod +x ~/.config/ranger/scope.sh
cp ~/Programs/configure/home/.config/btop/$currentTheme.conf ~/.config/btop/btop.conf
cp ~/Programs/configure/home/.config/Code\ -\ OSS/User/$currentTheme.json ~/.config/Code\ -\ OSS/User/settings.json
#cp ~/Programs/configure/home/.config/gtk-3.0/bookmarks ~/.config/gtk-3.0/bookmarks
cp ~/Programs/configure/home/.config/gtk-3.0/$currentTheme.css ~/.config/gtk-3.0/gtk.css
cp ~/Programs/configure/home/.config/htop/htoprc ~/.config/htop/htoprc
cp ~/Programs/configure/home/.config/mpv/mpv.conf ~/.config/mpv/mpv.conf
cp ~/Programs/configure/home/.config/mpv/input.conf ~/.config/mpv/input.conf
cp ~/Programs/configure/home/.config/mpv/scripts/oscPeek.lua ~/.config/mpv/scripts/oscPeek.lua
cp ~/Programs/configure/home/.config/mpv/scripts/lockSize.lua ~/.config/mpv/scripts/lockSize.lua
cp ~/Programs/configure/home/.config/mpv/scripts/osc_tethys.lua ~/.config/mpv/scripts/osc_tethys.lua
cp ~/Programs/configure/home/.config/neofetch/config.conf ~/.config/neofetch/config.conf
cp ~/Programs/configure/home/.config/qalculate/qalc.cfg ~/.config/qalculate/qalc.cfg
cp ~/Programs/configure/home/.config/rofi/config.rasi ~/.config/rofi/config.rasi
cp ~/Programs/configure/home/.config/songrec/preferences.toml ~/.config/songrec/preferences.toml
cp ~/Programs/configure/home/.config/npm/npmrc ~/.config/npm/npmrc
cp ~/Programs/configure/home/.config/micro/bindings.json ~/.config/micro/bindings.json
cp ~/Programs/configure/home/.config/micro/settings-$currentTheme.json ~/.config/micro/settings.json
cp ~/Programs/configure/home/.config/micro/colorschemes/railscastscustom.micro ~/.config/micro/colorschemes/railscasts.micro
cp ~/Programs/configure/home/.config/micro/colorschemes/draculacustom.micro ~/.config/micro/colorschemes/draculacustom.micro
cp ~/Programs/configure/home/.config/cava/config ~/.config/cava/config
cp ~/Programs/configure/home/.config/vis/config ~/.config/vis/config
cp ~/Programs/configure/home/.config/cool-retro-term/cool-retro-term.conf ~/.config/cool-retro-term/cool-retro-term.conf
cp ~/Programs/configure/home/.config/zathura/zathurarc ~/.config/zathura/zathurarc

cp ~/Programs/configure/home/.local/share/gtksourceview-3.0/styles/railscasts.xml ~/.local/share/gtksourceview-3.0/styles/railscasts.xml
cp ~/Programs/configure/home/.local/share/gtksourceview-4/styles/railscasts.xml ~/.local/share/gtksourceview-4/styles/railscasts.xml
cp ~/Programs/configure/home/.local/share/gtksourceview-3.0/styles/dracula.xml ~/.local/share/gtksourceview-3.0/styles/dracula.xml
cp ~/Programs/configure/home/.local/share/gtksourceview-4/styles/dracula.xml ~/.local/share/gtksourceview-4/styles/dracula.xml
cp ~/Programs/configure/home/.local/share/rofi/themes/$currentTheme.rasi ~/.local/share/rofi/themes/harris.rasi

cp ~/Programs/configure/home/.config/glow/glow.yml ~/.config/glow/glow.yml
cp ~/Programs/configure/home/.config/glow/$currentTheme.json ~/.config/glow/theme.json

mkdir ~/Programs/terminal/terminalPrograms/goBins
go build -o ~/Programs/terminal/terminalPrograms/goBins ~/Programs/terminal/terminalPrograms/log.go
go build -o ~/Programs/terminal/terminalPrograms/goBins ~/Programs/terminal/terminalPrograms/schedule.go
go build -o ~/Programs/terminal/terminalPrograms/goBins ~/Programs/terminal/terminalPrograms/money.go
go build -o ~/Programs/terminal/terminalPrograms/goBins ~/Programs/terminal/terminalPrograms/timer.go
go build -o ~/Programs/terminal/terminalPrograms/goBins ~/Programs/terminal/terminalPrograms/days.go
go build -o ~/Programs/terminal/terminalPrograms/goBins/metricTime ~/Programs/terminal/terminalPrograms/metricTime.go
go build -o ~/Programs/terminal/terminalPrograms/goBins/downloadTime ~/Programs/terminal/terminalPrograms/downloadTime.go
go build -o ~/Programs/system/rofi/metoffice-geohash ~/Programs/system/rofi/geohash.go
cd ~/Programs/terminal/terminalPrograms/notesRenderer
go mod tidy
go build -o ~/Programs/terminal/terminalPrograms/goBins ~/Programs/terminal/terminalPrograms/notesRenderer/render.go

cd ~/Programs/terminal/webAlternatives/
go mod tidy
go build -o ~/Programs/terminal/webAlternatives/ ~/Programs/terminal/webAlternatives/youtubeSearch.go
cd ~/Programs/configure

gcc ~/Programs/terminal/terminalPrograms/astro/planets.c -o ~/Programs/terminal/terminalPrograms/astro/planets -lm -Wall -Wextra

gcc ~/Programs/system/keyboardOther/soundboard.c -lncurses -o ~/Programs/system/keyboardOther/soundboard -Wall -Wextra

systemctl --user enable files.service
systemctl --user start files.service

systemctl --user enable files.timer
systemctl --user start files.timer

systemctl --user enable panelRefresh.service
systemctl --user start panelRefresh.service

systemctl --user enable panelRefresh.timer
systemctl --user start panelRefresh.timer

git config --global core.pager cat

git clone "https://github.com/randomcoder67/Media-UI" $HOME/Programs/myRepos/Media-UI
cd "$HOME/Programs/myRepos/Media-UI"
make
mkdir ~/.config/micro/syntax
mkdir ~/.local/share/gtksourceview-3.0/language-specs/
mkdir ~/.local/share/gtksourceview-4/language-specs/
git clone "https://github.com/randomcoder67/Consistent-Syntax-Highlighting" $HOME/Programs/myRepos/Consistent-Syntax-Highlighting
cd "$HOME/Programs/myRepos/Consistent-Syntax-Highlighting"
make
git clone "https://github.com/randomcoder67/Go-Terminal-Weather" $HOME/Programs/myRepos/Go-Terminal-Weather
cd "$HOME/Programs/myRepos/Go-Terminal-Weather"
make
git clone "https://github.com/randomcoder67/Go-Terminal-Strava" $HOME/Programs/myRepos/Go-Terminal-Strava
cd "$HOME/Programs/myRepos/Go-Terminal-Strava"
make
