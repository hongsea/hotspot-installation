#!/bin/bash

##color
RED='\033[0;31m'
GREEN='\e[32m'
YELLOW='\033[1;33m'
BLUE='\033[1;32m'
NC='\033[0m' 

##get arguments from install.sh
LANIP=$1
LANNETMASK=$2
LANGATEWAY=$3
WIRELESS=$4

##dhcp
dhcp_config(){
./src/banner.sh "Configure dhcp"

    PREFIX1=$(echo ${LANIP} | awk -F'.' '{print $1}')
    PREFIX2=$(echo ${LANIP} | awk -F'.' '{print $2}')
    PREFIX3=$(echo ${LANIP} | awk -F'.' '{print $3}')

    NETWORK="${PREFIX1}.${PREFIX2}.${PREFIX3}.0"
    SUBNET="${LANNETMASK}"
    GATEWAY="${LANGATEWAY}"

    echo "Network[]: ${NETWORK}"
    echo "Subnet[]: ${SUBNET}"
    echo "Gateway[]: ${GATEWAY}"

    read -p "We recommended use range (10-254) [Y\n]: " YN
    if [[ "${YN}" == "Y" || "${YN}" == "y" || -z "${YN}" ]];then
        RANK="${PREFIX1}.${PREFIX2}.${PREFIX3}.10 ${PREFIX1}.${PREFIX2}.${PREFIX3}.254"
        echo "Rank[]: ${RANK}"
    else
        read -p "Rank start from[]: " START
        read -p "To[]: " END
        RANK="${PREFIX1}.${PREFIX2}.${PREFIX3}.${START} ${PREFIX1}.${PREFIX2}.${PREFIX3}.${END}"
        echo "Rank[]: ${RANK}"
    fi

    cp -v $(pwd)/dhcp/dhcpd.conf /etc/dhcp/
    grep -rli IPNETWORK /etc/dhcp/dhcpd.conf | xargs -i@ sed -i s+IPNETWORK+${NETWORK}+g @
    grep -rli IPSUBNET /etc/dhcp/dhcpd.conf | xargs -i@ sed -i s+IPSUBNET+${SUBNET}+g @
    grep -rli IPRANK /etc/dhcp/dhcpd.conf | xargs -i@ sed -i s+IPRANK+"${RANK}"+g @
    grep -rli IPGATEWAY /etc/dhcp/dhcpd.conf | xargs -i@ sed -i s+IPGATEWAY+${GATEWAY}+g @
    grep -rli LANINTERFACE /etc/default/isc-dhcp-server | xargs -i@ sed -i s+LANINTERFACE+${WIRELESS}+g @
    if [[ "$?" == 0 ]]; then
        echo -e "${GREEN}[ OK ] Configure dhcp${NC}"
    else
        echo -e "${RED}[ Failed ] Configure dhcp${NC}"
    fi

    systemctl disable dhcpcd
    systemctl enable isc-dhcp-server
    systemctl restart isc-dhcp-server
    echo -e "${GREEN}[ OK ] Start service dhcp!${NC}"
}

dhcp_config