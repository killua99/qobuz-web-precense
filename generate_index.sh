#!/bin/bash

JS_FILE="$1"
OUTPUT_DIR="."
OUTPUT_JSON="$OUTPUT_DIR/index.json"
OUTPUT_GZ="$OUTPUT_DIR/index.json.gz"

if [ ! -f "$JS_FILE" ]; then
  echo "Error: El archivo $JS_FILE no existe."
  exit 1
fi

ID=$(grep -oP "id:\s*\"\K[^\"]+" "$JS_FILE")
DOMAIN=$(grep -oP "domain:\s*\"\K[^\"]+" "$JS_FILE")
TITLE=$(grep -oP "title:\s*\"\K[^\"]+" "$JS_FILE")
VERSION=$(grep -oP "version:\s*\"\K[^\"]+" "$JS_FILE")
DESCRIPTION=$(grep -oP "description:\s*\"\K[^\"]+" "$JS_FILE")
CATEGORY=$(grep -oP "category:\s*\"\K[^\"]+" "$JS_FILE")
AUTHORS=$(grep -oP "authors:\s*\"\K[^\"]+" "$JS_FILE")
AUTHORS_LINKS=$(grep -oP "authorsLinks:\s*\"\K[^\"]+" "$JS_FILE")
URL_PATTERNS=$(grep -oP "urlPatterns:\s*\[[^\]]+\]" "$JS_FILE" | sed 's/urlPatterns:\s*//')
TAGS=$(grep -oP "tags:\s*\[[^\]]+\]" "$JS_FILE" | sed 's/tags:\s*//')

cat > "$OUTPUT_JSON" <<EOF
{
  "id": "$ID",
  "domain": "$DOMAIN",
  "title": "$TITLE",
  "version": "$VERSION",
  "description": "$DESCRIPTION",
  "category": "$CATEGORY",
  "authors": "$AUTHORS",
  "authorsLinks": "$AUTHORS_LINKS",
  "urlPatterns": $URL_PATTERNS,
  "tags": $TAGS
}
EOF

gzip -c "$OUTPUT_JSON" > "$OUTPUT_GZ"

rm "$OUTPUT_JSON"
