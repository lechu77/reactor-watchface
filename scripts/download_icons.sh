#!/bin/bash
DIR="resources/drawables"

download_and_convert() {
    local id=$1
    local name=$2
    echo "Downloading $name ($id) at 40x40 (HQ Normalized PNG)..."
    curl -s "https://api.iconify.design/${id}.svg?color=white&width=256&height=256" -o /tmp/${name}.svg
    magick -background none -density 288 /tmp/${name}.svg -trim +repage -filter Lanczos -resize 30x30 -gravity center -extent 40x40 $DIR/${name}.png
}

# Rediseños, Tiempo y Base (Mixed Iconify Sets for better aspect ratio)
download_and_convert "ion/footsteps" "icon_steps"
download_and_convert "mdi/fire" "icon_calories"
download_and_convert "material-symbols/favorite" "icon_heartrate"
download_and_convert "material-symbols/bolt" "icon_stress"
download_and_convert "material-symbols/battery-horiz-075" "icon_battery"
download_and_convert "mdi/map-marker" "icon_distance"
download_and_convert "mdi/stairs-up" "icon_floors"
download_and_convert "material-symbols/schedule" "icon_time"
download_and_convert "material-symbols/calendar-month" "icon_date"

# Métricas de Salud y Entrenamiento
download_and_convert "material-symbols/battery-charging-full" "icon_body_battery"
download_and_convert "material-symbols/monitor-heart" "icon_hrv"
download_and_convert "material-symbols/bedtime" "icon_resting_hr"
download_and_convert "material-symbols/bloodtype" "icon_pulse_ox"
download_and_convert "material-symbols/speed" "icon_training_readiness"
download_and_convert "material-symbols/update" "icon_recovery_time"
download_and_convert "material-symbols/air" "icon_vo2_max"
download_and_convert "material-symbols/trending-up" "icon_training_status"
download_and_convert "material-symbols/fitness-center" "icon_acute_load"
download_and_convert "material-symbols/directions-run" "icon_endurance_score"
download_and_convert "material-symbols/terrain" "icon_hill_score"
download_and_convert "material-symbols/bolt" "icon_intensity_minutes"

# Sensores, Clima y Estado
download_and_convert "material-symbols/landscape" "icon_altitude"
download_and_convert "material-symbols/thermostat" "icon_temperature"
download_and_convert "material-symbols/partly-cloudy-day" "icon_weather"
download_and_convert "material-symbols/wb-twilight" "icon_sunrise"
download_and_convert "material-symbols/brightness-4" "icon_sunset"
download_and_convert "material-symbols/dark-mode" "icon_moon_phase"
download_and_convert "material-symbols/smartphone" "icon_phone_battery"
download_and_convert "material-symbols/bluetooth" "icon_bluetooth"

echo "All icons successfully downloaded and converted!"
