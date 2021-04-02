#!/bin/bash

##This script run for install KOOMPI Fi-Fi.
##It management by Hongsea Heng.

##Color
RED='\033[0;31m'
GREEN='\e[32m'
YELLOW='\033[1;33m'
BLUE='\033[1;32m'
NC='\033[0m'


##Enable wireless wifi
rfkill unblock all

##run as root
check_root(){
    if [[ $(id -u) != 0 ]]; then
        echo -e "${RED}This script run as root.${NC}"
        exit;
    fi
}
check_root

#check wire and wireless adapter
WIRE=$(ls /sys/class/net/ | grep eth | awk 'NR==1')
WIRELESS=$(ls /sys/class/net/ | grep wl | awk 'NR==1')

##static-ip-config.sh input
echo -e "You are have interfaces wan[$WIRE] and lan[$WIRELESS]!"
read -p "Do you config wan[$WIRE] interface as dhcp client[Y/n]: " YN

if [[ ${YN} == y || ${YN} == Y || -z ${YN} ]]; then
    echo "You are choose wan[$WIRE] interface as dhcp client...!"
else
    echo "You are choose wan[$WIRE] interface as static ip address...!"
    echo "Please input wlan IP"
    echo "[${WIRE}]: is WAN Interface"
    read -p "IP Address[]: " WANIP
    while [ -z $WANIP ]
    do
        echo -e "${RED}IP Address is required.${NC}"
        read -p "IP Address[]: " WANIP
    done

    read -p "Netmask[]: " WANNETMASK
    while [ -z $WANNETMASK ]
    do
        echo -e "${RED}Netmask is required.${NC}"
        read -p "Netmask[]: " WANNETMASK
    done

    read -p "Gateway[]: " WANGATEWAY
        while [ -z $WANGATEWAY ]
    do
        echo -e "${RED}Gateway is required.${NC}"
        read -p "Gateway[]: " WANGATEWAY
    done    
fi

echo "Lan interface need to static ip address"
echo "Please input lan IP"
#input lan ip
echo -e "\n[${WIRELESS}]: is LAN Interface"
read -p "IP Address[]: " LANIP
while [ -z $LANIP ]
do
    echo -e "${RED}IP Address is required.${NC}"
    read -p "IP Address[]: " LANIP
done

read -p "Netmask[]: " LANNETMASK
while [ -z $LANNETMASK ]
do
    echo -e "${RED}Netmask is required.${NC}"
    read -p "Netmask[]: " LANNETMASK
done

read -p "Gateway[]: " LANGATEWAY 
while [ -z $LANGATEWAY ]
do
    echo -e "${RED}Gateway is required.${NC}"
    read -p "Gateway[]: " LANGATEWAY 
done

##hostapd-config.sh input
read -p "SSID Name[]: " SSID
while [ -z $SSID ]
do
    echo -e "${RED}SSID Name is required.${NC}"
    read -p "SSID Name[]: " SSID
done

##freeradius-config.sh input
read -p "Freeradius Server[]: " RADIUSSERVER
while [ -z $RADIUSSERVER ]
do
    echo -e "${RED}Freeradius Server is required.${NC}"
    read -p "Freeradius Server[]: " RADIUSSERVER
done

read -p "Freeradius Password[]: " RADIUSPASSWD
while [ -z $RADIUSPASSWD ]
do
    echo -e "${RED}Freeradius Password is required.${NC}"
    read -p "Freeradius Password[]: " RADIUSPASSWD
done

read -p "Station ID[]: " STATIONID
while [ -z $STATIONID ]
do
    echo -e "${RED}Station ID is required.${NC}"
    read -p "Station ID[]: " STATIONID
done

##bond-config.sh input
echo "Hotspot Domain"
read -p "Domain[Example: domain.com]: " DOMAIN
while [ -z $DOMAIN ]
do
    echo -e "${RED}Domain is required.${NC}"
    read -p "Domain[Example: domain.com]: " DOMAIN
done

##Configure Locatime zone file
$(pwd)/src/localtime-config.sh

##Package Install file
$(pwd)/src/package-install.sh

##Configure Default file
$(pwd)/src/default-config.sh

##Configure ip adress
static-config(){
    $(pwd)/src/ip-config.sh "$WIRE" "$WIFINAME" "$YN" "$YN" "$WANIP" "$WANNETMASK" "$WANGATEWAY" "$LANIP" "$LANNETMASK" "$LANGATEWAY"
}

dhcp-config(){
    $(pwd)/src/ip-config.sh "$WIRE" "$WIFINAME" "$YN" "$LANIP" "$LANNETMASK" "$LANGATEWAY"
}
if [[ $YN == y || $YN == Y || -z $YN ]]; then
    dhcp-config
else
    static-config
fi

##Configure dhcp file
$(pwd)/src/dhcp-config.sh "$LANIP" "$LANNETMASK" "$LANGATEWAY" "$WIRELESS"

##Configure hostapd file
$(pwd)/src/hostapd-config.sh "$SSID" "$WIRELESS"

##Configure freeradius file
# $(pwd)/src/freeradius-config.sh "$IPSERVERRADIUS" "$PORT" "$SQLUSERNAME" "$SQLPASSWORD" "$RADIUSPASSWD"

##Configure chilli file
$(pwd)/src/coovachilli-config.sh "$WIRE" "$WIRELESS" "$LANIP" "$LANNETMASK" "$LANGATEWAY" "$SSID" "$RADIUSPASSWD" "$DOMAIN" "$RADIUSSERVER" "STATIONID"

##Configure captive portal login
$(pwd)/src/captive-portal-config.sh  "$RADIUSPASSWD" "$DOMAIN"

##Configure nginx web server
$(pwd)/src/nginx-config.sh "$DOMAIN" "$RADIUSSERVER"

##Configure systemd service
$(pwd)/src/systemd-config.sh

##Configure bind file
$(pwd)/src/bind-config.sh "$DOMAIN" "$LANIP"