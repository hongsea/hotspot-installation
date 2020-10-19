#!/bin/bash

sshpass -p "123" rsync -av /run/media/hongsea/Linux/project/hotspot-installation pi@10.42.0.2:/home/pi/

# sshpass -p "123" ssh admin@192.168.1.54 "/home/admin/deploy-khadas.sh"
