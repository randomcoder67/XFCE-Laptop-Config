#!/usr/bin/env sh

# Script to rebuild all of my compiled programs

makeGamesUI() {
	# Make Games UI
	echo "Rebuilding Games UI (c)"
	cd ~/Programs/myRepos/mediaUI
	make
}

makeDaysProgram() {
	# Make Days Program
	echo "Rebuilding Days Program (Go)"
	go build -o ~/Programs/terminal/terminalPrograms/goBins ~/Programs/terminal/terminalPrograms/days.go
}

makeScheduleProgram() {
	# Make Schedule Program
	echo "Rebuilding Schedule Program (Go)"
	go build -o ~/Programs/terminal/terminalPrograms/goBins ~/Programs/terminal/terminalPrograms/schedule.go
}

makeLogProgram() {
	# Make Log Program
	echo "Rebuilding Log Program (Go)"
	go build -o ~/Programs/terminal/terminalPrograms/goBins ~/Programs/terminal/terminalPrograms/log.go
}

makeMoneyProgram() {
	# Make Money Program
	echo "Rebuilding Money Program (Go)"
	go build -o ~/Programs/terminal/terminalPrograms/goBins ~/Programs/terminal/terminalPrograms/money.go
}

makeTimerProgram() {
	# Make Timer Program
	echo "Rebuilding Timer Program (Go)"
	go build -o ~/Programs/terminal/terminalPrograms/goBins ~/Programs/terminal/terminalPrograms/timer.go
}

makeMetricTimeProgram() {
	# Make Metric Time Program
	echo "Rebuilding Metric Time Program (Go)"
	go build -o ~/Programs/terminal/terminalPrograms/goBins/metricTime ~/Programs/terminal/terminalPrograms/metricTime.go
}

makeDownloadTimeProgram() {
	# Make Metric Time Program
	echo "Rebuilding Download Time Program (Go)"
	go build -o ~/Programs/terminal/terminalPrograms/goBins/downloadTime ~/Programs/terminal/terminalPrograms/downloadTime.go
}

makeMetOfficeGeohashProgram() {
	# Make Metric Time Program
	echo "Rebuilding MetOffice Geohash Program (Go)"
	go build -o ~/Programs/system/rofi/metoffice-geohash ~/Programs/system/rofi/geohash.go
}

makeMdToGroffProgram() {
	# Make Metric Time Program
	echo "Rebuilding MD to Groff Program (Go)"
	cd ~/Programs/terminal/terminalPrograms/mdToGroff
	go mod tidy
	go build -o ~/Programs/terminal/terminalPrograms/goBins/groffdoc ~/Programs/terminal/terminalPrograms/mdToGroff/groff.go
}

makeNotesRendererProgram() {
	# Make Notes Renderer Program
	echo "Rebuilding Notes Renderer Program (Go)"
	cd ~/Programs/terminal/terminalPrograms/notesRenderer
	go mod tidy
	go build -o ~/Programs/terminal/terminalPrograms/goBins ~/Programs/terminal/terminalPrograms/notesRenderer/render.go
}

makeSoundboard() {
	# Make Soundboard
	echo "Rebuilding Soundboard Program (c)"
	gcc ~/Programs/system/keyboardOther/soundboard.c -lncurses -o ~/Programs/system/keyboardOther/soundboard -Wall -Wextra
}

makeGoWeatherProgram() {
	# Make Go Weather Program
	echo "Rebuilding Weather Program (Go)"
	cd ~/Programs/myRepos/goWeather
	go build -o goWeather main.go bbcWeather.go metoffice.go definitions.go web.go display.go
}

makeYouTubeProgram() {
	# Make Go Weather Program
	echo "Rebuilding YouTube Program (Go)"
	cd ~/Programs/terminal/webAlternatives
	go mod tidy
	go build -o ~/Programs/terminal/webAlternatives/youtubeSearch ~/Programs/terminal/webAlternatives/youtubeSearch.go
}

makeOtherPrograms() {
	# Rebuild Other Programs
	~/Programs/output/otherScripts/otherRemake.sh
}

if [ "$1" == "all" ]; then
	makeGamesUI
	makeDaysProgram
	makeScheduleProgram
	makeLogProgram
	makeMoneyProgram
	makeTimerProgram
	makeMetricTimeProgram
	makeMetOfficeGeohashProgram
	makeDownloadTimeProgram
	makeMdToGroffProgram
	makeNotesRendererProgram
	makeSoundboard
	makeGoWeatherProgram
	makeYouTubeProgram
	makeOtherPrograms
fi
[ "$1" == "gamesUI" ] && makeGamesUI
[ "$1" == "days" ] && makeDaysProgram
[ "$1" == "schedule" ] && makeScheduleProgram
[ "$1" == "log" ] && makeLogProgram
[ "$1" == "money" ] && makeMoneyProgram
[ "$1" == "timer" ] && makeTimerProgram
[ "$1" == "time" ] && makeMetricTimeProgram
[ "$1" == "geohash" ] && makeMetOfficeGeohashProgram
[ "$1" == "downloadt" ] && makeDownloadTimeProgram
[ "$1" == "groff" ] && makeMdToGroffProgram
[ "$1" == "render" ] && makeNotesRendererProgram
[ "$1" == "soundboard" ] && makeSoundboard
[ "$1" == "weather" ] && makeGoWeatherProgram
[ "$1" == "youtube" ] && makeYouTubeProgram
[ "$1" == "other" ] && makeOtherPrograms

