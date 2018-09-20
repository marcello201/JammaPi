#!/bin/bash
sudo grep '#dtoverlay=vga666-6' /boot/config.txt > /dev/null 2>&1
if [ $? -eq 0 ] ; then
echo "Il driver JammaPi non � attivo!"
sleep 4
else
echo "Disattivo il driver JammaPi!"

sudo perl -p -i -e 's/i2c-dev/#i2c-dev/g' /etc/modules
sudo perl -p -i -e 's/mk_arcade_joystick_rpi/#mk_arcade_joystick_rpi/g' /etc/modules

sudo perl -p -i -e 's/dtparam=i2c_vc=on/#dtparam=i2c_vc=on/g' /boot/config.txt
sudo perl -p -i -e 's/dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/#dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/g' /boot/config.txt
sudo perl -p -i -e 's/dtoverlay=vga666-6/#dtoverlay=vga666-6/g' /boot/config.txt
sudo perl -p -i -e 's/enable_dpi_lcd=1/#enable_dpi_lcd=1/g' /boot/config.txt
sudo perl -p -i -e 's/display_default_lcd=1/#display_default_lcd=1/g' /boot/config.txt
sudo perl -p -i -e 's/dpi_output_format=6/#dpi_output_format=6/g' /boot/config.txt
sudo perl -p -i -e 's/dpi_group=2/#dpi_group=2/g' /boot/config.txt
sudo perl -p -i -e 's/dpi_mode=87/#dpi_mode=87/g' /boot/config.txt
sudo perl -p -i -e 's/hdmi_timings=/#hdmi_timings=/g' /boot/config.txt

echo "Modifiche effettuate! Riavvio in corso!"
sleep 5
sudo reboot
fi




