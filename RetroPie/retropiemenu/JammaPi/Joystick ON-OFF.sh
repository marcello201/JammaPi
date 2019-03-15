#!/bin/bash
sudo grep '#modprobe' /etc/rc.local > /dev/null 2>&1
if [ $? -eq 0 ] ; then

echo "Il driver joystick JammaPi non è attivo!"
sleep 4
echo "Attivo il driver joystick JammaPi!"

sudo perl -p -i -e 's/#modprobe/modprobe/g' /etc/rc.local
sudo modprobe joypi

else

echo "Il driver joystick JammaPi è attivo!"
sleep 4
echo "Disattivo il driver joystick JammaPi!"

sudo perl -p -i -e 's/modprobe/#modprobe/g' /etc/rc.local
sudo modprobe -rf joypi

fi
echo "Modifiche effettuate!"

sleep 5
