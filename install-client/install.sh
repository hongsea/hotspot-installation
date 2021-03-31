#!/bin/bash

##This script run for install KOOMPI Fi-Fi.
##It management by Hongsea Heng.

##Enable wireless wifi
rfkill unblock all

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
echo -e "You are have interfaces wan[$WIRE] and lan[$WIRELESS]!"
read -p "Do you config wan[$WIRE] interface as dhcp client[Y/n]: " YN

if [[ ${YN} == y || ${YN} == Y || -z ${YN} ]]; then
    echo "You are choose wan[$WIRE] interface as dhcp client...!"
else
    echo "You are choose wan[$WIRE] interface as static ip address...!"
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

##hostapd-config.sh input
read -p "SSID Name[]: " SSID

##freeradius-config.sh input
read -p "Freeradius Server[]: " RADIUSSERVER
read -p "Freeradius Password[]: " RADIUSPASSWD
read -p "Station ID[]: " STATIONID
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