#!/usr/bin/env bash

mkdir ~/Programs
mkdir ~/Programs/output
mkdir ~/Programs/output/log
mkdir ~/Programs/output/money
mkdir ~/Programs/output/schedule
mkdir ~/Programs/output/.streams
mkdir ~/Programs/output/.streams/panel
mkdir ~/Programs/output/.streams/destinyDownload
mkdir ~/Programs/output/.streams/streamsCheck
mkdir ~/Programs/output/.timers
mkdir ~/Programs/output/.pictures
mkdir ~/Programs/output/.sounds
mkdir ~/Programs/output/.temp
mkdir ~/Programs/output/updated

mkdir -p ~/.config/systemd/user

cp ~/Programs/configure/output/* ~/Programs/output/.pictures/

mkdir -m 700 .local/share/gnupg
localectl set-x11-keymap gb
mkdir ~/Documents
mkdir ~/Downloads
mkdir ~/Pictures
mkdir ~/Videos
mkdir ~/Music
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
mkdir ~/.config/cava
mkdir ~/.config/vis

mkdir ~/.local/share/gnupg
chmod 700 ~/.local/share/gnupg
chmod 600 ~/.local/share/gnupg/*

cp ~/Programs/configure/gtkGreybird.css ~/.local/share/themes/Greybird-dark/gtk-3.0/gtk.css

#	cp -r Programs ~/

cp ~/Programs/configure/home/.bashrc ~/.bashrc
cp ~/Programs/configure/home/.inputrc ~/.inputrc
cp ~/Programs/configure/home/.profile ~/.profile


cp ~/Programs/configure/home/.config/systemd/user/files.service ~/.config/systemd/user/files.service
cp ~/Programs/configure/home/.config/systemd/user/files.timer ~/.config/systemd/user/files.timer
cp ~/Programs/configure/home/.config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
cp ~/Programs/configure/home/.config/btop/btop.conf ~/.config/btop/btop.conf
cp ~/Programs/configure/home/.config/Code\ -\ OSS/User/settings.json ~/.config/Code\ -\ OSS/User/settings.json
#cp ~/Programs/configure/home/.config/gtk-3.0/bookmarks ~/.config/gtk-3.0/bookmarks
cp ~/Programs/configure/home/.config/gtk-3.0/gtk.css ~/.config/gtk-3.0/gtk.css
cp ~/Programs/configure/home/.config/htop/htoprc ~/.config/htop/htoprc
cp ~/Programs/configure/home/.config/mpv/mpv.conf ~/.config/mpv/mpv.conf
cp ~/Programs/configure/home/.config/mpv/input.conf ~/.config/mpv/input.conf
cp ~/Programs/configure/home/.config/mpv/scripts/* ~/.config/mpv/scripts/
cp ~/Programs/configure/home/.config/neofetch/config.conf ~/.config/neofetch/config.conf
cp ~/Programs/configure/home/.config/qalculate/qalc.cfg ~/.config/qalculate/qalc.cfg
cp ~/Programs/configure/home/.config/rofi/config.rasi ~/.config/rofi/config.rasi
cp ~/Programs/configure/home/.config/songrec/preferences.toml ~/.config/songrec/preferences.toml
cp ~/Programs/configure/home/.config/npm/npmrc ~/.config/npm/npmrc
cp ~/Programs/configure/home/.config/micro/bindings.json ~/.config/micro/bindings.json
cp ~/Programs/configure/home/.config/micro/settings.json ~/.config/micro/settings.json
cp ~/Programs/configure/home/.config/cava/config ~/.config/cava/config
cp ~/Programs/configure/home/.config/vis/config ~/.config/vis/config

cp ~/Programs/configure/home/.local/share/gtksourceview-3.0/styles/railscasts.xml ~/.local/share/gtksourceview-3.0/styles/railscasts.xml
cp ~/Programs/configure/home/.local/share/gtksourceview-4/styles/railscasts.xml ~/.local/share/gtksourceview-4/styles/railscasts.xml
cp ~/Programs/configure/home/.local/share/rofi/themes/harris.rasi ~/.local/share/rofi/themes/harris.rasi

cp ~/Programs/configure/home/.config/glow/glow.yml ~/.config/glow/glow.yml
cp ~/Programs/configure/home/.config/glow/railscasts.json ~/.config/glow/railscasts.json

go build -o ~/Programs/terminal/terminalPrograms ~/Programs/terminal/terminalPrograms/log.go
go build -o ~/Programs/terminal/terminalPrograms ~/Programs/terminal/terminalPrograms/schedule.go
go build -o ~/Programs/terminal/terminalPrograms ~/Programs/terminal/terminalPrograms/money.go

gcc ~/Programs/terminal/terminalPrograms/astro/planets.c -o ~/Programs/terminal/terminalPrograms/astro/planets -lm -Wall -Wextra

gcc ~/Programs/system/keyboardOther/soundboard.c -lncurses -o ~/Programs/system/keyboardOther/soundboard -Wall -Wextra

systemctl --user enable files.service
systemctl --user start files.service

systemctl --user enable files.timer
systemctl --user start files.timer

git config --global core.pager cat
