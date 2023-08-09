#include<ncurses.h>
#include<stdlib.h>
#include<unistd.h>

// Sound Board

int main(void)
{
	initscr();

	addstr("-------------------\n|   Sound Board   |\n|  Random Sounds  |\n-------------------\n\n");
	refresh();

	noecho();
	addstr("Vine Boom - v\n");
	addstr("Reveal - r\n");
	addstr("Sus - s\n");
	addstr("Troll - t\n");
	addstr("Metal Pipe - p\n");
	addstr("Bruh - b\n");
	addstr("Riff - k\n");
	addstr("Op - o\n");
	addstr("Augggghhhhh - u\n");
	addstr("Free WiFi - f\n");
	addstr("Pizza - y\n");
	addstr("What the dog doin' - w\n");
	addstr("Minecraft Death - m\n");
	addstr("Error - e\n");
	addstr("Violin - z\n");
	addstr("Gnome - i\n");
	addstr("Alarm - a\n");
	addstr("Airhorn - d\n");
	refresh();
	while(1) {
		char a = getch();
		if (a == 'v') {
			system("mpv ~/Programs/output/.sounds/vineBoom.m4a 2>/dev/null >> /dev/null & disown");
		}
		if (a == 'r') {
			system("mpv ~/Programs/output/.sounds/reveal.m4a 2>/dev/null >> /dev/null & disown");
		}
		if (a == 's') {
			system("mpv ~/Programs/output/.sounds/sus.m4a 2>/dev/null >> /dev/null & disown");
		}
		if (a == 't') {
			system("mpv ~/Programs/output/.sounds/troll.m4a 2>/dev/null >> /dev/null & disown");
		}
		if (a == 'p') {
			system("mpv ~/Programs/output/.sounds/metalPipe.m4a 2>/dev/null >> /dev/null & disown");
		}
		if (a == 'b') {
			system("mpv ~/Programs/output/.sounds/bruh.m4a 2>/dev/null >> /dev/null & disown");
		}
		if (a == 'k') {
			system("mpv ~/Programs/output/.sounds/riff.m4a 2>/dev/null >> /dev/null & disown");
		}
		if (a == 'o') {
			system("mpv ~/Programs/output/.sounds/op.m4a 2>/dev/null >> /dev/null & disown");
		}
		if (a == 'u') {
			system("mpv ~/Programs/output/.sounds/augh.m4a 2>/dev/null >> /dev/null & disown");
		}
		if (a == 'f') {
			system("mpv ~/Programs/output/.sounds/freeWiFi.m4a 2>/dev/null >> /dev/null & disown");
		}
		if (a == 'y') {
			system("mpv ~/Programs/output/.sounds/pizza.m4a 2>/dev/null >> /dev/null & disown");
		}
		if (a == 'w') {
			system("mpv ~/Programs/output/.sounds/dog.m4a 2>/dev/null >> /dev/null & disown");
		}
		if (a == 'm') {
			system("mpv ~/Programs/output/.sounds/minecraftDeath.m4a 2>/dev/null >> /dev/null & disown");
		}
		if (a == 'e') {
			system("mpv ~/Programs/output/.sounds/error.m4a 2>/dev/null >> /dev/null & disown");
		}
		if (a == 'z') {
			system("mpv ~/Programs/output/.sounds/violin.m4a 2>/dev/null >> /dev/null & disown");
		}
		if (a == 'i') {
			system("mpv ~/Programs/output/.sounds/gnome.m4a 2>/dev/null >> /dev/null & disown");
		}
		if (a == 'a') {
			system("mpv ~/Programs/output/.sounds/alarm.m4a 2>/dev/null >> /dev/null & disown");
		}
		if (a == 'd') {
			system("mpv ~/Programs/output/.sounds/airhorn.m4a 2>/dev/null >> /dev/null & disown");
		}
		if (a == 'q') {
			break;
		}
		if (a == '1') {
			system("kill $(ps aux | grep -E '[m]pv [a-zA-Z0-9/]*/Programs/output/.sounds/' | awk '{print $2}') 2>/dev/null >> /dev/null");
		}
	}
	endwin();
	return EXIT_SUCCESS;
}
