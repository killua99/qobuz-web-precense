#!/bin/bash

INPUT_DIR="."
OUTPUT_DIR="."
OUTPUT_JSON="$OUTPUT_DIR/index.json"
OUTPUT_GZ="$OUTPUT_DIR/index.json.gz"
HASH_JSON="$OUTPUT_DIR/hash.json"

if [ ! -d "$INPUT_DIR" ]; then
  echo "Error: El directorio $INPUT_DIR no existe."
  exit 1
fi

echo "[" > "$OUTPUT_JSON"

COUNT=0

for JS_FILE in "$INPUT_DIR"/*.js; do
  if [ -f "$JS_FILE" ]; then
    ID=$(grep -oP "id:\s*\"\K[^\"]+" "$JS_FILE" | head -1)
    TITLE=$(grep -oP "title:\s*\"\K[^\"]+" "$JS_FILE" | head -1)
    VERSION=$(grep -oP "version:\s*\"\K[^\"]+" "$JS_FILE" | head -1)
    DESCRIPTION=$(grep -oP "description:\s*\"\K[^\"]+" "$JS_FILE" | head -1)
    DOMAIN=$(grep -oP "domain:\s*\"\K[^\"]+" "$JS_FILE" | head -1)
    URL_PATTERNS=$(grep -oP "urlPatterns:\s*\[[^\]]+\]" "$JS_FILE" | sed 's/urlPatterns:\s*//' | head -1)
    AUTHORS=$(grep -oP "authors:\s*\"\K[^\"]+" "$JS_FILE" | head -1)
    AUTHORS_LINKS=$(grep -oP "authorsLinks:\s*\"\K[^\"]+" "$JS_FILE" | head -1)
    HOMEPAGE=$(grep -oP "homepage:\s*\"\K[^\"]+" "$JS_FILE" | head -1)
    MODE=$(grep -oP "mode:\s*\"\K[^\"]+" "$JS_FILE" | head -1)
    WATCH_AUTO_DETECT=$(grep -oP "watchAutoDetect:\s*\"\K[^\"]+" "$JS_FILE" | head -1)
    CATEGORY=$(grep -oP "category:\s*\"\K[^\"]+" "$JS_FILE" | head -1)
    TAGS=$(grep -oP "tags:\s*\[[^\]]+\]" "$JS_FILE" | sed 's/tags:\s*//' | head -1)
    FILE=$(basename "$JS_FILE")

    FILE_PATH=$(realpath --relative-to="$OUTPUT_DIR" "$JS_FILE")

    if [ $COUNT -gt 0 ]; then
      echo "," >> "$OUTPUT_JSON"
    fi

    cat >> "$OUTPUT_JSON" <<EOF
{
  "id": "$ID",
  "title": "$TITLE",
  "version": "$VERSION",
  "description": "$DESCRIPTION",
  "domain": $DOMAIN,
  "urlPatterns": $URL_PATTERNS,
  "authors": ["$AUTHORS"],
  "authorsLinks": ["$AUTHORS_LINKS"],
  "homepage": "$HOMEPAGE",
  "mode": "$MODE",
  "watchAutoDetect": "$WATCH_AUTO_DETECT",
  "category": ["$CATEGORY"],
  "tags": $TAGS,
  "file": "$FILE_PATH"
}
EOF

    COUNT=$((COUNT + 1))
  fi
done

echo "]" >> "$OUTPUT_JSON"

gzip -c "$OUTPUT_JSON" > "$OUTPUT_GZ"

HASH=$(sha256sum "$OUTPUT_GZ" | awk '{ print $1 }')

SIZE=$(stat -c %s "$OUTPUT_JSON")

GZ_SIZE=$(stat -c %s "$OUTPUT_GZ")

GENERATED_AT=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")

cat > "$HASH_JSON" <<EOF
{
  "sha256": "$HASH",
  "size": $SIZE,
  "gzSize": $GZ_SIZE,
  "count": $COUNT,
  "generatedAt": "$GENERATED_AT"
}
EOF

rm "$OUTPUT_JSON"
