#!/bin/bash

##Color
RED='\033[0;31m'
GREEN='\e[32m'
YELLOW='\033[1;33m'
BLUE='\033[1;32m'
NC='\033[0m' 

localtime-config(){

./src/banner.sh "Configure Localtime Zone"

timedatectl set-timezone Asia/Phnom_Penh
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Phnom_Penh /etc/localtime

echo "${GREEN}[ OK ] Configure localtime zone.${NC}"
}

localtime-config