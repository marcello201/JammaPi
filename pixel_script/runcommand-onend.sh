vcgencmd hdmi_timings 480 1 14 45 56 300 1 10 5 5 0 0 0 60 0 9600000 1 > /dev/null
tvservice -e "DMT 87" > /dev/null
fbset -depth 8 && fbset -depth 16 -xres 450 -yres 270 > /dev/nul
