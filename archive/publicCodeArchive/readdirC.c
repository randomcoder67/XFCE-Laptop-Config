#include <stdio.h>
#include <dirent.h>

int main() {
	DIR *d;
	struct dirent *dir;
	d = opendir("/home/ethan/Music/curPlaylist/");
	if (d) {
		while ((dir = readdir(d)) != NULL) {
			printf("%s\n", dir->d_name);
		}
		closedir(d);
	}
	return 0;
}
