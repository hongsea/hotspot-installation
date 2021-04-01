#!/bin/bash

##Color
RED='\033[0;31m'
GREEN='\e[32m'
YELLOW='\033[1;33m'
BLUE='\033[1;32m'
NC='\033[0m'

##get arguments from install.sh
SSID=$1
WIRELESS=$2

##hostapd
hostapd_config(){
./src/banner.sh "Configure hostapd"

    # read -p "SSID Name[]: " SSID
    cp -r -v hostapd /etc
    if [[ "$?" == 0 ]];then
        echo -e "${GREEN}[ OK ] Copy config!${NC}"
    else
        echo -e "${RED}[ Failed ] Copy config!${NC}"
    fi
    

    grep -rli LANINTERFACE /etc/hostapd/hostapd.conf | xargs -i@ sed -i s+LANINTERFACE+${WIRELESS}+g @
    grep -rli WIFINAME /etc/hostapd/hostapd.conf | xargs -i@ sed -i s+WIFINAME+${SSID}+g @
    echo -e "${GREEN}[ OK ] Configure hostapd!${NC}"

    systemctl unmask hostapd.service
    systemctl enable hostapd.service
    systemctl start hostapd.service
    STATUS=$(systemctl is-active hostapd.service)
    echo -e "${GREEN}[ ${STATUS} ] Start service hostapd!${NC}"
    
}

hostapd_config