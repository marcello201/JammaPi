vcgencmd hdmi_timings 320 1 16 30 34 240 1 2 3 22 0 0 0 60 0 6400000 1 > /dev/null
tvservice -e "DMT 87" > /dev/null
fbset -depth 8 && fbset -depth 16 -xres 320 -yres 240 > /dev/null
if [ "$1" = "daphne" ]
then
sudo killall >> /dev/shm/runcommand.log 2>&1 xboxdrv
sudo /opt/retropie/supplementary/xboxdrv/bin/xboxdrv >> /dev/shm/runcommand.log 2>&1 \
       --evdev /dev/input/event0 \
       --silent \
       --detach-kernel-driver \
       --force-feedback \
       --deadzone-trigger 15% \
       --deadzone 4000 \
       --device-name "JammaPi Player 1" \
       --evdev-absmap ABS_X=dpad_x,ABS_Y=dpad_y \
       --evdev-keymap BTN_SOUTH=a,BTN_EAST=b,BTN_SELECT=x,BTN_START=y,BTN_TL2=back,BTN_Z=start \
       --dpad-only \
       --ui-axismap lt=void,rt=void,lb=void,rb=void \
       --ui-buttonmap tl=void,tr=void,lb=void,rb=void,guide=void \
       --ui-buttonmap b=KEY_LEFTALT,a=KEY_LEFTCTRL,y=KEY_UNKNOWN,x=KEY_SPACE,du=KEY_UP,dd=KEY_DOWN,dl=KEY_LEFT,dr=KEY_RIGHT,start=KEY_1,back=KEY_5 \
	   --ui-buttonmap start+a=KEY_ESC \
&
fi	
