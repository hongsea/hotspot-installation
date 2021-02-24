#!/bin/bash

##Color
RED='\033[0;31m'
GREEN='\e[32m'
YELLOW='\033[1;33m'
BLUE='\033[1;32m'
NC='\033[0m' 

##get arguments from install.sh
IPSERVER=$1
PORT=$2
USERNAME=$3
PASSWORD=$4
RADIUSPASSWD=$5
DATABASE=$6

##freeradius
freeradius_config(){
./src/banner.sh "Configure freeradius"

    # #sql Connection info
    # echo "Connection info sql"
    # read -p "Server[]: " IPSERVER
    # read -p "Port[]: " PORT
    # read -p "Radius password[]: " RADIUSPASSWD

    cp -r -v $(pwd)/freeradius /etc/
    if [[ "$?" == 0 ]];then
        echo -e "${GREEN}[ OK ] Copy config.${NC}"
    else
        echo -e "${RED}[ Failed ] Copy config.${NC}"
    fi
    

    grep -rli IPSERVER /etc/freeradius/3.0/mods-available/sql | xargs -i@ sed -i s+IPSERVER+${IPSERVER}+g @
    grep -rli PORTNUMBER /etc/freeradius/3.0/mods-available/sql | xargs -i@ sed -i s+PORTNUMBER+${PORT}+g @
    grep -rli USERNAME /etc/freeradius/3.0/mods-available/sql | xargs -i@ sed -i s+USERNAME+${USERNAME}+g @
    grep -rli PASSWORDLOGIN /etc/freeradius/3.0/mods-available/sql | xargs -i@ sed -i s+PASSWORDLOGIN+${PASSWORD}+g @
    grep -rli DATABASES /etc/freeradius/3.0/mods-available/sql | xargs -i@ sed -i s+DATABASES+${DATABASE}+g @
    echo -e "${GREEN}[ OK ] Configure freeradius sql!${NC}"

    ln -s /etc/freeradius/3.0/sites-avaiable/default /etc/freeradius/3.0/sites-enabled/default
    ln -s /etc/freeradius/3.0/sites-available/inner-tunner /etc/freeradius/3.0/sites-enabled/inner-tunner
    ln -s /etc/freeradius/3.0/mods-available/sql /etc/freeradius/3.0/mods-enabled/sql
    echo -e "${GREEN}[ OK ] Link configure freeradius!${NC}"

    #secret
    grep -rli RADIUSSECRET /etc/freeradius/3.0/clients.conf | xargs -i@ sed -i s+RADIUSSECRET+${RADIUSPASSWD}+g @

    #delete expiration
    rm -rf /etc/freeradius/3.0/mods-enabled/expiration
    systemctl enable freeradius
    systemctl restart freeradius
    echo -e "${GREEN}[ OK ] Start service freeradius!${NC}"

}

freeradius_config