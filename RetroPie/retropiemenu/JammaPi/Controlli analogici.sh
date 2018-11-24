#!/bin/bash
sudo grep 'input_l_x_minus_axis = "-0"' /opt/retropie/configs/all/retroarch-joypads/MCP23017 Controller.cfg > /dev/null 2>&1
if [ $? -ne 0 ] ; then
sudo sh -c "echo '#input_l_x_minus_axis = "-0"' >> /opt/retropie/configs/all/retroarch-joypads/MCP23017 Controller.cfg"
sudo sh -c "echo '#input_l_x_plus_axis = "+0"' >> /opt/retropie/configs/all/retroarch-joypads/MCP23017 Controller.cfg"
sudo sh -c "echo '#input_l_y_minus_axis = "-1"' >> /opt/retropie/configs/all/retroarch-joypads/MCP23017 Controller.cfg"
sudo sh -c "echo '#input_l_y_plus_axis = "+1"' >> /opt/retropie/configs/all/retroarch-joypads/MCP23017 Controller.cfg"
fi

sudo grep '#input_l_x_minus_axis = "-0"' /opt/retropie/configs/all/retroarch-joypads/MCP23017 Controller.cfg > /dev/null 2>&1
if [ $? -eq 0 ] ; then

echo "Conversione non attiva!"
sleep 4
echo "Attivo controlli analogici!"

sudo perl -p -i -e 's/#input_l_x_minus_axis = "-0"/input_l_x_minus_axis = "-0"/g' /opt/retropie/configs/all/retroarch-joypads/MCP23017 Controller.cfg
sudo perl -p -i -e 's/#input_l_x_plus_axis = "+0"/input_l_x_plus_axis = "+0"/g' /opt/retropie/configs/all/retroarch-joypads/MCP23017 Controller.cfg
sudo perl -p -i -e 's/#input_l_y_minus_axis = "-1"/input_l_y_minus_axis = "-1"/g' /opt/retropie/configs/all/retroarch-joypads/MCP23017 Controller.cfg
sudo perl -p -i -e 's/#input_l_y_plus_axis = "+1"/input_l_y_plus_axis = "+1"/g' /opt/retropie/configs/all/retroarch-joypads/MCP23017 Controller.cfg

echo "Modifiche effettuate!"

else

echo "Conversione attiva!"
sleep 4
echo "Disattivo controlli analogici!"

sudo perl -p -i -e 's/input_l_x_minus_axis = "-0"/#input_l_x_minus_axis = "-0"/g' /opt/retropie/configs/all/retroarch-joypads/MCP23017 Controller.cfg
sudo perl -p -i -e 's/input_l_x_plus_axis = "+0"/#input_l_x_plus_axis = "+0"/g' /opt/retropie/configs/all/retroarch-joypads/MCP23017 Controller.cfg
sudo perl -p -i -e 's/input_l_y_minus_axis = "-1"/#input_l_y_minus_axis = "-1"/g' /opt/retropie/configs/all/retroarch-joypads/MCP23017 Controller.cfg
sudo perl -p -i -e 's/input_l_y_plus_axis = "+1"/#input_l_y_plus_axis = "+1"/g' /opt/retropie/configs/all/retroarch-joypads/MCP23017 Controller.cfg

echo "Modifiche effettuate!"

fi

sleep 5
