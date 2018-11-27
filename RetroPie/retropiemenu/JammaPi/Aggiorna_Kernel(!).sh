#!/bin/bash

if [ ! -f /usr/bin/rpi-source ]; then
    echo "Preparo il sistema base!"
    sudo apt-get update
    sudo apt-get install -y bc libncurses5-dev rpi-update
    sudo wget https://raw.githubusercontent.com/notro/rpi-source/master/rpi-source -O /usr/bin/rpi-source && sudo chmod +x /usr/bin/rpi-source && /usr/bin/rpi-source -q --tag-update
fi
if [ ! -f /kernel-up ]; then
sudo rpi-update
sudo touch /kernel-up
sudo reboot
else
sudo rpi-source
fi

