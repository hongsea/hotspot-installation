#!/bin/bash

##color
RED='\033[0;31m'
GREEN='\e[32m'
YELLOW='\033[1;33m'
BLUE='\033[1;32m'
NC='\033[0m' 

##get arguments from install.sh
WIRE=$1
WIRELESS=$2
YN=$3

if [[ ${YN} == y || ${YN} == Y || -z ${YN} ]]; then
    LANIP=$4
    LANNETMASK=$5
    LANGATEWAY=$6
else
    WANIP=$4
    WANNETMASK=$5
    WANGATEWAY=$6

    LANIP=$7
    LANNETMASK=$8
    LANGATEWAY=$9    
fi

##static ip address
ip_config(){
./src/banner.sh "Configure static ip address"

    # echo -e "You are have interfaces wan and lan!"
    # read -p "Do you config wan interface as dhcp client[Y/n]: " YN
    if [[ ${YN} == y || ${YN} == Y || -z ${YN} ]]; then

        #copy config to /etc/network
        rm -rf /etc/network/interface.d/eth0-*
        cp -r -v $(pwd)/staticIP/network/interfaces.d/eth0-wan-dhcp /etc/network/interfaces.d/
        if [[ "$?" == 0 ]]; then
            echo -e "${GREEN}[ OK ] Configure wan interface!${NC}"
        else
            echo -e "${RED}[ Failed ] Configure wan interface!${NC}"
        fi 
        
    else
        #input wan ip
        # echo "[${WIRE}]: is WAN Interface"
        # read -p "IP Address[]: " WANIP
        # read -p "Netmask[]: " WANNETMASK
        # read -p "Gateway[]: " WANGATEWAY

        #copy config to /etc/network
        rm -rf /etc/network/interface.d/eth0-*
        cp -r -v ../staticIP/network/interfaces.d/eth0-wan-static /etc/network/interfaces.d/

        #replace name in config file
        #wan interface
        grep -rli WANIP /etc/network/interfaces.d/eth0-wan-static | xargs -i@ sed -i s+WANIP+${WANIP}+g @
        grep -rli WANNETMASK /etc/network/interfaces.d/eth0-wan-static | xargs -i@ sed -i s+WANNETMASK+${WANNETMASK}+g @
        grep -rli WANGATEWAY /etc/network/interfaces.d/eth0-wan-static | xargs -i@ sed -i s+WANGATEWAY+${WANGATEWAY}+g @
        if [[ "$?" == 0 ]]; then
            echo -e "${GREEN}[ OK ] Configure wan interface!${NC}" 
        else
            echo -e "${RED}[ Failed ] Configure wan interface!${NC}"
        fi               
    fi

    #input lan ip
    # echo -e "\n[${WIRELESS}]: is LAN Interface"
    # read -p "IP Address[]: " LANIP
    # read -p "Netmask[]: " LANNETMASK
    # read -p "Gateway[]: " LANGATEWAY    

    #replace name in config file
    #lan interface
    cp -r -v $(pwd)/staticIP/network/interfaces.d/wlan0-lan /etc/network/interfaces.d/
    grep -rli LANIP /etc/network/interfaces.d/wlan0-lan | xargs -i@ sed -i s+LANIP+${LANIP}+g @
    grep -rli LANNETMASK /etc/network/interfaces.d/wlan0-lan | xargs -i@ sed -i s+LANNETMASK+${LANNETMASK}+g @
    grep -rli LANGATEWAY /etc/network/interfaces.d/wlan0-lan | xargs -i@ sed -i s+LANGATEWAY+${LANGATEWAY}+g @    
    echo -e "${GREEN}[ OK ] Configure lan interface!${NC}"

    #start service
    ifconfig wlan0 up
    ifconfig eth0 up
    systemctl restart networking
}

ip_config