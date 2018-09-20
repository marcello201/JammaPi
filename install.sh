#!/bin/sh
########################################################
## Vincenzo Bini 20/09/2018
## Versione 0.5
#########################################################

if [ "$(whoami)" != "root" ]; then
	echo "Sorry, you are not root."
	exit 1
fi

echo -n "Vuoi installare il driver JammaPi/ScartPi? "
read q1

if echo "$q1" | grep -iq "^y" ;then
	echo -n "Do you want to install additional useful files? (not recommended)"
	read q2
  
	cd ~
##download JammaPi.zip
	printf "\033[1;31m Installing JammaPi \033[0m\n"
	wget https://www.jammapi.it/arcadeitalia/jammapi.zip
	unzip -o jammapi.zip
	rm jammapi.zip
	
##install jammapi overlay
	printf "\033[1;31m Install JammaPi Overlay \033[0m\n"
	rm /boot/overlays/vga666-6.dtbo
	mv vga666-6.dtbo /boot/overlays/vga666-6.dtbo
	rm /boot/dt-blob.bin
	mv dt-blob.bin /boot/dt-blob.bin

##install jammapi joystick driver
	printf "\033[1;31m Install Joystick \033[0m\n"
	cd mk_arcade_joystick/
	mkdir /usr/src/mk_arcade_joystick_rpi-0.1.5/
	cp -a * /usr/src/mk_arcade_joystick_rpi-0.1.5/
	cd ~
	rm -R mk_arcade_joystick/
	dkms build -m mk_arcade_joystick_rpi -v 0.1.5
	dkms install -m mk_arcade_joystick_rpi -v 0.1.5
	modprobe mk_arcade_joystick_rpi i2c0=0x20,0x21
	mv /etc/modules /etc/modules.bak
	mv modules /etc/
	rm /etc/modprobe.d/mk_arcade_joystick.conf
	echo "options mk_arcade_joystick_rpi i2c0=0x20,0x21" >> mk_arcade_joystick.conf
	mv mk_arcade_joystick.conf /etc/modprobe.d/
  
  ##Modify Config.txt to Default
	printf "\033[1;31m Modify Config.txt to JammaPi Default \033[0m\n"
	cd ~
	mv /boot/config.txt /boot/config.txt.bak
	mv config.txt /boot/config.txt
  
  ##Add Emulationstation basic themes...
		printf "\033[1;31m Install Emulationstation basic themes \033[0m\n"
		apt-get install -y git
		cd ~
		git clone https://github.com/PietDAmore/240p-Theme.git
		cd 240p-Theme/
 		cp -r "240p Bubblegum"/ /etc/emulationstation/themes/
		cp -r "240p Honey"/ /etc/emulationstation/themes/
		cd 240p-overlays-v1/
		cp -r * /opt/retropie/emulators/retroarch/overlays/
		cd ~
		rm -R 240p-Theme/
		git clone https://github.com/ehettervik/es-theme-pixel-metadata.git
		cp -r es-theme-pixel-metadata/ /etc/emulationstation/themes/
		rm -R es-theme-pixel-metadata/
fi

##Clean runcommand script
	#rm /opt/retropie/configs/all/runcommand-onend.sh
	#rm /opt/retropie/configs/all/runcommand-onstart.sh

	if echo "$q2" | grep -iq "^y" ;then
		cd ~
		wget https://www.jammapi.it/arcadeitalia/script_pixel.zip
		unzip -o script_pixel.zip
		rm script_pixel.zip
##install framebuffer viewer for center screen script
		printf "\033[1;31m installing framebuffer viewer fbv \033[0m\n"
		cd fbv-master
		sh ./configure
		make
		make install
		chmod a+x  /usr/local/bin/fbv
		cd ..
		rm -R fbv-master

##install retropie resolution switch
		printf "\033[1;31m installing retropie 15khz... \033[0m\n"
		mv runcommand-onend.sh /opt/retropie/configs/all
		mv runcommand-onstart.sh /opt/retropie/configs/all
		chown -R pi /opt/retropie/configs/all/
		chgrp -R pi /opt/retropie/configs/all/
		chmod +x /opt/retropie/configs/all/*.sh
		mv center_screen_script/ /home/pi/center_screen_script/
		chown -R pi /home/pi/center_screen_script
		chgrp -R pi /home/pi/center_screen_script
		chmod +x /home/pi/center_screen_script/*.sh
    #echo "Now use the center screen scripts for finetuning your screen."
	fi
  
#reboot
fi				
