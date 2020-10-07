#!/bin/bash -e

##This script run for install hotspot

##Color
RED='\033[0;31m'
GREEN='\e[32m'
YELLOW='\033[1;33m'
BLUE='\033[1;32m'
NC='\033[0m'

##banner
banner(){
    echo
    BANNER_NAME=$1
    echo -e "${YELLOW}[+] ${BANNER_NAME}"
    echo -e "--------------------------------------${NC}"
}

##run as root
check_root(){
    if [[ $(id -u) != 0 ]]; then
        echo "This script run as root."
        exit;
    fi
}

##Install package
package_install(){
banner "Install Package"
    for PKG in $(cat $(pwd)/package_x86_64)
    do
        dpkg -s ${PKG} $> /dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[ OK ] Package ${PKG} is installed!${NC}"
        else
            echo -e "${GREEN}[ Check ] Installing ${PKG}...!${NC}"
            apt-get install -y ${PKG}
            echo -e "${GREEN}[ OK ] Package ${PKG} is installed!${NC}"
        fi
    done
}

##static ip address
static_ip_config(){
banner "Configure static ip address"
    WIRE=$(ls /sys/class/net/ | grep eth | awk 'NR==1')
    WIRELESS=$(ls /sys/class/net/ | grep wl)

    echo -e "You are have interfaces wan and lan!"
    #input wan ip
    echo "[${WIRE}]: is WAN interface"
    read -p "IP Address[]: " WANIP
    read -p "Netmask[]: " WANNETMASK
    read -p "Gateway[]: " WANGATEWAY


    #input lan ip
    echo -e "\n[${WIRELESS}]: is LAN interface"
    read -p "IP Address[]: " LANIP
    read -p "Netmask[]: " LANNETMASK
    read -p "Gateway[]: " LANGATEWAY    

    #copy config to /etc/network
    cp -r $(pwd)/staticIP/network /etc/

    #replace name in config file
    #wan interface
    grep -rli WANIP /etc/network/interfaces.d/eth0-wan | xargs -i@ sed -i s+WANIP+${WANIP}+g @
    grep -rli WANNETMASK /etc/network/interfaces.d/eth0-wan | xargs -i@ sed -i s+WANNETMASK+${WANNETMASK}+g @
    grep -rli WANGATEWAY /etc/network/interfaces.d/eth0-wan | xargs -i@ sed -i s+WANGATEWAY+${WANGATEWAY}+g @
    echo -e "${GREEN}[ OK ] Configure wan interface!${NC}"

    #lan interface
    grep -rli LANIP /etc/network/interfaces.d/wlan0-lan | xargs -i@ sed -i s+LANIP+${LANIP}+g @
    grep -rli LANNETMASK /etc/network/interfaces.d/wlan0-lan | xargs -i@ sed -i s+LANNETMASK+${LANNETMASK}+g @
    grep -rli LANGATEWAY /etc/network/interfaces.d/wlan0-lan | xargs -i@ sed -i s+LANGATEWAY+${LANGATEWAY}+g @    
    echo -e "${GREEN}[ OK ] Configure lan interface!${NC}"

    #start service
    systemctl restart networking
}

##dhcp
dhcp_config(){
banner "Configure dhcp"

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

    cp $(pwd)/dhcp/dhcpd.conf /etc/dhcp/
    echo -e "${GREEN}[ OK ] Copy dhcp config${NC}"

    grep -rli IPNETWORK /etc/dhcp/dhcpd.conf | xargs -i@ sed -i s+IPNETWORK+${NETWORK}+g @
    grep -rli IPSUBNET /etc/dhcp/dhcpd.conf | xargs -i@ sed -i s+IPSUBNET+${SUBNET}+g @
    grep -rli IPRANK /etc/dhcp/dhcpd.conf | xargs -i@ sed -i s+IPRANK+"${RANK}"+g @
    grep -rli IPGATEWAY /etc/dhcp/dhcpd.conf | xargs -i@ sed -i s+IPGATEWAY+${GATEWAY}+g @
    echo -e "${GREEN}[ OK ] Configure dhcp${NC}"

}

##postgresql
postgresql_config(){
banner "Install Postgresql"

    systemctl enable docker
    sudo systemctl start docker
    echo "${GREEN}[ OK ] Start service docker!${NC}"

    read -p "Postgresql Username[]: " USERNAME
    read -p "Postgresql Password[]: " PASSWORD

    cp -r postgresql /opt/
    echo -e "${GREEN}[ OK ] Copy docker compose!${NC}"

    grep -rli USERNAME /opt/postgresql/docker-compose.yml | xargs -i@ sed -i s+USERNAME+"${USERNAME}"+g @
    grep -rli PASSWORD /opt/postgresql/docker-compose.yml | xargs -i@ sed -i s+PASSWORD+${PASSWORD}+g @
    echo -e "${GREEN}[ OK ] Configure docker-compose!${NC}"

    docker-compose -f /opt/postgresql/docker-compose.yml down
    docker-compose -f /opt/postgresql/docker-compose.yml up -d
    echo -e "${GREEN}[ OK ] Start docker-compose!${NC}"


}

##call function
check_root
# package_install
static_ip_config
dhcp_config
postgresql_config