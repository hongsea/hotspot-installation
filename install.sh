#!/bin/bash

##This script run for install Wi-Fi hotspot.
##It management by Hongsea Heng.

##run as root
check_root(){
    if [[ $(id -u) != 0 ]]; then
        echo "This script run as root."
        exit;
    fi
}
check_root

#check wire and wireless adapter
WIRE=$(ls /sys/class/net/ | grep eth | awk 'NR==1')
WIRELESS=$(ls /sys/class/net/ | grep wl | awk 'NR==1')

##static-ip-config.sh input
echo -e "You are have interfaces wan and lan!"
read -p "Do you config wan interface as dhcp client[Y/n]: " YN

if [[ ${YN} == y || ${YN} == Y || -z ${YN} ]]; then
    echo "You are choose wan interface as dhcp client...!"
else
    echo "You are choose wan interface as static ip address...!"
    echo "Please input wlan IP"
    echo "[${WIRE}]: is WAN Interface"
    read -p "IP Address[]: " WANIP
    read -p "Netmask[]: " WANNETMASK
    read -p "Gateway[]: " WANGATEWAY    
fi

echo "Lan interface need to static ip address"
echo "Please input lan IP"
#input lan ip
echo -e "\n[${WIRELESS}]: is LAN Interface"
read -p "IP Address[]: " LANIP
read -p "Netmask[]: " LANNETMASK
read -p "Gateway[]: " LANGATEWAY 

##postgresql-config.sh input
read -p "Postgresql Username[]: " SQLUSERNAME
read -p "Postgresql Password[]: " SQLPASSWORD

##hostapd-config.sh input
read -p "SSID Name[]: " SSID

##freeradius-config.sh input
echo "Connection info sql"
read -p "Server[]: " IPSERVERRADIUS
read -p "Port[]: " PORT
read -p "Radius password[]: " RADIUSPASSWD

##bond-config.sh input
echo "Hotspot Domain"
read -p "Domain[Example: domain.com]: " DOMAIN


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

##Configure postgresql file
$(pwd)/src/postgresql-config.sh "$SQLUSERNAME" "$SQLPASSWORD"

##Configure hostapd file
$(pwd)/src/hostapd-config.sh "$SSID" "$WIRELESS"

##Configure freeradius file
$(pwd)/src/freeradius-config.sh "$IPSERVERRADIUS" "$PORT" "$SQLUSERNAME" "$SQLPASSWORD" "$RADIUSPASSWD"

##Configure chilli file
$(pwd)/src/coovachilli-config.sh "$WIRE" "$WIRELESS" "$LANIP" "$LANNETMASK" "$LANGATEWAY" "$SSID" "$RADIUSPASSWD"

##Configure bind file
$(pwd)/src/bind-config.sh "$DOMAIN" "$LANIP"