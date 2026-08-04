#!/bin/bash
curl -s "https://api.iconify.design/material-symbols/footprint.svg?color=white&width=256&height=256" -o /tmp/test.svg
magick -background none -density 288 /tmp/test.svg -trim +repage -filter Lanczos -resize 30x30 -gravity center -extent 40x40 resources/drawables/icon_steps.png
