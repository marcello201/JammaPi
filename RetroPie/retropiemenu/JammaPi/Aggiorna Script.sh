#!/bin/bash
cd ~/JammaPi
rm *.sh
git reset --hard origin/master
git pull
chmod +x install.sh
./install.sh
