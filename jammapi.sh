#!/bin/bash
########################################################
## Vincenzo Bini 22/08/2019
## Versione 0.1
#########################################################

  CRT=/boot/CRT
  VGA=/boot/VGA
  HDMI=/boot/HDMI
  ##Check if exist CRT
	printf "\033[1;31m Controllo se esiste il file CRT \033[0m\n"
    
  if test -f "$CRT"; then
    echo "$FILE esite"
    sudo grep 'dpi_mode=87' /boot/config.txt > /dev/null 2>&1
if [ $? -eq 0 ] ; then
echo "Il driver Video è impostato su JAMMA!"
sleep 4
echo "Conversione a VGA 31Khz"

sudo perl -p -i -e 's/dpi_mode=87/dpi_mode=9/g' /boot/config.txt
sudo perl -p -i -e 's/hdmi_timings=/#hdmi_timings=/g' /boot/config.txt
mv /opt/retropie/configs/all/runcommand-onend.sh /opt/retropie/configs/all/runcommand-onend.sh.off
mv /opt/retropie/configs/all/runcommand-onstart.sh /opt/retropie/configs/all/runcommand-onstart.sh.off

else

echo "Il driver Video è impostato su VGA!"
sleep 4
echo "Conversione a JAMMA 15Khz"

sudo perl -p -i -e 's/dpi_mode=9/dpi_mode=87/g' /boot/config.txt
sudo perl -p -i -e 's/#hdmi_timings=/hdmi_timings=/g' /boot/config.txt
mv /opt/retropie/configs/all/runcommand-onend.sh.off /opt/retropie/configs/all/runcommand-onend.sh
mv /opt/retropie/configs/all/runcommand-onstart.sh.off /opt/retropie/configs/all/runcommand-onstart.sh

fi

echo "Modifiche effettuate!"
echo "Le impostazioni verranno attivate al prossimo riavvio!"
sleep 5
  fi
  
  
	sudo grep 'dtparam=i2c_vc=on' /boot/config.txt > /dev/null 2>&1
	if [ $? -eq 0 ] ; then
	echo "Config.txt già modificato!"
	else
	sudo perl -p -i -e 's/#hdmi_force_hotplug/hdmi_force_hotplug/g' /boot/config.txt
	sudo sh -c "echo 'dtparam=i2c_vc=on' >> /boot/config.txt"
	sudo sh -c "echo 'audio_pwm_mode=2' >> /boot/config.txt"
	sudo sh -c "echo 'dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2' >> /boot/config.txt"
	sudo sh -c "echo 'disable_audio_dither=1' >> /boot/config.txt"
	sudo sh -c "echo 'dtoverlay=vga666-6' >> /boot/config.txt"
	sudo sh -c "echo 'enable_dpi_lcd=1' >> /boot/config.txt"
	sudo sh -c "echo 'display_default_lcd=1' >> /boot/config.txt"
	sudo sh -c "echo 'dpi_output_format=6' >> /boot/config.txt"
	sudo sh -c "echo 'dpi_group=2' >> /boot/config.txt"
	sudo sh -c "echo 'dpi_mode=87' >> /boot/config.txt"
	sudo sh -c "echo 'hdmi_timings=450 1 50 30 90 270 1 10 1 21 0 0 0 50 0 9600000 1' >> /boot/config.txt"
	echo "Config.txt modificato!"
	fi
	sleep 2

    
    		printf "\033[0;32m !!!INSTALLAZIONE COMPLETATA!!! \033[0m\n"
		printf "\033[0;32m     !!!RIAVVIO IN CORSO!!! \033[0m\n"
  		sleep 5
		
sudo reboot
