#!/bin/bash

##Color
RED='\033[0;31m'
GREEN='\e[32m'
YELLOW='\033[1;33m'
BLUE='\033[1;32m'
NC='\033[0m'

##get arguments from install.sh
WIRE=$1
WIRELESS=$2
LANIP=$3
LANNETMASK=$4
LANGATEWAY=$5
SSID=$6
RADIUSPASSWD=$7
DOMAIN=$8
RADIUSSERVER=$9
STATIONID=$10

##coovachilli
coovachilli_config(){
./src/banner.sh "Configure coovachilli"

    cp -r -v $(pwd)/coovachilli/* /
    if [[ $? == 0 ]];then
        echo -e "${GREEN}[ OK ] Copy config!${NC}"    
    else
        echo -e "${RED}[ Failed ] Copy config!${NC}"
    fi


    PREFIX1=$(echo ${LANIP} | awk -F'.' '{print $1}')
    PREFIX2=$(echo ${LANIP} | awk -F'.' '{print $2}')
    PREFIX3=$(echo ${LANIP} | awk -F'.' '{print $3}')

    NETWORK="${PREFIX1}.${PREFIX2}.${PREFIX3}.0"
    SUBNET="${LANNETMASK}"
    GATEWAY="${LANGATEWAY}"

    grep -rli INTERFACEWAN /etc/chilli/config | xargs -i@ sed -i s+INTERFACEWAN+${WIRE}+g @
    grep -rli INTERFACELAN /etc/chilli/config | xargs -i@ sed -i s+INTERFACELAN+${WIRELESS}+g @
    grep -rli IPNETWORK /etc/chilli/config | xargs -i@ sed -i s+IPNETWORK+${NETWORK}+g @
    grep -rli IPSUBNET /etc/chilli/config | xargs -i@ sed -i s+IPSUBNET+${SUBNET}+g @
    grep -rli IPGATEWAY /etc/chilli/config | xargs -i@ sed -i s+IPGATEWAY+${GATEWAY}+g @
    grep -rli SSIDNAME /etc/chilli/config | xargs -i@ sed -i s+SSIDNAME+${SSID}+g @
    grep -rli PASSRAD /etc/chilli/config | xargs -i@ sed -i s+PASSRAD+${RADIUSPASSWD}+g @
    grep -rli DOMAINNAME /etc/chilli/config | xargs -i@ sed -i s+DOMAINNAME+${DOMAIN}+g @
    grep -rli RADIUSSERVER /etc/chilli/config | xargs -i@ sed -i s+RADIUSSERVER+${RADIUSSERVER}+g @
    grep -rli RADIUSSERVER /etc/chilli/config | xargs -i@ sed -i s+STATIONID+${STATIONID}+g @
    echo -e "${GREEN}[ OK ] Configure coova!${NC}"

    systemctl enable chilli
    systemctl stop chilli
    sleep 5
    systemctl start chilli
    STATUS=$(systemctl is-active chilli)
    echo -e "${GREEN}[ ${STATUS} ] Start service chilli!"

}

coovachilli_config