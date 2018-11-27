#!/bin/bash

if [ ! -f /usr/bin/rpi-source ]; then
    echo "Preparo il sistema base!"
    sudo apt-get install bc libncurses5-dev
fi
