#!/bin/bash

if [ ! -f /usr/bin/rpi-source ]; then
    echo "Preparo il sistema base!"
    sudo apt-get update
    sudo apt-get install -y bc libncurses5-dev rpi-update
    sudo wget https://raw.githubusercontent.com/notro/rpi-source/master/rpi-source -O /usr/bin/rpi-source && sudo chmod +x /usr/bin/rpi-source && /usr/bin/rpi-source -q --tag-update
fi
if [ ! -f /kernel-up ]; then
printf "Primo step!"
sudo rpi-update
sudo touch /kernel-up
printf "Rilanciare lo script dopo il riavvio!"
sleep 10
sudo reboot
else
printf "Step finale!"
sudo rpi-source
printf "KERNEL AGGIORNATO!"
sudo dkms build -m mk_arcade_joystick_rpi -v 0.1.5
sudo dkms install -m mk_arcade_joystick_rpi -v 0.1.5
printf "\033[1;31m RICOMPILATO IL DRIVER JAMMAPI PER IL NUOVO KERNEL! \033[0m\n"
sudo rm /kernel-up
sleep 5
fi

