#!/usr/bin/bash

# Adjust modify-date on Google Takeout of Photos.

set -e

DIR="$1"
if [ -z "$DIR" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

echo "Deleting json metadata..."
find "$DIR" -type f -name '*.json' -delete

echo "Updating image and video modify dates..."
exiftool -r '-FileModifyDate<${filename; s/.*?(20\d{2})(\d{2})(\d{2}).*/$1-$2-$3 00:00:0/}' '-FileModifyDate<CreateDate' '-FileModifyDate<DateTimeOriginal' "$DIR"

echo "Updating Pixel motion photo modify dates..."
exiftool -r -ext MP '-FileModifyDate<${filename; s/.*?(20\d{2})(\d{2})(\d{2}).*/$1-$2-$3 00:00:0/}' '-FileModifyDate<CreateDate' '-FileModifyDate<DateTimeOriginal' "$DIR"
