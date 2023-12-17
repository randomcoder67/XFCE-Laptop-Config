#!/usr/bin/env bash

# Adds icons to files in rofiLauncher.sh

#sed -n -e '/[.]sh$/s/^/#/' ~/Programs/output/updated/files.txt > files2.txt

#sed -n 's/\(.*[.]sh\)/echo -en \"\1thing/p' ~/Programs/output/updated/files.txt

# .sh
sed -n 's/\(.*[.]sh$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/application-x-shellscript.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .json
sed -n 's/\(.*[.]json$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/application-json.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .c
sed -n 's/\(.*[.]c$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/text-x-csrc.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .h
sed -n 's/\(.*[.]h$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/text-x-chdr.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .txt
sed -n 's/\(.*[.]txt$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/text-plain.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .xml
sed -n 's/\(.*[.]xml$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/application-xml.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .py
sed -n 's/\(.*[.]py$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/text-x-python.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .lua
sed -n 's/\(.*[.]lua$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/text-x-lua.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .go
sed -n 's/\(.*[.]go$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/text-x-go.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .md
sed -n 's/\(.*[.]md$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/text-markdown.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .csv
sed -n 's/\(.*[.]csv$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/text-csv.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .html
sed -n 's/\(.*[.]html$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/text-html.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .css
sed -n 's/\(.*[.]css$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/text-css.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .rs
sed -n 's/\(.*[.]rs$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/text-x-rust.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .mp3
sed -n 's/\(.*[.]mp3$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/audio-mp3.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .m4a
sed -n 's/\(.*[.]m4a$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/audio-m4a.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .gpx
sed -n 's/\(.*[.]gpx$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/application-gpx.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .yml, .yaml
sed -n -E 's/(.*[.]yml$|.*[.]yaml$)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/application-x-yaml.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .po, .Po
sed -n -E 's/(.*[.]po$|.*[.]Po$)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/application-x-gettext-translation.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .png, .jpg, .jpeg, .gif, .svg and .webp
sed -n -E 's/(.*[.]png$|.*[.]jpg$|.*[.]jpeg$|.*[.]gif$|.*[.]svg$|.*[.]webp$)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/image.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .mp4, .m4v, .mkv, .webm
sed -n -E 's/(.*[.]mp4$|.*[.]m4v$|.*[.]mkv$|.*[.]webm$)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/video.svg\\n\"/p' ~/Programs/output/updated/files.txt

# Everything Else
grep -vP "[.]sh$|[.]json$|[.]c$|[.]h$|[.]rs$|[.]txt$|[.]xml$|[.]py$|[.]md$|[.]csv$|[.]mp4$|[.]mkv$|[.]m4v$|[.]webm$|[.]png$|[.]jpg$|[.]jpeg$|[.]gif$|[.]svg$|[.]webp$|[.]m4a$|[.]mp3$|[.]html$|[.]lua$|[.]go$|[.]gpx$|[.]css$|[.]yml$|[.]yaml$|[.]po$|[.]Po$" ~/Programs/output/updated/files.txt | sed 's/^/echo -en \"/; s/$/\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/24x24\/mimetypes\/text-plain.svg\\n\"/'

#sed -n 's/\(.*[.]jpg$\)/BEFORE\1AFTER/p'

#\0icon\x1f/usr/share/icons/Papirus/24x24/places/folder.svg\n"
