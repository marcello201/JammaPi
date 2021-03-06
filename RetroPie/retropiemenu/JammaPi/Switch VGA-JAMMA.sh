#!/bin/bash
sudo grep 'dpi_mode=87' /boot/config.txt > /dev/null 2>&1
if [ $? -eq 0 ] ; then
echo "Il driver Video è impostato su JAMMA!"
sleep 4
echo "Conversione a VGA 31Khz"

sudo perl -p -i -e 's/dpi_mode=87/dpi_mode=9/g' /boot/config.txt
sudo perl -p -i -e 's/hdmi_timings=/#hdmi_timings=/g' /boot/config.txt
mv /opt/retropie/configs/all/runcommand-onend.sh /opt/retropie/configs/all/runcommand-onend.sh.off
mv /opt/retropie/configs/all/runcommand-onstart.sh /opt/retropie/configs/all/runcommand-onstart.sh.off

else

echo "Il driver Video è impostato su VGA!"
sleep 4
echo "Conversione a JAMMA 15Khz"

sudo perl -p -i -e 's/dpi_mode=9/dpi_mode=87/g' /boot/config.txt
sudo perl -p -i -e 's/#hdmi_timings=/hdmi_timings=/g' /boot/config.txt
mv /opt/retropie/configs/all/runcommand-onend.sh.off /opt/retropie/configs/all/runcommand-onend.sh
mv /opt/retropie/configs/all/runcommand-onstart.sh.off /opt/retropie/configs/all/runcommand-onstart.sh

fi

echo "Modifiche effettuate!"
echo "Le impostazioni verranno attivate al prossimo riavvio!"
sleep 5
