#!/bin/bash
# set -x
##This script run for install KOOMPI Fi-Fi.
##It management by Hongsea Heng.

##Color
RED='\033[0;31m'
GREEN='\e[32m'
YELLOW='\033[1;33m'
BLUE='\033[1;32m'
NC='\033[0m' 

##UNBLICK WIRELESS
rfkill unblock all

##RUN AS ROOT
check_root(){
    if [[ $(id -u) != 0 ]]; then
        echo -e "${RED}This script run as root.${NC}"
        exit;
    fi
}
check_root
# set -x

##FREERADIUS-CONFIG.SH INPUT
echo "Connect postgreSQL:"
read -p "Server[]: " IPSERVERRADIUS
while [ -z $IPSERVERRADIUS ]
do
    echo -e "${RED}Server is required${NC}"
    read -p "Server[]: " IPSERVERRADIUS
done

read -p "Port[]: " PORT
while [ -z $PORT ]
do
    echo -e "${RED}Port is required${NC}"
    read -p "Port[]: " PORT
done

read -p "Database[]: " DATABASE
while [ -z $DATABASE ]
do
    echo -e "${RED}Database is required${NC}"
    read -p "Database[]: " DATABASE
done

read -p "Username: " SQLUSERNAME
while [ -z $SQLUSERNAME ]
do
    echo -e "${RED}Username is required${NC}"
    read -p "Username[]: " SQLUSERNAME
done

read -p "Password: " SQLPASSWORD
while [ -z $SQLPASSWORD ]
do
    echo -e "${RED}Password is required${NC}"
    read -p "Password[]: " SQLPASSWORD
done

read -p "Radius password[]: " RADIUSPASSWD
while [ -z $RADIUSPASSWD ]
do
    echo -e "${RED}Radius password is required${NC}"
    read -p "Radius password[]: " RADIUSPASSWD
done

##CONFIGURE LOCATIME ZONE FILE
$(pwd)/src/localtime-config.sh

# ##PACKGE INSTALL FILE
# $(pwd)/src/package-install.sh

# ##CONFIGURE FREERADIUS FILE
# $(pwd)/src/freeradius-config.sh "$IPSERVERRADIUS" "$PORT" "$SQLUSERNAME" "$SQLPASSWORD" "$RADIUSPASSWD" "$DATABASE"

