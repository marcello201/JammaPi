#!/bin/bash
sudo grep '#dtparam=i2c_vc=on' /boot/config.txt > /dev/null 2>&1
if [ $? -eq 0 ] ; then

echo "Il driver joystick JammaPi non è attivo!"
sleep 4
echo "Attivo il driver joystick JammaPi!"

sudo perl -p -i -e 's/#i2c-dev/i2c-dev/g' /etc/modules
#sudo perl -p -i -e 's/#mk_arcade_joystick_rpi/mk_arcade_joystick_rpi/g' /etc/modules
sudo perl -p -i -e 's/#joypi/jpypi/g' /etc/modules

sudo perl -p -i -e 's/#dtparam=i2c_vc=on/dtparam=i2c_vc=on/g' /boot/config.txt

echo "Modifiche effettuate!"

else

echo "Il driver joystick JammaPi è attivo!"
sleep 4
echo "Disattivo il driver joystick JammaPi!"

sudo perl -p -i -e 's/i2c-dev/#i2c-dev/g' /etc/modules
#sudo perl -p -i -e 's/mk_arcade_joystick_rpi/#mk_arcade_joystick_rpi/g' /etc/modules
sudo perl -p -i -e 's/joypi/#joypi/g' /etc/modules

sudo perl -p -i -e 's/dtparam=i2c_vc=on/#dtparam=i2c_vc=on/g' /boot/config.txt

echo "Modifiche effettuate!"

fi
echo "Le impostazioni verranno attivate al prossimo riavvio!"

sleep 5
