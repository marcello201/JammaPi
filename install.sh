#!/bin/bash
########################################################
## Vincenzo Bini 20/09/2018
## Versione 0.6.1
#########################################################

cd ~
sudo apt-get update
sudo apt-get install -y git libjpeg-dev
git clone https://github.com/vince87/JammaPi.git
cd ~/JammaPi
git reset --hard origin/master
git pull
chmod +x install.sh

##install jammapi overlay
	cd ~/JammaPi
	printf "\033[1;31m Installo overlay JammaPi \033[0m\n"
	sudo rm /boot/overlays/vga666-6.dtbo
	sudo cp vga666-6.dtbo /boot/overlays/vga666-6.dtbo
	sudo rm /boot/dt-blob.bin
	sudo cp dt-blob.bin /boot/dt-blob.bin
	amixer cset numid=3 "1"
	sleep 2

  ##Modify Config.txt to Default
	printf "\033[1;31m Modifico il config.txt per la JammaPi \033[0m\n"
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

##install jammapi led driver
	printf "\033[1;31m Installo led \033[0m\n"
	sudo grep 'dtoverlay=pi3-act-led,gpio=27' /boot/config.txt > /dev/null 2>&1
	if [ $? -eq 0 ] ; then
	echo "Config.txt già modificato!"
	else
	sudo sh -c "echo 'dtoverlay=pi3-act-led,gpio=27' >> /boot/config.txt"
	sudo sh -c "echo 'gpio=26=op,dl' >> /boot/config.txt"
	echo "Modulo impostato!"
	fi
	sleep 2

	
	printf "\033[1;31m Installo driver Joystick \033[0m\n"
	cd ~/JammaPi/joypi/
	make
	sudo make install
	sudo insmod joypi.ko
	sudo grep 'i2c-dev' /etc/modules > /dev/null 2>&1
	if [ $? -eq 0 ] ; then
	sudo perl -p -i -e 's/mk_arcade_joystick_rpi/jpypi/g' /etc/modules
	echo "Già modificato!"
	else
	sudo sh -c "echo 'i2c-dev' >> /etc/modules"
	sudo sed -i -e "s/^exit 0/modprobe joypi \&\n&/g" /etc/rc.local
	echo "Modulo impostato!"
	fi
	
	sleep 2
	
##install jammapi switch script
	sudo grep '/home/pi/JammaPi/jammapi.sh' /etc/rc.local > /dev/null 2>&1
	if [ $? -eq 0 ] ; then
	echo "Script già installato!"
	else
	sudo sed -i -e "s/^exit 0/\/home\/pi\/JammaPi\/jammapi.sh \&\n&/g" /etc/rc.local
	chmod +x /home/pi/JammaPi/jammapi.sh
	echo "Script impostato!"
	fi

	
	
##install jammapi menu script
	printf "\033[1;31m Installo menu x RetroPie \033[0m\n"
	rm -R ~/RetroPie/retropiemenu/JammaPi
	cd ~/JammaPi/
	cp -r ~/JammaPi/RetroPie/retropiemenu/JammaPi ~/RetroPie/retropiemenu/JammaPi
	sleep 2
  
  ##Add Emulationstation basic themes...
	printf "\033[1;31m Installo temi Emulationstation \033[0m\n"
	cd ~/JammaPi
	git clone https://github.com/PietDAmore/240p-Theme.git
	cd 240p-Theme/
 	sudo cp -r "240p Bubblegum"/ /etc/emulationstation/themes/
	sudo cp -r "240p Honey"/ /etc/emulationstation/themes/
	cd 240p-overlays-v1/
	sudo cp -r * /opt/retropie/emulators/retroarch/overlays/
	cd ~/JammaPi
	git clone https://github.com/ehettervik/es-theme-pixel-metadata.git
	sudo cp -r es-theme-pixel-metadata/ /etc/emulationstation/themes/
	cd ~/JammaPi
	git clone https://github.com/anthonycaccese/es-theme-crt.git
	sudo cp -r es-theme-crt/ /etc/emulationstation/themes/
	
	
	sleep 2

		cd ~/JammaPi/pixel_script
  ##install framebuffer viewer for center screen script
		printf "\033[1;31m installo framebuffer viewer fbv \033[0m\n"
		cd fbv-master
		sh ./configure
		make
		sudo make install
		sudo chmod a+x  /usr/local/bin/fbv
		sleep 2

  ##install retropie resolution switch
		printf "\033[1;31m installo script risoluzioni 15khz... \033[0m\n"
		cd ~/JammaPi/pixel_script
		cp runcommand-onend.sh /opt/retropie/configs/all/runcommand-onend.sh
		cp runcommand-onstart.sh /opt/retropie/configs/all/runcommand-onstart.sh
		chmod +x /opt/retropie/configs/all/*.sh
		chown -R pi ~/JammaPi/pixel_script/center_screen_script
		chgrp -R pi ~/JammaPi/pixel_script/center_screen_script
		chmod +x ~/JammaPi/pixel_script/center_screen_script/*.sh
		sleep 2
    #echo "Now use the center screen scripts for finetuning your screen."
    
    		printf "\033[0;32m !!!INSTALLAZIONE COMPLETATA!!! \033[0m\n"
		printf "\033[0;32m     !!!RIAVVIO IN CORSO!!! \033[0m\n"
  		sleep 5
		
sudo reboot				
