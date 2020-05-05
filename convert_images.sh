#! /usr/bin/env bash
# Converts images in images folder from png to pdf
# pdf is required for xelated-based PDF output, png is used in HTML

IMGPATH=images
cd $IMGPATH
IMGS=$(/bin/ls -1 *png)

for png in $IMGS; do
  pdfimg=$(echo $png | sed -e 's/png/pdf/g')
  echo "Converting $png to $pdfimg"
  convert $png $pdfimg &
done
