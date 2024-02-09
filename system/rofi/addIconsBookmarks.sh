#!/usr/bin/env bash

inputFile="$HOME/Programs/output/updated/bookmarks.txt"
outputFile="$HOME/Programs/output/updated/bookmarksIcons.sh"

cat "$inputFile" | sed 's/DELIM/ DELIM/g' > "$outputFile"

# Specific website types
sed -i -E 's/(.*(map|maps|Map|Maps).*)DELIMhttp.*/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/apps\/maps.svg\\n\"/g' "$outputFile"

sed -i -E 's/(.*(reddit|Reddit).*)DELIMhttp.*/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/apps\/reddit.svg\\n\"/g' "$outputFile"

# Generic website
sed -i -E 's/(.*)DELIMhttp.*/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/apps\/firefox.svg\\n\"/g' "$outputFile"

# Programming languages
sed -i -E 's/(.*\bGo\b.*|.*\bGolang\b.*)DELIM.*/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/mimetypes\/text-x-go.svg\\n\"/g' "$outputFile"

sed -i -E 's/(.*py\b.*|.*\bpython\b.*|.*\bPython\b.*)DELIM.*/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/mimetypes\/text-x-python.svg\\n\"/g' "$outputFile"

sed -i -E 's/(.*\bsh\b.*|.*\bbash\b.*|.*\bBash\b.*)DELIM.*/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/mimetypes\/application-x-shellscript.svg\\n\"/g' "$outputFile"

# Symbols
sed -i -E 's/(.*\bsymbol\b.*|.*\bSymbol\b.*)DELIM.*/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/apps\/libreoffice-math.svg\\n\"/g' "$outputFile"

# Everything else
sed -i -E 's/(.*)DELIM.*/echo -en \"\1\\0icon\\x1f\/usr\/share\/icons\/Papirus-Dark\/32x32\/mimetypes\/text-plain.svg\\n\"/g' "$outputFile"

sed -i 's/ \\0/\\0/g' "$outputFile"

chmod +x "$outputFile"
