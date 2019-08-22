#!/bin/bash
########################################################
## Vincenzo Bini 22/08/2019
## Versione 0.1
#########################################################

  CRT=/boot/JAMMA
  VGA=/boot/VGA
  HDMI=/boot/HDMI
   
  ##Check if JammaPi script is installed
  sudo grep 'dtparam=i2c_vc=on' /boot/config.txt > /dev/null 2>&1
	if [ $? -eq 0 ] ; then
	echo "Script JammaPi installato: procedo!"
	else
	echo "Script JammaPi non installato!"
	echo "!!!!!ERRORE!!!!!"
	sleep 5
	exit
	fi
  
  ##Check if exist CRT
	printf "\033[1;31m Controllo se esiste il file CRT \033[0m\n"
    
  if test -f "$JAMMA"; then
    echo "$FILE esite!"
    sudo perl -p -i -e 's/#dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/g' /boot/config.txt
    sudo perl -p -i -e 's/#disable_audio_dither=1/disable_audio_dither=1/g' /boot/config.txt
    sudo perl -p -i -e 's/#audio_pwm_mode=2/audio_pwm_mode=2/g' /boot/config.txt
    sudo perl -p -i -e 's/#dtoverlay=vga666-6/dtoverlay=vga666-6/g' /boot/config.txt
    sudo perl -p -i -e 's/#enable_dpi_lcd=1/enable_dpi_lcd=1/g' /boot/config.txt
    sudo perl -p -i -e 's/#display_default_lcd=1/display_default_lcd=1/g' /boot/config.txt
    sudo perl -p -i -e 's/#dpi_output_format=6/dpi_output_format=6/g' /boot/config.txt
    sudo perl -p -i -e 's/#dpi_group=2/dpi_group=2/g' /boot/config.txt
    sudo perl -p -i -e 's/#dpi_mode=87/dpi_mode=87/g' /boot/config.txt
    sudo perl -p -i -e 's/#dpi_mode=9/dpi_mode=87/g' /boot/config.txt
    sudo perl -p -i -e 's/dpi_mode=9/dpi_mode=87/g' /boot/config.txt
    sudo perl -p -i -e 's/#hdmi_timings=/hdmi_timings=/g' /boot/config.txt
    mv /opt/retropie/configs/all/runcommand-onend.sh.off /opt/retropie/configs/all/runcommand-onend.sh
    mv /opt/retropie/configs/all/runcommand-onstart.sh.off /opt/retropie/configs/all/runcommand-onstart.sh
    echo "Modifiche effettuate!"
    sleep 5
  fi
   
  if test -f "$VGA"; then
    echo "$FILE esite!"
    sudo perl -p -i -e 's/#dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/g' /boot/config.txt
    sudo perl -p -i -e 's/#disable_audio_dither=1/disable_audio_dither=1/g' /boot/config.txt
    sudo perl -p -i -e 's/#audio_pwm_mode=2/audio_pwm_mode=2/g' /boot/config.txt
    sudo perl -p -i -e 's/#dtoverlay=vga666-6/dtoverlay=vga666-6/g' /boot/config.txt
    sudo perl -p -i -e 's/#enable_dpi_lcd=1/enable_dpi_lcd=1/g' /boot/config.txt
    sudo perl -p -i -e 's/#display_default_lcd=1/display_default_lcd=1/g' /boot/config.txt
    sudo perl -p -i -e 's/#dpi_output_format=6/dpi_output_format=6/g' /boot/config.txt
    sudo perl -p -i -e 's/#dpi_group=2/dpi_group=2/g' /boot/config.txt
    sudo perl -p -i -e 's/#dpi_mode=87/dpi_mode=9/g' /boot/config.txt
    sudo perl -p -i -e 's/#dpi_mode=9/dpi_mode=9/g' /boot/config.txt
    sudo perl -p -i -e 's/dpi_mode=87/dpi_mode=9/g' /boot/config.txt
    sudo perl -p -i -e 's/#hdmi_timings=/hdmi_timings=/g' /boot/config.txt
    mv /opt/retropie/configs/all/runcommand-onend.sh /opt/retropie/configs/all/runcommand-onend.sh.off
    mv /opt/retropie/configs/all/runcommand-onstart.sh /opt/retropie/configs/all/runcommand-onstart.sh.off
    echo "Modifiche effettuate!"
    sleep 5
  fi
   
  if test -f "$HDMI"; then
    echo "$FILE esite!"
    sudo perl -p -i -e 's/dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/#dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/g' /boot/config.txt
    sudo perl -p -i -e 's/disable_audio_dither=1/#disable_audio_dither=1/g' /boot/config.txt
    sudo perl -p -i -e 's/audio_pwm_mode=2/#audio_pwm_mode=2/g' /boot/config.txt
    sudo perl -p -i -e 's/dtoverlay=vga666-6/#dtoverlay=vga666-6/g' /boot/config.txt
    sudo perl -p -i -e 's/enable_dpi_lcd=1/#enable_dpi_lcd=1/g' /boot/config.txt
    sudo perl -p -i -e 's/display_default_lcd=1/#display_default_lcd=1/g' /boot/config.txt
    sudo perl -p -i -e 's/dpi_output_format=6/#dpi_output_format=6/g' /boot/config.txt
    sudo perl -p -i -e 's/dpi_group=2/#dpi_group=2/g' /boot/config.txt
    sudo perl -p -i -e 's/dpi_mode/#dpi_mode/g' /boot/config.txt
    sudo perl -p -i -e 's/hdmi_timings=/#hdmi_timings=/g' /boot/config.txt
    mv /opt/retropie/configs/all/runcommand-onend.sh /opt/retropie/configs/all/runcommand-onend.sh.off
    mv /opt/retropie/configs/all/runcommand-onstart.sh /opt/retropie/configs/all/runcommand-onstart.sh.off
    echo "Modifiche effettuate!"
    sleep 5
  fi
    
    		printf "\033[0;32m !!!SWITCH COMPLETATO!!! \033[0m\n"
		printf "\033[0;32m     !!!RIAVVIO IN CORSO!!! \033[0m\n"
  		sleep 5
		
sudo reboot
