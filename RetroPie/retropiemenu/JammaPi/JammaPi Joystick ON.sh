#!/bin/bash
sudo grep '#dtparam=i2c_vc=on' /boot/config.txt > /dev/null 2>&1
if [ $? -eq 0 ] ; then
echo "Il driver joystick JammaPi non è attivo!"
sleep 4
echo "Attivo il driver joystick JammaPi!"

sudo perl -p -i -e 's/#i2c-dev/i2c-dev/g' /etc/modules
sudo perl -p -i -e 's/#mk_arcade_joystick_rpi/mk_arcade_joystick_rpi/g' /etc/modules

sudo perl -p -i -e 's/#dtparam=i2c_vc=on/dtparam=i2c_vc=on/g' /boot/config.txt

sudo modprobe mk_arcade_joystick_rpi i2c0=0x20,0x21

echo "Modifiche effettuate!"
sleep 5
else
echo "Il driver joystick JammaPi è già attivo!"
fi




