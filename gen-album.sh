#!/bin/bash

FOLDER=$1
ALBUM_NAME=$2
DESCRIPTION=$3
DATE=$4

if [ -z "$FOLDER" ] || [ -z "$ALBUM_NAME" ]; then
  echo "Usage: ./generate-album.sh <folder> <album-name> [description] [date]"
  echo "Example: ./generate-album.sh clouds sunset-series \"Beautiful sunset photos\" \"2024-12-17\""
  exit 1
fi

ALBUM_DIR="$FOLDER/$ALBUM_NAME"
MD_FILE="$FOLDER/$ALBUM_NAME.md"

if [ ! -d "$ALBUM_DIR" ]; then
  echo "Error: Directory $ALBUM_DIR not found"
  echo "Please create the directory and add images first"
  exit 1
fi

shopt -s nullglob
IMAGES=("$ALBUM_DIR"/*.{jpg,jpeg,png,gif,webp,JPG,JPEG,PNG,GIF,WEBP})

if [ ${#IMAGES[@]} -eq 0 ]; then
  echo "Error: No images found in $ALBUM_DIR"
  exit 1
fi

TITLE=$(echo "$ALBUM_NAME" | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')

ALBUM_DATE=${DATE:-$(date +%Y-%m-%d)}

BASE_URL="https://raw.githubusercontent.com/packjackisback/packjack.dev-content/main"

cat > "$MD_FILE" << EOF
---
title: $TITLE
date: $ALBUM_DATE
cover: $BASE_URL/$FOLDER/$ALBUM_NAME/$(basename "${IMAGES[0]}")
images:
EOF

for img in "${IMAGES[@]}"; do
  echo "  - $BASE_URL/$FOLDER/$ALBUM_NAME/$(basename "$img")" >> "$MD_FILE"
done

cat >> "$MD_FILE" << EOF
---

${DESCRIPTION:-}
EOF
