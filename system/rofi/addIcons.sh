#sed -n -e '/[.]sh$/s/^/#/' ~/Programs/output/updated/files.txt > files2.txt

#sed -n 's/\(.*[.]sh\)/echo -en \"\1thing/p' ~/Programs/output/updated/files.txt

# .sh
sed -n 's/\(.*[.]sh$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/mimetypes\/application-x-shellscript.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .json
sed -n 's/\(.*[.]json$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/mimetypes\/application-json.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .c
sed -n 's/\(.*[.]c$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/mimetypes\/text-x-csrc.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .h
sed -n 's/\(.*[.]h$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/mimetypes\/text-x-chdr.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .txt
sed -n 's/\(.*[.]txt$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/mimetypes\/text-plain.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .xml
sed -n 's/\(.*[.]xml$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/mimetypes\/application-xml.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .py
sed -n 's/\(.*[.]py$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/mimetypes\/text-x-python.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .md
sed -n 's/\(.*[.]md$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/mimetypes\/text-markdown.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .csv
sed -n 's/\(.*[.]csv$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/mimetypes\/text-csv.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .html
sed -n 's/\(.*[.]html$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/mimetypes\/text-html.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .css
sed -n 's/\(.*[.]css$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/mimetypes\/text-css.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .mp3
sed -n 's/\(.*[.]mp3$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/mimetypes\/audio-mp3.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .m4a
sed -n 's/\(.*[.]m4a$\)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/mimetypes\/audio-m4a.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .png, .jpg, .jpeg, .gif, .svg and .webp
sed -n -E 's/(.*[.]png$|.*[.]jpg$|.*[.]jpeg$|.*[.]gif$|.*[.]svg$|.*[.]webp$)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/mimetypes\/image.svg\\n\"/p' ~/Programs/output/updated/files.txt

# .mp4, .m4v, .mkv, .webm
sed -n -E 's/(.*[.]mp4$|.*[.]m4v$|.*[.]mkv$|.*[.]webm$)/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/mimetypes\/video.svg\\n\"/p' ~/Programs/output/updated/files.txt

# Everything Else
grep -vP "[.]sh$|[.]json$|[.]c$|[.]h$|[.]txt$|[.]xml$|[.]py$|[.]md$|[.]csv$|[.]mp4$|[.]mkv$|[.]m4v$|[.]webm$|[.]png$|[.]jpg$|[.]jpeg$|[.]gif$|[.]svg$|[.]webp$|[.]m4a$|[.]mp3$|[.]html$" ~/Programs/output/updated/files.txt | sed 's/^/echo -en \"/; s/$/\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/mimetypes\/text-plain.svg\\n\"/'

#sed -n 's/\(.*[.]jpg$\)/BEFORE\1AFTER/p'

#\0icon\x1f/usr/share/icons/Papirus/32x32/places/folder.svg\n"
