#!/bin/bash
########################################################
## Vincenzo Bini 20/09/2018
## Versione 0.5
#########################################################

#if [ "$(whoami)" != "root" ]; then
 #	echo "Sorry, you are not root."
#	exit 1
#fi

#echo -n "Vuoi installare il driver JammaPi/ScartPi? s/n "
#read q1

cd ~
sudo apt-get install -y git
git clone https://github.com/vince87/JammaPi.git
cd ~/JammaPi
git pull
chmod +x install.sh

#if echo "$q1" | grep -iq "^s" ;then
#	echo -n "Vuoi installare lo script per le risoluzioni? (sconsigliato) s/n "
#	read q2
	
##install jammapi overlay
	cd ~/JammaPi
	printf "\033[1;31m Installo overlay JammaPi \033[0m\n"
	sudo rm /boot/overlays/vga666-6.dtbo
	sudo cp vga666-6.dtbo /boot/overlays/vga666-6.dtbo
	sudo rm /boot/dt-blob.bin
	sudo cp dt-blob.bin /boot/dt-blob.bin
	sleep 2

  ##Modify Config.txt to Default
	printf "\033[1;31m Modifico il config.txt per la JammaPi \033[0m\n"
	sudo grep 'dtparam=i2c_vc=on' /boot/config.txt > /dev/null 2>&1
	if [ $? -eq 0 ] ; then
	echo "Config.txt già modificato!"
	else
	sudo sh -c "echo '#dtparam=i2c_vc=on' >> /boot/config.txt"
	sudo sh -c "echo '#dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2' >> /boot/config.txt"
	sudo sh -c "echo '#dtoverlay=vga666-6' >> /boot/config.txt"
	sudo sh -c "echo '#enable_dpi_lcd=1' >> /boot/config.txt"
	sudo sh -c "echo '#display_default_lcd=1' >> /boot/config.txt"
	sudo sh -c "echo '#dpi_output_format=6' >> /boot/config.txt"
	sudo sh -c "echo '#dpi_group=2' >> /boot/config.txt"
	sudo sh -c "echo '#dpi_mode=87' >> /boot/config.txt"
	sudo sh -c "echo '#hdmi_timings=320 1 16 30 34 240 1 2 3 22 0 0 0 60 0 6400000 1' >> /boot/config.txt"
	echo "Config.txt modificato!"
	fi
	sleep 2

##install jammapi joystick driver
	printf "\033[1;31m Installo driver Joystick \033[0m\n"
	cd ~/JammaPi/mk_arcade_joystick/
	sudo mkdir /usr/src/mk_arcade_joystick_rpi-0.1.5/
	sudo cp -a * /usr/src/mk_arcade_joystick_rpi-0.1.5/
	cd ~/JammaPi
	sudo dkms build -m mk_arcade_joystick_rpi -v 0.1.5
	sudo dkms install -m mk_arcade_joystick_rpi -v 0.1.5
	sudo modprobe mk_arcade_joystick_rpi i2c0=0x20,0x21
	sudo rm /etc/modprobe.d/mk_arcade_joystick.conf
	echo "options mk_arcade_joystick_rpi i2c0=0x20,0x21" >> mk_arcade_joystick.conf
	sudo mv mk_arcade_joystick.conf /etc/modprobe.d/
	sudo grep 'i2c-dev' /etc/modules > /dev/null 2>&1
	if [ $? -eq 0 ] ; then
	echo "Già modificato!"
	else
	sudo sh -c "echo '#i2c-dev' >> /etc/modules"
	sudo sh -c "echo '#mk_arcade_joystick_rpi' >> /etc/modules"
	echo "Modulo impostato!"
	fi
	sleep 2
	
##install jammapi joystick driver
	printf "\033[1;31m Installo menu x RetroPie \033[0m\n"
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
	sleep 2

##Clean runcommand script
	rm /opt/retropie/configs/all/runcommand-onend.sh
	rm /opt/retropie/configs/all/runcommand-onstart.sh

#	if echo "$q2" | grep -iq "^y" ;then
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
#		printf "\033[1;31m installo script risoluzioni 15khz... \033[0m\n"
#		cd ~/JammaPi/pixel_script
#		cp runcommand-onend.sh /opt/retropie/configs/all/runcommand-onend.sh
#		cp runcommand-onstart.sh /opt/retropie/configs/all/runcommand-onstart.sh
#		chown -R pi /opt/retropie/configs/all/
#		chgrp -R pi /opt/retropie/configs/all/
#		chmod +x /opt/retropie/configs/all/*.sh
#		chown -R pi ~/JammaPi/pixel_script/center_screen_script
#		chgrp -R pi ~/JammaPi/pixel_script/center_screen_script
#		chmod +x ~/JammaPi/pixel_script/center_screen_script/*.sh
#		sleep 2
    #echo "Now use the center screen scripts for finetuning your screen."
  
#reboot				
