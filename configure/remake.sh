#!/usr/bin/env sh

# Make Games UI
echo "Rebuilding Games UI (c)"
cd ~/Programs/myRepos/mediaUI
make

# Make Days Program
echo "Rebuilding Days Program (Go)"
go build -o ~/Programs/terminal/terminalPrograms/goBins ~/Programs/terminal/terminalPrograms/until.go
# Make Schedule Program
echo "Rebuilding Schedule Program (Go)"
go build -o ~/Programs/terminal/terminalPrograms/goBins ~/Programs/terminal/terminalPrograms/schedule.go
# Make Log Program
echo "Rebuilding Log Program (Go)"
go build -o ~/Programs/terminal/terminalPrograms/goBins ~/Programs/terminal/terminalPrograms/log.go
# Make Money Program
echo "Rebuilding Money Program (Go)"
go build -o ~/Programs/terminal/terminalPrograms/goBins ~/Programs/terminal/terminalPrograms/money.go
# Make Timer Program
echo "Rebuilding Timer Program (Go)"
go build -o ~/Programs/terminal/terminalPrograms/goBins ~/Programs/terminal/terminalPrograms/timer.go

# Make Soundboard
echo "Rebuilding Soundboard Program (c)"
gcc ~/Programs/system/keyboardOther/soundboard.c -lncurses -o ~/Programs/system/keyboardOther/soundboard -Wall -Wextra

# Make Go Weather Program
echo "Rebuilding Weather Program (Go)"
cd ~/Programs/myRepos/goWeather
go build -o goWeather main.go bbcWeather.go metoffice.go definitions.go web.go display.go
