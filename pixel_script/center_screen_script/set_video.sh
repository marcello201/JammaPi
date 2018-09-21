# *************************************
# Video timings generator script
# Version 2.0 Frank Skilton - 19th April 2017
# Version 3.0 Jochen Zurborg 04.03.2018
# added integration in 
# /opt/retropie/configs/all/
# *************************************

CURRENT_VERSION=2.0

# User definable values
TEST_IMAGE="align.png"
SAFE_TIMINGS="320 1 20 20 44 240 1 6 7 10 0 0 0 60 0 6400000 1"
SAVE_FILE="timings_save.txt"
LOAD_FILE="timings_load.txt"
SAVE_RES_320_FILE="/opt/retropie/configs/all/timing_320.txt"
BOOT_CONFIG="/boot/config.txt"

# Stuff to output to boot/config.txt ($BOOT_CONFIG)
NEW_LINE=""
LINE1="dtparam=audio=on"
LINE2="gpu_mem_256=128"
LINE3="gpu_mem_512=256"
LINE4="gpu_mem_1024=256"
LINE5="gpu_mem_320"
LINE6="overscan_scale=1"
LINE7="dtparam=i2c_vc=on"
LINE8="dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2"
LINE9="dtoverlay=vga666-6"
LINE10="enable_dpi_lcd=1"
LINE11="display_default_lcd=1"
LINE12="dpi_output_format=6"
LINE13="dpi_group=2"
LINE14="dpi_mode=87"
LINE15="hdmi_timings=450 1 50 30 90 270 1 10 1 21 0 0 0 50 0 9600000 1"
LINE16="framebuffer_width=360"
LINE17="framebuffer_heightframebuffer_height=260"
LINE18="pi2jamma=no"
LINE19="# set to no to display vertical games on horizontal screen"
LINE20="pi2scart_tate_mode=no"
LINE21="# set to no to keep your own settings"
LINE22="pi2scart_overwrite_rom_cfg=yes"
LINE23="# uncomment or set to arcade for arcade crt or crt with geometry settings"
LINE24="pi2scart_crt_profile=arcade"


# Generate hdmi_timings | Main menu / loop
generate_timings ()
{
	# Only generate timings / menu where necessary
	# @1 generates timings and displays menu
	# @2 does not generate timings and displays menu
	# @3 generates timings and does not display menu
	# @ not declared does not generate timings or menu
	if [ $@ ]; then
		if [ $@ != "2" ]; then
			vcgencmd hdmi_timings $h_active_pixels 1 $h_front_porch $h_sync_pulse $h_back_porch $v_active_lines 1 $v_front_porch $v_sync_pulse $v_back_porch 0 0 0 $frame_rate 0 $pixel_freq 1
			tvservice -e "DMT 87"
			fbset -depth 8 && fbset -depth 16 -xres $h_active_pixels -yres $v_active_lines
		fi
			if [ $@ != "3" ]; then
				echo ""
				echo "-Use ARROW keys to position screen"
				echo "-Press Q to toggle test image"
				echo "-Press I to input timings"
				echo "-Press L to load timings from" $LOAD_FILE
				echo "-Press B to load timings from" $BOOT_CONFIG
				echo "-Press S to save timings to " $SAVE_FILE
				echo "-Press 1 to save timings to " $SAVE_RES_320_FILE
                                echo "-Press C to save timings to " $BOOT_CONFIG
				echo "-Press D to display current timings"
				echo "-Press F to calculate frequencies"
				echo "-Press SPACE or ENTER to reset timings"
				echo "-Press M to display this menu"
				echo "-Press X to exit to shell"
			fi
	fi

	# Detect cursor/arrow keys
	while true
 	do
	read -r -sn1 input

 	case $input in
 
	A) move_up ;;		# up arrow pressed
 	B) move_down ;;		# down arrow pressed
	C) move_right ;;	# right arrow pressed
 	D) move_left ;;		# left arrow pressed

	esac

	if [ "$input" == "q" ]; then
		clear; fbv $TEST_IMAGE; generate_timings 2
	elif [ "$input" == "i" ]; then
		clear; input_timings
	elif [ "$input" == "l" ]; then
		load_timings
	elif [ "$input" == "b" ]; then
		load_boot_config 1
	elif [ "$input" == "s" ]; then
		save_timings
	elif [ "$input" == "1" ]; then
		save_1_timings
	elif [ "$input" == "c" ]; then
		save_boot_config
	elif [ "$input" == "d" ]; then
		display_timings 2
	elif [ "$input" == "f" ]; then
		calculate_frequencies 2
	elif [ "$input" == "" ]; then
		reset_timings
	elif [ "$input" == "m" ]; then
		clear; generate_timings 2
	elif [ "$input" == "x" ]; then
		clear; exit
	else 
		generate_timings
	fi

	done
}

# Obtain hdmi_timings values from user and store as variables
input_timings ()
{
	echo "(Safe/example timings in brackets)"; echo ""

	read -p "-Enter horiozontal resolution (320): " h_active_pixels
	read -p "-Enter horiozontal front porch (22): " h_front_porch
	read -p "-Enter horiozontal sync pulse (20): " h_sync_pulse
	read -p "-Enter horiozontal back porch (42): " h_back_porch

	read -p "-Enter vertical resolution (240): " v_active_lines
	read -p "-Enter vertical front porch (8): " v_front_porch
	read -p "-Enter vertical sync pulse (7): " v_sync_pulse
	read -p "-Enter vertical back porch (8): " v_back_porch

	read -p "-Enter vertical refresh rate (60): " frame_rate
	read -p "-Enter pixel clock frequency (6400000): " pixel_freq

	TOTAL_HORIZONTAL_LINES=$[$h_active_pixels + $h_front_porch + $h_sync_pulse + $h_back_porch]
	TOTAL_VERTICAL_LINES=$[$v_active_lines + $v_front_porch + $v_sync_pulse + $v_back_porch]

	echo "";
	# Calculate horizontal and vertical frequencies and round down to 2 decimal places
	echo -n "Horizontal scan rate (kHz) = "; awk 'BEGIN { value = sprintf ("%.2f", '"$pixel_freq / $TOTAL_HORIZONTAL_LINES / 1000"' ); print value}'

	echo -n "Vertical refresh rate (Hz) = "; awk 'BEGIN { value = sprintf ("%.2f", '"$pixel_freq / $TOTAL_HORIZONTAL_LINES / $TOTAL_VERTICAL_LINES"' ); print value}'

	confirm_input 1
}

confirm_input ()
{
	if [ $@ ]; then
		echo ""
		echo "-You have entered:" $h_active_pixels 1 $h_front_porch $h_sync_pulse $h_back_porch $v_active_lines 1 $v_front_porch $v_sync_pulse $v_back_porch 0 0 0 $frame_rate 0 $pixel_freq 1 
		echo "-Is this correct (Y/N)?"
	fi

	read -sn1 correct

	if [ "$correct" == "y" ]; then
		clear; generate_timings 1
	elif [ "$correct" == "n" ]; then
		clear; input_timings
	else 
		confirm_input 
	fi
}

# Load hdmi_timings from $LOAD_FILE
load_timings ()
{
	# File exists, load the timings
	if [ -f $LOAD_FILE ]; then
		# Grab hdmi_timings string from $LOAD_FILE
		LOAD_VALUES=$( cat $LOAD_FILE | grep -m1 hdmi_timings )
		# Remove the '=' sign from the string
		LOAD_VALUES=$( echo $LOAD_VALUES | cut -d "=" -f2 )

		# Split the string into individual values
		h_active_pixels=$( echo $LOAD_VALUES | cut -d " " -f1 )
		h_front_porch=$( echo $LOAD_VALUES | cut -d " " -f3 )
		h_sync_pulse=$( echo $LOAD_VALUES | cut -d " " -f4 )
		h_back_porch=$( echo $LOAD_VALUES | cut -d " " -f5 )
		v_active_lines=$( echo $LOAD_VALUES | cut -d " " -f6 )
		v_front_porch=$( echo $LOAD_VALUES | cut -d " " -f8 )
		v_sync_pulse=$( echo $LOAD_VALUES | cut -d " " -f9 )
		v_back_porch=$( echo $LOAD_VALUES | cut -d " " -f10 )
		frame_rate=$( echo $LOAD_VALUES | cut -d " " -f14 )
		pixel_freq=$( echo $LOAD_VALUES | cut -d " " -f16 )

		echo ""; echo "...timings loaded from $LOAD_FILE"
		#echo "hdmi_timings="$LOAD_VALUES
		generate_timings 3

	# File doesn't exist
	# Generate the file and populate with timings
	else 
		echo ""; echo "...file not found, creating file with safe timings"
		echo "hdmi_timings="$SAFE_TIMINGS > $LOAD_FILE
		
		generate_timings
	fi
}

# Load hdmi_timings from /boot/config.txt ($BOOT_CONFIG)
load_boot_config ()
{
	# Grab hdmi_timings string from $BOOT_CONFIG
	BOOT_RES=$( cat $BOOT_CONFIG | grep -m1 hdmi_timings )
	# Remove the '=' sign from the string
	BOOT_RES=$( echo $BOOT_RES | cut -d "=" -f2 )

	# Split the string into individual values
	h_active_pixels=$( echo $BOOT_RES | cut -d " " -f1 )
	h_front_porch=$( echo $BOOT_RES | cut -d " " -f3 )
	h_sync_pulse=$( echo $BOOT_RES | cut -d " " -f4 )
	h_back_porch=$( echo $BOOT_RES | cut -d " " -f5 )
	v_active_lines=$( echo $BOOT_RES | cut -d " " -f6 )
	v_front_porch=$( echo $BOOT_RES | cut -d " " -f8 )
	v_sync_pulse=$( echo $BOOT_RES | cut -d " " -f9 )
	v_back_porch=$( echo $BOOT_RES | cut -d " " -f10 )
	frame_rate=$( echo $BOOT_RES | cut -d " " -f14 )
	pixel_freq=$( echo $BOOT_RES | cut -d " " -f16 )

	if [ $@ == "1" ]; then
		echo ""; echo "...timings loaded from $BOOT_CONFIG"
		generate_timings 3
	# Below is called on first load of script & if no values are found via
	# display_timings function
	# Purpose is to store the timings variables to be used by other functions
	elif [ $@ == "2" ]; then
		echo "hdmi_timings="$BOOT_RES
		generate_timings 2
	fi	
}

# Save hdmi_timings to $SAVE_FILE
save_timings ()
{

	# This saves and parses hdmi_timings to specified $SAVE_FILE
	# Useful if you want to store multiple sets of timings
	echo "hdmi_timings="$h_active_pixels 1 $h_front_porch $h_sync_pulse $h_back_porch $v_active_lines 1 $v_front_porch $v_sync_pulse $v_back_porch 0 0 0 $frame_rate 0 $pixel_freq 1 >> $SAVE_FILE;

	# This saves and overwrites hdmi_timings to specified $LOAD_FILE
	echo "hdmi_timings="$h_active_pixels 1 $h_front_porch $h_sync_pulse $h_back_porch $v_active_lines 1 $v_front_porch $v_sync_pulse $v_back_porch 0 0 0 $frame_rate 0 $pixel_freq 1 > $LOAD_FILE;  

	echo ""; echo "...timings saved to $SAVE_FILE & $LOAD_FILE and retroarch"
	echo "hdmi_timings="$h_active_pixels 1 $h_front_porch $h_sync_pulse $h_back_porch $v_active_lines 1 $v_front_porch $v_sync_pulse $v_back_porch 0 0 0 $frame_rate 0 $pixel_freq 1
}
# Save hdmi_timings to $SAVE_RES_320_FILE
save_1_timings ()
{
        # added jzu, 03.03.2018
        # carry timings to michaels script
	# First delete the existing /opt/retropie/configs/all/timing_320.txt ($SAVE_RES_320_FILE)
	sudo rm $SAVE_RES_320_FILE
	echo "hdmi_timings "$h_active_pixels 1 $h_front_porch $h_sync_pulse $h_back_porch $v_active_lines 1 $v_front_porch $v_sync_pulse $v_back_porch 0 0 0 $frame_rate 0 $pixel_freq 1 >> $SAVE_RES_320_FILE;

	echo ""; echo "...timings saved to $SAVE_RES_320_FILE retroarch"
	echo "hdmi_timings="$h_active_pixels 1 $h_front_porch $h_sync_pulse $h_back_porch $v_active_lines 1 $v_front_porch $v_sync_pulse $v_back_porch 0 0 0 $frame_rate 0 $pixel_freq 1
}

# Save hdmi_timings to /boot/config.txt ($BOOT_CONFIG)
save_boot_config ()
{
	# First delete the existing /boot/config.txt ($BOOT_CONFIG)
	sudo rm $BOOT_CONFIG
        BOOT_CONFIG_TMP=config.txt
        rm $BOOT_CONFIG_TMP
	# Write the following values to the file
	sudo echo "# Generated from set_video.sh" >> $BOOT_CONFIG_TMP
	sudo echo $NEW_LINE >> $BOOT_CONFIG_TMP
	sudo echo $LINE1 >> $BOOT_CONFIG_TMP
	sudo echo $LINE2 >> $BOOT_CONFIG_TMP
	sudo echo $LINE3 >> $BOOT_CONFIG_TMP
	sudo echo $LINE4 >> $BOOT_CONFIG_TMP
	sudo echo $LINE5 >> $BOOT_CONFIG_TMP
	sudo echo $LINE6 >> $BOOT_CONFIG_TMP
	sudo echo $LINE7 >> $BOOT_CONFIG_TMP
	sudo echo $LINE8 >> $BOOT_CONFIG_TMP
	sudo echo $LINE9 >> $BOOT_CONFIG_TMP
	sudo echo $LINE10 >> $BOOT_CONFIG_TMP
	sudo echo $LINE11 >> $BOOT_CONFIG_TMP
	sudo echo $LINE12 >> $BOOT_CONFIG_TMP
	sudo echo $LINE13 >> $BOOT_CONFIG_TMP
	sudo echo $LINE14 >> $BOOT_CONFIG_TMP
	sudo echo $LINE15 >> $BOOT_CONFIG_TMP
	sudo echo $LINE16 >> $BOOT_CONFIG_TMP
	sudo echo $LINE17 >> $BOOT_CONFIG_TMP
	sudo echo $LINE18 >> $BOOT_CONFIG_TMP
	sudo echo $LINE19 >> $BOOT_CONFIG_TMP
	sudo echo $LINE20 >> $BOOT_CONFIG_TMP
	sudo echo $LINE21 >> $BOOT_CONFIG_TMP
	sudo echo $LINE22 >> $BOOT_CONFIG_TMP
	sudo echo $LINE23 >> $BOOT_CONFIG_TMP
	sudo echo $LINE24 >> $BOOT_CONFIG_TMP
    sudo cp $BOOT_CONFIG_TMP $BOOT_CONFIG
	echo ""; echo "...timings saved to $BOOT_CONFIG"
	echo "hdmi_timings="450 1 50 30 90 270 1 10 1 21 0 0 0 50 0 9600000 1
}

# Display currently applied hdmi_timings
display_timings ()
{
	# If we already have some values loaded into the variables, display them
	if [ $h_active_pixels ]; then
		echo ""
		echo "hdmi_timings="$h_active_pixels 1 $h_front_porch $h_sync_pulse $h_back_porch $v_active_lines 1 $v_front_porch $v_sync_pulse $v_back_porch 0 0 0 $frame_rate 0 $pixel_freq 1
		generate_timings
	# No values loaded (this shouldn't occur but handle it just in case)
	# In this case grab timings from boot/config.txt
	elif [ !$h_active_pixels ]; then
		echo ""
		echo "...Displaying timings from" $BOOT_CONFIG
		load_boot_config 2
	fi
}

calculate_frequencies ()
{
# Horizontal freq = pixel clock / HTOTAL / 1000
# Vertical freq = pixel clock / HTOTAL / VTOTAL

	# If values are loaded
	if [ $h_active_pixels ]; then
		# Calculate total horizontal and vertical lines
		TOTAL_HORIZONTAL_LINES=$[$h_active_pixels + $h_front_porch + $h_sync_pulse + $h_back_porch]
		TOTAL_VERTICAL_LINES=$[$v_active_lines + $v_front_porch + $v_sync_pulse + $v_back_porch]
		echo "";
		# Calculate horizontal and vertical frequencies and round down to 2 decimal 			# places
		echo -n "Horizontal scan rate (kHz) = "; awk 'BEGIN { value = sprintf ("%.2f", '"$pixel_freq / $TOTAL_HORIZONTAL_LINES / 1000"' ); print value}'

		echo -n "Vertical refresh rate (Hz) = "; awk 'BEGIN { value = sprintf ("%.2f", '"$pixel_freq / $TOTAL_HORIZONTAL_LINES / $TOTAL_VERTICAL_LINES"' ); print value}'
		generate_timings
	# No values loaded failsafe
	elif [ !$h_active_pixels ]; then
		echo ""; echo "...No timings loaded"
		generate_timings
	fi
}

# Reset to known working timings in the event of a blank/corrupt screen
# caused by invalid timings
reset_timings ()
{
	X=$( echo $SAFE_TIMINGS | cut -d " " -f1 )
	Y=$( echo $SAFE_TIMINGS | cut -d " " -f6 )

	# Split the string into individual values
	h_active_pixels=$( echo $SAFE_TIMINGS | cut -d " " -f1 )
	h_front_porch=$( echo $SAFE_TIMINGS | cut -d " " -f3 )
	h_sync_pulse=$( echo $SAFE_TIMINGS | cut -d " " -f4 )
	h_back_porch=$( echo $SAFE_TIMINGS | cut -d " " -f5 )
	v_active_lines=$( echo $SAFE_TIMINGS | cut -d " " -f6 )
	v_front_porch=$( echo $SAFE_TIMINGS | cut -d " " -f8 )
	v_sync_pulse=$( echo $SAFE_TIMINGS | cut -d " " -f9 )
	v_back_porch=$( echo $SAFE_TIMINGS | cut -d " " -f10 )
	frame_rate=$( echo $SAFE_TIMINGS | cut -d " " -f14 )
	pixel_freq=$( echo $SAFE_TIMINGS | cut -d " " -f16 )

	vcgencmd hdmi_timings $SAFE_TIMINGS
	tvservice -e "DMT 87"
	fbset -depth 8 && fbset -depth 16 -xres $X -yres $Y

	clear

	echo "...safe timings restored"; echo ""

	generate_timings 1
}

# Increase horizontal front porch while decreasing back porch
move_left ()
{
	((h_front_porch++))
	((h_back_porch--))

	generate_timings 3
}

# Decrease horizontal front porch while increasing back porch
move_right ()
{
	((h_front_porch--))
	((h_back_porch++))

	generate_timings 3
}

# Increase vertical front porch while decreasing back porch
move_up ()
{
	((v_front_porch++))
	((v_back_porch--))

	generate_timings 3
}

# Decrease vertical front porch while increasing back porch
move_down ()
{
	((v_front_porch--))
	((v_back_porch++))

	generate_timings 3
}

# Start of program
clear

echo "*********************"
echo "*Video timings script"
echo "*Version - $CURRENT_VERSION"
echo "*********************"

# First load in timings from boot/config.txt and store for later use
# Then jump to main loop (generate_timings)
load_boot_config 2

