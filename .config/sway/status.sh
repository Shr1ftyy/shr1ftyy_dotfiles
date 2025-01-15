#!/bin/bash
# The Sway configuration file in ~/.config/sway/config calls this script.
# You should see changes to the status bar after saving this script.
# If not, do "killall swaybar" and $mod+Shift+c to reload the configuration.

# The abbreviated weekday (e.g., "Sat"), followed by the ISO-formatted date
# like 2018-10-06 and the time (e.g., 14:01). Check `man date` on how to format
# time and date.
date_formatted=$(date "+%a %F %H:%M")

# NOTE: WITHOUT TIME REMAINING
# "upower --enumerate | grep 'BAT'" gets the battery name (e.g.,
# "/org/freedesktop/UPower/devices/battery_BAT0") from all power devices.
# "upower --show-info" prints battery information from which we get
# the state (such as "charging" or "fully-charged") and the battery's
# charge percentage. With awk, we cut away the column containing
# identifiers. i3 and sway convert the newline between battery state and
# the charge percentage automatically to a space, producing a result like
# "charging 59%" or "fully-charged 100%".
# battery_info=$(upower --show-info $(upower --enumerate |\
# grep 'BAT') |\
# egrep "state|percentage" |\
# awk '{print $2}')

# battery_info=$(upower --show-info $(upower --enumerate | grep 'BAT') | \
#   egrep "state|percentage" | \
#   awk '{print $2}')
# 
# battery_state=$(echo "$battery_info" | head -n 1)
# battery_percentage=$(echo "$battery_info" | tail -n 1 | tr -d '%')
# 
# # Determine emoji based on battery state and percentage
# if [[ "$battery_state" == "charging" ]]; then
#   battery_emoji="⚡"
# elif [[ "$battery_state" == "fully-charged" ]]; then
#   battery_emoji="🔋"
# elif [[ "$battery_percentage" -lt 25 ]]; then
#   battery_emoji="🪫"
# elif [[ "$battery_percentage" -lt 10 ]]; then
#   battery_emoji="⚠️"
# else
#   battery_emoji="🔋"
# fi
# 
# battery_stuff="$battery_percentage% $battery_emoji"

# Get the battery device path
battery_path=$(upower --enumerate | grep 'BAT')

# Fetch battery information
battery_info=$(upower --show-info $battery_path | egrep "state|percentage|time to empty|time to full")

# Extract battery state, percentage, and time remaining
battery_state=$(echo "$battery_info" | grep "state" | awk '{print $2}')
battery_percentage=$(echo "$battery_info" | grep "percentage" | awk '{print $2}' | tr -d '%')
time_to_empty=$(echo "$battery_info" | grep "time to empty" | awk '{print $4, $5}')
time_to_full=$(echo "$battery_info" | grep "time to full" | awk '{print $4, $5}')

# Determine emoji based on battery state and percentage
if [[ "$battery_state" == "charging" ]]; then
  battery_emoji="⚡"
  time_remaining="($time_to_full until full)"
elif [[ "$battery_state" == "fully-charged" ]]; then
  battery_emoji="🔋"
  time_remaining=""
elif [[ "$battery_percentage" -lt 20 ]]; then
  battery_emoji="🪫"
  time_remaining="($time_to_empty left)"
elif [[ "$battery_percentage" -lt 10 ]]; then
  battery_emoji="⚠️"
  time_remaining="($time_to_empty left)"
else
  battery_emoji="🔋"
  time_remaining="($time_to_empty left)"
fi

# Output the battery status with emoji and time remaining
battery_stuff="$battery_percentage% $battery_emoji $time_remaining"

audio_volume=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -q 'yes' && echo " 🔇" || \
      pactl get-sink-volume @DEFAULT_SINK@ | awk -F '/' '/Volume/ {gsub(/ /, "", $2); print $2 " 🔉"}')

brightness=$(brightnessctl get | awk -v max=$(brightnessctl max) '{printf "%.0f%% 🔆\n", ($1 / max) * 100}')

# Additional emojis and characters for the status bar:
# Electricity: ⚡ ↯ ⭍ 🔌
# Audio: 🔈 🔊 🎧 🎶 🎵 🎤
# Separators: \| ❘ ❙ ❚
# Misc: 🐧 💎 💻 💡 ⭐ 📁 ↑ ↓ ✉ ✅ ❎
echo $audio_volume $brightness \| $battery_stuff \| $date_formatted
