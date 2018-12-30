#!/bin/bash
echo "fase 1: esporto pin Gpio"
echo "26" > /sys/class/gpio/export
sleep 2
echo "fase 2: setto come output"
echo "out" > /sys/class/gpio/gpio26/direction
sleep 2
echo "fase 3: invio valore"
echo "0" > /sys/class/gpio/gpio26/value
