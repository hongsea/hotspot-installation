#!/bin/bash

##This script run for install Wi-Fi hotspot.
##It management by Hongsea Heng.

rfkill unblock all

##run as root
check_root(){
    if [[ $(id -u) != 0 ]]; then
        echo "This script run as root."
        exit;
    fi
}
check_root

##freeradius-config.sh input
echo "Connection info sql"
read -p "Server[]: " IPSERVERRADIUS
read -p "Port[]: " PORT
read -p "Database Name: " DATABASE
read -p "SQLUsername: " SQLUSERNAME
read -p "SQLPassword: " SQLPASSWORD
read -p "Radius password[]: " RADIUSPASSWD

##Configure Locatime zone file
$(pwd)/src/localtime-config.sh

##Package Install file
$(pwd)/src/package-install.sh

##Configure freeradius file
$(pwd)/src/freeradius-config.sh "$IPSERVERRADIUS" "$PORT" "$SQLUSERNAME" "$SQLPASSWORD" "$RADIUSPASSWD" "$DATABASE"

