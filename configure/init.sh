#!/usr/bin/env bash

mkdir ~/Programs
mkdir ~/Programs/output
mkdir ~/Programs/output/log
mkdir ~/Programs/output/money
mkdir ~/Programs/output/schedule
mkdir ~/Programs/output/.streams
mkdir ~/Programs/output/.streams/panel
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

mkdir -p ~/.local/share/rofi/themes
mkdir -p ~/.local/share/gtksourceview-3.0/styles
mkdir -p ~/.local/share/gtksourceview-4/styles
mkdir -p ~/.local/share/fonts
mkdir -p ~/.local/share/themes

mkdir ~/.config/htop
mkdir ~/.config/rofi
mkdir ~/.config/glow
mkdir ~/.config/mpv
mkdir ~/.config/btop
mkdir ~/.config/songrec
mkdir ~/.config/youtube-viewer
mkdir ~/.config/neofetch
mkdir ~/.config/qalculate
mkdir ~/.config/gtk-3.0
mkdir -p ~/.config/Code\ -\ OSS/User/
mkdir ~/.config/alacritty

sudo pacman -S meson ninja sassc unzip thunar-archive-plugin python-pip man xfce4-pulseaudio-plugin gcc imagemagick rofi xclip bc xdg-utils base-devel trash-cli
#git clone https://github.com/shimmerproject/Greybird.git
#cd Greybird
#meson --prefix=$HOME/.local builddir
#cd builddir
#ninja
#ninja install
#ln -sf ~/.local/share/themes ~/.themes # Required for GTK2
#cd ../..
#rm -rf Greybird

cp ~/Programs/configure/gtkGreybird.css ~/.local/share/themes/Greybird-dark/gtk-3.0/gtk.css

#	cp -r Programs ~/

cp ~/Programs/configure/home/.bashrc ~/.bashrc
cp ~/Programs/configure/home/.inputrc ~/.inputrc


cp ~/Programs/configure/home/.config/systemd/user/files.service ~/.config/systemd/user/files.service
cp ~/Programs/configure/home/.config/systemd/user/files.timer ~/.config/systemd/user/files.timer
cp ~/Programs/configure/home/.config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
cp ~/Programs/configure/home/.config/btop/btop.conf ~/.config/btop/btop.conf
cp ~/Programs/configure/home/.config/Code\ -\ OSS/User/settings.json ~/.config/Code\ -\ OSS/User/settings.json
#cp ~/Programs/configure/home/.config/gtk-3.0/bookmarks ~/.config/gtk-3.0/bookmarks
cp ~/Programs/configure/home/.config/gtk-3.0/gtk.css ~/.config/gtk-3.0/gtk.css
cp ~/Programs/configure/home/.config/htop/htoprc ~/.config/htop/htoprc
cp ~/Programs/configure/home/.config/mpv/mpv.conf ~/.config/mpv/mpv.conf
cp ~/Programs/configure/home/.config/neofetch/config.conf ~/.config/neofetch/config.conf
cp ~/Programs/configure/home/.config/qalculate/qalc.cfg ~/.config/qalculate/qalc.cfg
cp ~/Programs/configure/home/.config/rofi/config.rasi ~/.config/rofi/config.rasi
cp ~/Programs/configure/home/.config/songrec/preferences.toml ~/.config/songrec/preferences.toml
cp ~/Programs/configure/home/.config/youtube-viewer/youtube-viewer.conf ~/.config/youtube-viewer/youtube-viewer.conf
cp ~/Programs/configure/home/.config/youtube-viewer/api.json ~/.config/youtube-viewer/api.json

cp ~/Programs/configure/home/.local/share/gtksourceview-3.0/styles/railscasts.xml ~/.local/share/gtksourceview-3.0/styles/railscasts.xml
cp ~/Programs/configure/home/.local/share/gtksourceview-4/styles/railscasts.xml ~/.local/share/gtksourceview-4/styles/railscasts.xml
cp ~/Programs/configure/home/.local/share/rofi/themes/harris.rasi ~/.local/share/rofi/themes/harris.rasi


systemctl --user enable files.service
systemctl --user start files.service

systemctl --user enable files.timer
systemctl --user start files.timer


sudo fc-cache -fv

pip3 install pandas requests

xfconf-query -c thunar -np '/last-location-bar' -t 'string' -s 'ThunarLocationButtons'

gsettings set org.xfce.mousepad.preferences.file add-last-end-of-line true
gsettings set org.xfce.mousepad.preferences.view auto-indent true
gsettings set org.xfce.mousepad.preferences.view show-line-numbers true
gsettings set org.xfce.mousepad.preferences.view word-wrap true
gsettings set org.xfce.mousepad.preferences.view match-braces true
gsettings set org.xfce.mousepad.preferences.view smart-home-end 'before'
gsettings set org.xfce.mousepad.preferences.window cycle-tabs true
gsettings set org.xfce.mousepad.preferences.window 
gsettings set org.xfce.mousepad.preferences.view color-scheme 'Railscasts'
gsettings set org.xfce.mousepad.preferences.view tab-width uint32 4


#echo '(gtk_accel_path "<Actions>/win.edit.convert.tabs-to-spaces" "")' >> ~/.config/Mousepad/accels.scm	
echo '(gtk_accel_path "<Actions>/app.preferences.view.show-whitespace" "<Primary><Alt>w")' >> ~/.config/Mousepad/accels.scm	
#echo '(gtk_accel_path "<Actions>/win.file.new-window" "<Primary><Shift>n")' >> ~/.config/Mousepad/accels.scm	
#echo '(gtk_accel_path "<Actions>/win.document.previous-tab" "<Primary>Page_Up")' >> ~/.config/Mousepad/accels.scm	
echo '(gtk_accel_path "<Actions>/win.document.next-tab" "<Primary>Tab")' >> ~/.config/Mousepad/accels.scm	
#echo '(gtk_accel_path "<Actions>/app.preferences.window.cycle-tabs" "<Primary>y")' >> ~/.config/Mousepad/accels.scm	
#echo '(gtk_accel_path "<Actions>/win.file.detach-tab" "<Primary><Shift>d")' >> ~/.config/Mousepad/accels.scm	
#echo '(gtk_accel_path "<Actions>/win.file.close-tab" "<Primary>w")' >> ~/.config/Mousepad/accels.scm	
#echo '(gtk_accel_path "<Actions>/win.reset-font-size" "<Primary>0")' >> ~/.config/Mousepad/accels.scm	
#echo '(gtk_accel_path "<Actions>/win.file.new" "<Primary>n")' >> ~/.config/Mousepad/accels.scm	
#echo '(gtk_accel_path "<Actions>/app.preferences.view.show-whitespace.leading" "")' >> ~/.config/Mousepad/accels.scm	
echo '(gtk_accel_path "<Actions>/win.edit.convert.to-lowercase" "<Primary><Alt>l")' >> ~/.config/Mousepad/accels.scm	
echo '(gtk_accel_path "<Actions>/win.edit.convert.to-title-case" "<Primary><Alt>t")' >> ~/.config/Mousepad/accels.scm	
echo '(gtk_accel_path "<Actions>/win.edit.convert.to-uppercase" "<Primary><Alt>c")' >> ~/.config/Mousepad/accels.scm	
echo '(gtk_accel_path "<Actions>/win.edit.convert.to-opposite-case" "<Primary><Alt>f")' >> ~/.config/Mousepad/accels.scm	
#echo '(gtk_accel_path "<Actions>/win.edit.paste-special.paste-from-history" "")' >> ~/.config/Mousepad/accels.scm	
#echo '(gtk_accel_path "<Actions>/app.quit" "<Primary>q")' >> ~/.config/Mousepad/accels.scm	
#echo '(gtk_accel_path "<Actions>/win.edit.increase-indent" "<Primary>i")' >> ~/.config/Mousepad/accels.scm	
#echo '(gtk_accel_path "<Actions>/win.edit.decrease-indent" "<Primary>u")' >> ~/.config/Mousepad/accels.scm	
echo '(gtk_accel_path "<Actions>/win.edit.delete-line" "<Primary>k")' >> ~/.config/Mousepad/accels.scm	
echo '(gtk_accel_path "<Actions>/app.preferences.view.show-whitespace.trailing" "")' >> ~/.config/Mousepad/accels.scm	
echo '(gtk_accel_path "<Actions>/win.file.reload" "")' >> ~/.config/Mousepad/accels.scm	
#echo '(gtk_accel_path "<Actions>/win.edit.move.word-left" "<Alt>Left")' >> ~/.config/Mousepad/accels.scm	
#echo '(gtk_accel_path "<Actions>/win.edit.move.word-right" "<Alt>Right")' >> ~/.config/Mousepad/accels.scm	
#echo '(gtk_accel_path "<Actions>/win.edit.move.line-down" "<Alt>Down")' >> ~/.config/Mousepad/accels.scm
#echo '(gtk_accel_path "<Actions>/win.edit.move.line-up" "<Alt>Up")' >> ~/.config/Mousepad/accels.scm
#echo '(gtk_accel_path "<Actions>/win.edit.convert.transpose" "<Primary>t")' >> ~/.config/Mousepad/accels.scm
#echo '(gtk_accel_path "<Actions>/win.edit.paste-special.paste-as-column" "")' >> ~/.config/Mousepad/accels.scm	
echo '(gtk_accel_path "<Actions>/win.increase-font-size" "<Primary>equal")' >> ~/.config/Mousepad/accels.scm	
#echo '(gtk_accel_path "<Actions>/win.decrease-font-size" "<Primary>minus")' >> ~/.config/Mousepad/accels.scm	
#echo '(gtk_accel_path "<Actions>/app.preferences.view.word-wrap" "")' >> ~/.config/Mousepad/accels.scm	
echo '(gtk_accel_path "<Actions>/win.preferences.window.statusbar-visible" "<Primary><Alt>s")' >> ~/.config/Mousepad/accels.scm	



gcc ~/Programs/system/soundboard/soundboard.c -o ~/Programs/system/soundboard/soundboard -lncurses


#xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom" -r -R
#xfconf-query -c xfce4-keyboard-shortcuts -p "/xfwm4/custom" -r -R

xfconf-query -c xfce4-keyboard-shortcuts -np '/commands/custom/<Alt>F1' -t 'string' -s '$HOME/Programs/system/rofi/rofiLauncher.sh'
xfconf-query -c xfce4-keyboard-shortcuts -np '/commands/custom/<Primary><Alt>Delete' -t 'string' -s 'xfce4-session-logout'
xfconf-query -c xfce4-keyboard-shortcuts -np '/commands/custom/<Shift><Super>Return' -t 'string' -s 'xfce4-terminal'
xfconf-query -c xfce4-keyboard-shortcuts -np '/commands/custom/<Super>a' -t 'string' -s '$HOME/Programs/system/rofi/rofiCommands.sh'
xfconf-query -c xfce4-keyboard-shortcuts -np '/commands/custom/<Super>b' -t 'string' -s 'alacritty -e btop'
xfconf-query -c xfce4-keyboard-shortcuts -np '/commands/custom/<Super>c' -t 'string' -s 'alacritty -e qalc'
xfconf-query -c xfce4-keyboard-shortcuts -np '/commands/custom/<Super>e' -t 'string' -s 'thunar'
xfconf-query -c xfce4-keyboard-shortcuts -np '/commands/custom/<Super>f' -t 'string' -s 'rofi  -show find -modi find:~/Programs/system/rofi/finder.sh'
xfconf-query -c xfce4-keyboard-shortcuts -np '/commands/custom/<Super>grave' -t 'string' -s 'xfce4-screenshooter'
xfconf-query -c xfce4-keyboard-shortcuts -np '/commands/custom/<Super>h' -t 'string' -s 'alacritty -e htop'
xfconf-query -c xfce4-keyboard-shortcuts -np '/commands/custom/<Super>m' -t 'string' -s 'mousepad'
xfconf-query -c xfce4-keyboard-shortcuts -np '/commands/custom/<Super>q' -t 'string' -s '$HOME/Programs/system/rofi/rofiKeyboard.sh'
xfconf-query -c xfce4-keyboard-shortcuts -np '/commands/custom/<Super>Return' -t 'string' -s 'exo-open --launch TerminalEmulator'
xfconf-query -c xfce4-keyboard-shortcuts -np '/commands/custom/<Super>s' -t 'string' -s 'xfce4-settings-manager'
xfconf-query -c xfce4-keyboard-shortcuts -np '/commands/custom/<Super>t' -t 'string' -s 'firefox twitter.com'
xfconf-query -c xfce4-keyboard-shortcuts -np '/commands/custom/<Super>v' -t 'string' -s '$HOME/Programs/system/rofi/rofiBookmarks.sh'
xfconf-query -c xfce4-keyboard-shortcuts -np '/commands/custom/<Super>w' -t 'string' -s 'exo-open --launch WebBrowser'
xfconf-query -c xfce4-keyboard-shortcuts -np '/commands/custom/<Super>x' -t 'string' -s '$HOME/Programs/system/rofi/rofiCharacters.sh'
xfconf-query -c xfce4-keyboard-shortcuts -np '/commands/custom/<Super>j' -t 'string' -s '$HOME/Programs/system/keyboardOther/checkingStuff.sh'


xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Alt>Delete' -t 'string' -s 'del_workspace_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Alt>Insert' -t 'string' -s 'add_workspace_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Alt><Shift>Tab' -t 'string' -s 'cycle_reverse_windows_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Primary><Super>comma' -t 'string' -s 'move_window_left_workspace_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Primary><Super>period' -t 'string' -s 'move_window_right_workspace_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Shift><Super>f' -t 'string' -s 'above_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Shift><Super>q' -t 'string' -s 'close_window_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Shift><Super>r' -t 'string' -s 'resize_window_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Super>Shift_R' -t 'string' -s 'maximize_window_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Super>comma' -t 'string' -s 'prev_workspace_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Super>d' -t 'string' -s 'show_desktop_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Super>Tab' -t 'string' -s 'switch_application_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Super>Up' -t 'string' -s 'tile_up_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Super>Down' -t 'string' -s 'tile_down_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Super>Right' -t 'string' -s 'tile_right_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Super>Left' -t 'string' -s 'tile_left_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Super>End' -t 'string' -s 'tile_up_right_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Super>Page_Down' -t 'string' -s 'tile_down_right_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Super>Page_Up' -t 'string' -s 'tile_up_left_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Super>Home' -t 'string' -s 'tile_down_left_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Super>period' -t 'string' -s 'next_workspace_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Alt><Super>period' -t 'string' -s 'add_workspace_key'
xfconf-query -c xfce4-keyboard-shortcuts -np '/xfwm4/custom/<Alt><Super>comma' -t 'string' -s 'del_workspace_key'

xfconf-query -c xsettings -p '/Gtk/FontName' -s 'Roboto 12'
xfconf-query -c xsettings -p '/Gtk/MonospaceFontName' -s 'Roboto Mono 13'
xfconf-query -c xsettings -p '/Net/IconThemeName' -s 'Papirus-Dark'
xfconf-query -c xsettings -p '/Net/ThemeName' -s 'Greybird-dark'

xfconf-query -c pointers -np '/MSFT000101_06CBCE44_Touchpad/ReverseScrolling' -t 'bool' -s 'true'
xfconf-query -c pointers -np '/MSFT000101_06CBCE44_Touchpad/Acceleration' -t 'double' -s '6.500000'

xfconf-query -c xfwm4 -p '/general/cycle_draw_frame' -s 'false'
xfconf-query -c xfwm4 -p '/general/cycle_hidden' -s 'true'
xfconf-query -c xfwm4 -p '/general/cycle_minimized' -s 'true'
xfconf-query -c xfwm4 -p '/general/cycle_minimum' -s 'true'
xfconf-query -c xfwm4 -p '/general/cycle_preview' -s 'true'
xfconf-query -c xfwm4 -p '/general/cycle_raise' -s 'false'
xfconf-query -c xfwm4 -p '/general/raise_with_any_button' -s 'false'
xfconf-query -c xfwm4 -p '/general/easy_click' -t 'string' -s 'Super'
xfconf-query -c xfwm4 -p '/general/title_font' -t 'string' -s 'Roboto Bold 12'

xfconf-query -c xfce4-power-manager -np '/xfce4-power-manager/blank-on-ac' -t 'int' -s '0'
xfconf-query -c xfce4-power-manager -np '/xfce4-power-manager/blank-on-battery' -t 'int' -s '0'
xfconf-query -c xfce4-power-manager -np '/xfce4-power-manager/brightness-on-battery' -t 'int' -s '9'
xfconf-query -c xfce4-power-manager -np '/xfce4-power-manager/brightness-switch' -t 'int' -s '0'
xfconf-query -c xfce4-power-manager -np '/xfce4-power-manager/brightness-switch-restore-on-exit' -t 'int' -s '1'
xfconf-query -c xfce4-power-manager -np '/xfce4-power-manager/dpms-enabled' -t 'bool' -s 'true'
xfconf-query -c xfce4-power-manager -np '/xfce4-power-manager/dpms-on-ac-off' -t 'uint' -s '0'
xfconf-query -c xfce4-power-manager -np '/xfce4-power-manager/dpms-on-ac-sleep' -t 'uint' -s '0'
xfconf-query -c xfce4-power-manager -np '/xfce4-power-manager/dpms-on-battery-off' -t 'uint' -s '0'
xfconf-query -c xfce4-power-manager -np '/xfce4-power-manager/dpms-on-battery-sleep' -t 'uint' -s '0'
xfconf-query -c xfce4-power-manager -np '/xfce4-power-manager/presentation-mode' -t 'bool' -s 'false'
xfconf-query -c xfce4-power-manager -np '/xfce4-power-manager/show-panel-label' -t 'int' -s '3'

xfconf-query -c xfce4-desktop -np '/backdrop/single-workspace-mode' -t 'bool' -s 'false'
xfconf-query -c xfce4-desktop -np '/desktop-icons/file-icons/show-filesystem' -t 'bool' -s 'false'
xfconf-query -c xfce4-desktop -np '/desktop-icons/file-icons/show-home' -t 'bool' -s 'false'
xfconf-query -c xfce4-desktop -np '/desktop-icons/file-icons/show-trash' -t 'bool' -s 'false'



xfce4-panel --add applicationsmenu
xfce4-panel --add tasklist
xfce4-panel --add separator
xfce4-panel --add pager
xfce4-panel --add separator
xfce4-panel --add genmon # destiny logo
xfce4-panel --add genmon # destiny script
xfce4-panel --add genmon # chud logo
xfce4-panel --add genmon # chud script
xfce4-panel --add genmon # nerdcubed logo
xfce4-panel --add genmon # nerdcubed script
xfce4-panel --add genmon # matn logo
xfce4-panel --add genmon # matn script
xfce4-panel --add genmon # cpu logo
xfce4-panel --add genmon # cpu usage
xfce4-panel --add genmon # temp logo
xfce4-panel --add genmon # temp
xfce4-panel --add genmon # ram logo
xfce4-panel --add genmon # raw usage
xfce4-panel --add clock
xfce4-panel --add systray
xfce4-panel --add power-manager-plugin
xfce4-panel --add notification-plugin
xfce4-panel --add pulseaudio
xfce4-panel --add clock
xfce4-panel --add clock
xfce4-panel --add clock

xfconf-query -c xfce4-panel -np '/plugins/plugin-2/grouping' -t 'bool' -s 'false'
xfconf-query -c xfce4-panel -np '/plugins/plugin-2/show-handle' -t 'bool' -s 'false'
xfconf-query -c xfce4-panel -np '/plugins/plugin-2/show-only-minimized' -t 'bool' -s 'false'

xfconf-query -c xfce4-panel -np '/plugins/plugin-3/expand' -t 'bool' -s 'true'
xfconf-query -c xfce4-panel -np '/plugins/plugin-3/style' -t 'int' -s '0'

xfconf-query -c xfce4-panel -np '/plugins/plugin-4/rows' -t 'int' -s '1'

xfconf-query -c xfce4-panel -np '/plugins/plugin-5/style' -t 'int' -s '0'

# Stream checkers

xfconf-query -c xfce4-panel -np '/plugins/plugin-6/font' -t 'string' -s 'Roboto 12'
xfconf-query -c xfce4-panel -np '/plugins/plugin-6/use-label' -t 'bool' -s 'false'
xfconf-query -c xfce4-panel -np '/plugins/plugin-6/update-period' -t 'int' -s '30000'
xfconf-query -c xfce4-panel -np '/plugins/plugin-6/command' -t 'string' -s 'echo "<img>$HOME/Programs/output/.pictures/destinyPanel.jpg</img>"'

xfconf-query -c xfce4-panel -np '/plugins/plugin-7/font' -t 'string' -s 'Roboto 16'
xfconf-query -c xfce4-panel -np '/plugins/plugin-7/use-label' -t 'bool' -s 'false'
xfconf-query -c xfce4-panel -np '/plugins/plugin-7/update-period' -t 'int' -s '30000'
xfconf-query -c xfce4-panel -np '/plugins/plugin-7/command' -t 'string' -s '$HOME/Programs/system/panel/panelDestiny.sh'

xfconf-query -c xfce4-panel -np '/plugins/plugin-8/font' -t 'string' -s 'Roboto 12'
xfconf-query -c xfce4-panel -np '/plugins/plugin-8/use-label' -t 'bool' -s 'false'
xfconf-query -c xfce4-panel -np '/plugins/plugin-8/update-period' -t 'int' -s '30000'
xfconf-query -c xfce4-panel -np '/plugins/plugin-8/command' -t 'string' -s 'echo "<img>$HOME/Programs/output/.pictures/chudlogicPanel.jpg</img>"'

xfconf-query -c xfce4-panel -np '/plugins/plugin-9/font' -t 'string' -s 'Roboto 16'
xfconf-query -c xfce4-panel -np '/plugins/plugin-9/use-label' -t 'bool' -s 'false'
xfconf-query -c xfce4-panel -np '/plugins/plugin-9/update-period' -t 'int' -s '30000'
xfconf-query -c xfce4-panel -np '/plugins/plugin-9/command' -t 'string' -s '$HOME/Programs/system/panel/panelChudLogic.sh'

xfconf-query -c xfce4-panel -np '/plugins/plugin-10/font' -t 'string' -s 'Roboto 12'
xfconf-query -c xfce4-panel -np '/plugins/plugin-10/use-label' -t 'bool' -s 'false'
xfconf-query -c xfce4-panel -np '/plugins/plugin-10/update-period' -t 'int' -s '30000'
xfconf-query -c xfce4-panel -np '/plugins/plugin-10/command' -t 'string' -s 'echo "<img>$HOME/Programs/output/.pictures/nerdcubedPanel.jpg</img>"'

xfconf-query -c xfce4-panel -np '/plugins/plugin-11/font' -t 'string' -s 'Roboto 16'
xfconf-query -c xfce4-panel -np '/plugins/plugin-11/use-label' -t 'bool' -s 'false'
xfconf-query -c xfce4-panel -np '/plugins/plugin-11/update-period' -t 'int' -s '30000'
xfconf-query -c xfce4-panel -np '/plugins/plugin-11/command' -t 'string' -s '$HOME/Programs/system/panel/panelNerdCubed.sh'

xfconf-query -c xfce4-panel -np '/plugins/plugin-12/font' -t 'string' -s 'Roboto 12'
xfconf-query -c xfce4-panel -np '/plugins/plugin-12/use-label' -t 'bool' -s 'false'
xfconf-query -c xfce4-panel -np '/plugins/plugin-12/update-period' -t 'int' -s '30000'
xfconf-query -c xfce4-panel -np '/plugins/plugin-12/command' -t 'string' -s 'echo "<img>$HOME/Programs/output/.pictures/matnPanel.jpg</img>"'

xfconf-query -c xfce4-panel -np '/plugins/plugin-13/font' -t 'string' -s 'Roboto 16'
xfconf-query -c xfce4-panel -np '/plugins/plugin-13/use-label' -t 'bool' -s 'false'
xfconf-query -c xfce4-panel -np '/plugins/plugin-13/update-period' -t 'int' -s '30000'
xfconf-query -c xfce4-panel -np '/plugins/plugin-13/command' -t 'string' -s '$HOME/Programs/system/panel/panelMATN.sh'


# System Monitors

xfconf-query -c xfce4-panel -np '/plugins/plugin-14/font' -t 'string' -s 'Roboto 16'
xfconf-query -c xfce4-panel -np '/plugins/plugin-14/use-label' -t 'bool' -s 'false'
xfconf-query -c xfce4-panel -np '/plugins/plugin-14/update-period' -t 'int' -s '30000'
xfconf-query -c xfce4-panel -np '/plugins/plugin-14/command' -t 'string' -s echo\ \"\<txt\>\<span\ foreground=\'#6d9cbe\'\>\ \ \</span\>\</txt\>\"

xfconf-query -c xfce4-panel -np '/plugins/plugin-15/font' -t 'string' -s 'Roboto Mono Medium 15'
xfconf-query -c xfce4-panel -np '/plugins/plugin-15/use-label' -t 'bool' -s 'false'
xfconf-query -c xfce4-panel -np '/plugins/plugin-15/update-period' -t 'int' -s '2000'
xfconf-query -c xfce4-panel -np '/plugins/plugin-15/command' -t 'string' -s '$HOME/Programs/system/panel/cpu.py'

xfconf-query -c xfce4-panel -np '/plugins/plugin-16/font' -t 'string' -s 'Roboto 16'
xfconf-query -c xfce4-panel -np '/plugins/plugin-16/use-label' -t 'bool' -s 'false'
xfconf-query -c xfce4-panel -np '/plugins/plugin-16/update-period' -t 'int' -s '30000'
xfconf-query -c xfce4-panel -np '/plugins/plugin-16/command' -t 'string' -s echo\ \"\<txt\>\<span\ foreground=\'#da4939\'\>\ \ \</span\>\</txt\>\"

xfconf-query -c xfce4-panel -np '/plugins/plugin-17/font' -t 'string' -s 'Roboto Mono Medium 15'
xfconf-query -c xfce4-panel -np '/plugins/plugin-17/use-label' -t 'bool' -s 'false'
xfconf-query -c xfce4-panel -np '/plugins/plugin-17/update-period' -t 'int' -s '2000'
xfconf-query -c xfce4-panel -np '/plugins/plugin-17/command' -t 'string' -s '$HOME/Programs/system/panel/cputemp.sh'

xfconf-query -c xfce4-panel -np '/plugins/plugin-18/font' -t 'string' -s 'Roboto 16'
xfconf-query -c xfce4-panel -np '/plugins/plugin-18/use-label' -t 'bool' -s 'false'
xfconf-query -c xfce4-panel -np '/plugins/plugin-18/update-period' -t 'int' -s '30000'
xfconf-query -c xfce4-panel -np '/plugins/plugin-18/command' -t 'string' -s echo\ \"\<txt\>\<span\ foreground=\'#ffc66d\'\>\ \ \</span\>\</txt\>\"

xfconf-query -c xfce4-panel -np '/plugins/plugin-19/font' -t 'string' -s 'Roboto Mono Medium 15'
xfconf-query -c xfce4-panel -np '/plugins/plugin-19/use-label' -t 'bool' -s 'false'
xfconf-query -c xfce4-panel -np '/plugins/plugin-19/update-period' -t 'int' -s '2000'
xfconf-query -c xfce4-panel -np '/plugins/plugin-19/command' -t 'string' -s '$HOME/Programs/system/panel/ram.sh'



xfconf-query -c xfce4-panel -np '/plugins/plugin-20/digital-layout' -t 'int' -s '2'
xfconf-query -c xfce4-panel -np '/plugins/plugin-20/digital-date-format' -t 'string' -s '%a, %b %d'
xfconf-query -c xfce4-panel -np '/plugins/plugin-20/digital-date-font' -t 'string' -s 'Roboto Medium 15'
xfconf-query -c xfce4-panel -np '/plugins/plugin-20/timezone' -t 'string' -s 'Europe/London'

#xfconf-query -c xfce4-panel -np '/plugins/plugin-21/rows' -t 'int' -s '1'

#xfconf-query -c xfce4-panel -np '/plugins/plugin-22/rows' -t 'int' -s '1'

#xfconf-query -c xfce4-panel -np '/plugins/plugin-23/rows' -t 'int' -s '1'

#xfconf-query -c xfce4-panel -np '/plugins/plugin-24/rows' -t 'int' -s '1'

xfconf-query -c xfce4-panel -np '/plugins/plugin-25/digital-layout' -t 'int' -s '3'
xfconf-query -c xfce4-panel -np '/plugins/plugin-25/digital-time-format' -t 'string' -s '%H:%M |'
xfconf-query -c xfce4-panel -np '/plugins/plugin-25/digital-time-font' -t 'string' -s 'Roboto Medium 15'
xfconf-query -c xfce4-panel -np '/plugins/plugin-25/timezone' -t 'string' -s 'America/New_York'

xfconf-query -c xfce4-panel -np '/plugins/plugin-26/digital-layout' -t 'int' -s '3'
xfconf-query -c xfce4-panel -np '/plugins/plugin-26/digital-time-format' -t 'string' -s '%H:%M |'
xfconf-query -c xfce4-panel -np '/plugins/plugin-26/digital-time-font' -t 'string' -s 'Roboto Medium 15'
xfconf-query -c xfce4-panel -np '/plugins/plugin-26/timezone' -t 'string' -s 'Europe/London'

xfconf-query -c xfce4-panel -np '/plugins/plugin-27/digital-layout' -t 'int' -s '3'
xfconf-query -c xfce4-panel -np '/plugins/plugin-27/digital-time-format' -t 'string' -s '%H:%M'
xfconf-query -c xfce4-panel -np '/plugins/plugin-27/digital-time-font' -t 'string' -s 'Roboto Medium 15'
xfconf-query -c xfce4-panel -np '/plugins/plugin-27/timezone' -t 'string' -s 'Asia/Seoul'

xfconf-query -c xfce4-panel -np '/panels/panel-1/position-locked' -t 'bool' -s 'true'
xfconf-query -c xfce4-panel -np '/panels/panel-1/size' -t 'uint' -s '36'

xfconf-query -c xfwm4 -np '/general/workspace_count' -t 'int' -s '2'
