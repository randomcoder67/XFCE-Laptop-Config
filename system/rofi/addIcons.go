package main

import (
	"fmt"
	"os"
	"strings"
)

const filesPath = "/Programs/output/updated/files.txt"

func main() {
	homeDir, _ := os.UserHomeDir()
	dat, _ := os.ReadFile(homeDir + filesPath)
	files := strings.Split(string(dat), "\n")
	
	var sb strings.Builder
	
	nullChar := string(rune(0))
	controlChar := string(rune(31))
	
	
	for _, file := range files {
		lenFile := len(file)
		if lenFile > 5 {
			locDot := strings.LastIndex(file, ".")
			var done bool = true
			if lenFile - locDot == 2 {
				switch ext := file[lenFile-2:]; ext {
				case ".c":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/text-x-csrc.svg\n")
				case ".h":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/text-x-chdr.svg\n")
				default:
					done = false
				}
			} else if lenFile - locDot == 3 {
				switch ext := file[lenFile-3:]; ext {
				case ".sh":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/application-x-shellscript.svg\n")
				case ".py":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/text-x-python.svg\n")
				case ".rs":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/text-x-rust.svg\n")
				case ".po":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/application-x-gettext-translation.svg\n")
				case ".Po":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/application-x-gettext-translation.svg\n")
				case ".go":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/text-x-go.svg\n")
				case ".md":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/text-markdown.svg\n")
				default:
					done = false
				}
			} else if lenFile - locDot == 4 {
				switch ext := file[lenFile-4:]; ext {
				case ".txt":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/text-plain.svg\n")
				case ".xml":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/application-xml.svg\n")
				case ".lua":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/text-x-lua.svg\n")
				case ".csv":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/text-csv.svg\n")
				case ".css":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/text-css.svg\n")
				case ".mp3":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/audio-mp3.svg\n")
				case ".m4a":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/audio-m4a.svg\n")
				case ".gpx":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/application-gpx.svg\n")
				case ".yml":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/application-x-yaml.svg\n")
				case ".png":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/image.svg\n")
				case ".jpg":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/image.svg\n")
				case ".gif":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/image.svg\n")
				case ".svg":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/image.svg\n")
				case ".mp4":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/video.svg\n")
				case ".m4v":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/video.svg\n")
				case ".mkv":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/video.svg\n")
				default:
					done = false
				}
			} else if lenFile - locDot == 5 {
				switch ext := file[lenFile-5:]; ext {
				case ".html":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/text-html.svg\n")
				case ".json":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/application-json.svg\n")
				case ".yaml":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/application-x-yaml.svg\n")
				case ".jpeg":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/text-x-csrc.svg\n")
				case ".webp":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/image.svg\n")
				case ".webm":
					sb.WriteString(file)
					sb.WriteString(nullChar)
					sb.WriteString("icon")
					sb.WriteString(controlChar)
					sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/video.svg\n")
				default:
					done = false
				}
			} else {
				done = false
			}
			if !done {
				sb.WriteString(file)
				sb.WriteString(nullChar)
				sb.WriteString("icon")
				sb.WriteString(controlChar)
				sb.WriteString("/usr/share/icons/Papirus-Dark/32x32/mimetypes/text-plain.svg\n")
			}
		}
	}
	fmt.Println(strings.TrimSuffix(sb.String(), "\n"))
}
