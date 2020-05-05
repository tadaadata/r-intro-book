#! /usr/bin/env bash

IMGPATH=images

cd $IMGPATH

IMGS=$(/bin/ls -1 *png)

for png in $IMGS; do
  pdfimg=$(echo $png | sed -e 's/png/pdf/g')
  echo "Converting $png to $pdfimg"
  convert $png $pdfimg &
done
