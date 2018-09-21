vcgencmd hdmi_timings 450 1 50 30 90 270 1 10 1 21 0 0 0 50 0 9600000 1 > /dev/null
tvservice -e "DMT 87" > /dev/null
fbset -depth 8 && fbset -depth 16 -xres 450 -yres 270 > /dev/null