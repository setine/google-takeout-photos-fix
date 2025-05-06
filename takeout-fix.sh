#!/usr/bin/bash

# Adjust modify-date on Google Takeout of Photos.

set -e

DIR="$1"
if [ -z "$DIR" ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

echo "Rename metadata json to be consistent..."
find "$DIR" -type f -name '*.json' -print0 \
    | perl -0 -lne '@parts=split /\./; $base=join(".", @parts[0..$#parts-2]); rename $_, "$base.meta"'

echo "Updating image and video modify dates..."
# From Google metadata
exiftool -r -m \
    -d '%s' \
    -tagsFromFile '%d%f.%e.meta' \
    '-FileModifyDate<PhotoTakenTimeTimestamp' \
    -overwrite_original \
    "$DIR"
# Videos
exiftool -r -m \
    -if '$MediaModifyDate' \
    '-FileModifyDate<MediaCreateDate' \
    -overwrite_original \
    "$DIR"
# Overwrite with DateTimeOriginal if present
exiftool -r -m \
    -if '!$MediaModifyDate' \
    '-FileModifyDate<DateTimeOriginal' \
    -overwrite_original \
    "$DIR"

echo "Updating Pixel motion photo modify dates..."
exiftool -r -m \
    -ext MP \
    -d '%s' \
    -tagsFromFile '%d%f.%e.jpg.meta' \
    '-FileModifyDate<PhotoTakenTimeTimestamp' \
    -overwrite_original \
    "$DIR"

echo "Deleting json metadata..."
find "$DIR" -type f -name '*.meta' -delete
