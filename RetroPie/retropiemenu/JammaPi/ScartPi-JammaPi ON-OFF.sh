#!/bin/bash
sudo grep '#dtoverlay=vga666-6' /boot/config.txt > /dev/null 2>&1
if [ $? -eq 0 ] ; then

echo "Il driver Video non è attivo!"
sleep 4
echo "Attivo il driver Video!"

sudo perl -p -i -e 's/#dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/g' /boot/config.txt
sudo perl -p -i -e 's/#disable_audio_dither=1/disable_audio_dither=1/g' /boot/config.txt
sudo perl -p -i -e 's/#audio_pwm_mode=2/audio_pwm_mode=2/g' /boot/config.txt
sudo perl -p -i -e 's/#dtoverlay=vga666-6/dtoverlay=vga666-6/g' /boot/config.txt
sudo perl -p -i -e 's/#enable_dpi_lcd=1/enable_dpi_lcd=1/g' /boot/config.txt
sudo perl -p -i -e 's/#display_default_lcd=1/display_default_lcd=1/g' /boot/config.txt
sudo perl -p -i -e 's/#dpi_output_format=6/dpi_output_format=6/g' /boot/config.txt
sudo perl -p -i -e 's/#dpi_group=2/dpi_group=2/g' /boot/config.txt
sudo perl -p -i -e 's/#dpi_mode=87/dpi_mode=87/g' /boot/config.txt
sudo perl -p -i -e 's/#dpi_mode=9/dpi_mode=9/g' /boot/config.txt
sudo perl -p -i -e 's/#hdmi_timings=/hdmi_timings=/g' /boot/config.txt
sudo perl -p -i -e 's/gpio=26=op,dh/gpio=26=op,dl/g' /boot/config.txt
mv /opt/retropie/configs/all/runcommand-onend.sh.off /opt/retropie/configs/all/runcommand-onend.sh
mv /opt/retropie/configs/all/runcommand-onstart.sh.off /opt/retropie/configs/all/runcommand-onstart.sh
else

echo "Il driver video è attivo!"
sleep 4
echo "Disattivo il driver video!"

sudo perl -p -i -e 's/dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/#dtoverlay=pwm-2chan,pin=18,func=2,pin2=19,func2=2/g' /boot/config.txt
sudo perl -p -i -e 's/disable_audio_dither=1/#disable_audio_dither=1/g' /boot/config.txt
sudo perl -p -i -e 's/audio_pwm_mode=2/#audio_pwm_mode=2/g' /boot/config.txt
sudo perl -p -i -e 's/dtoverlay=vga666-6/#dtoverlay=vga666-6/g' /boot/config.txt
sudo perl -p -i -e 's/enable_dpi_lcd=1/#enable_dpi_lcd=1/g' /boot/config.txt
sudo perl -p -i -e 's/display_default_lcd=1/#display_default_lcd=1/g' /boot/config.txt
sudo perl -p -i -e 's/dpi_output_format=6/#dpi_output_format=6/g' /boot/config.txt
sudo perl -p -i -e 's/dpi_group=2/#dpi_group=2/g' /boot/config.txt
sudo perl -p -i -e 's/dpi_mode=87/#dpi_mode=87/g' /boot/config.txt
sudo perl -p -i -e 's/dpi_mode=9/#dpi_mode=9/g' /boot/config.txt
sudo perl -p -i -e 's/hdmi_timings=/#hdmi_timings=/g' /boot/config.txt
sudo perl -p -i -e 's/gpio=26=op,dl/gpio=26=op,dh/g' /boot/config.txt
mv /opt/retropie/configs/all/runcommand-onend.sh /opt/retropie/configs/all/runcommand-onend.sh.off
mv /opt/retropie/configs/all/runcommand-onstart.sh /opt/retropie/configs/all/runcommand-onstart.sh.off
fi

echo "Modifiche effettuate!"
echo "Le impostazioni verranno attivate al prossimo riavvio!"
sleep 5
