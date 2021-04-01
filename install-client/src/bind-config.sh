#!/bin/bash

##Color
RED='\033[0;31m'
GREEN='\e[32m'
YELLOW='\033[1;33m'
BLUE='\033[1;32m'
NC='\033[0m' 

##get arguments from install.sh
DOMAIN=$1
LANIP=$2

bind-config(){
./src/banner.sh "Config Bind9"    
    REVERSE=$(echo $LANIP | awk -F. '{OFS="."; print $3,$2,$1}')
    IPEND=$(echo $LANIP | awk -F. '{OFS="."; print $4}')

    cp -r -v $(pwd)/bind/* /
    if [[ "$?" == 0 ]];then
        echo -e "${GREEN}[ OK ] Copy config bind!${NC}"
    else
        echo -e "${RED}[ Failed ] Copy config bind!${NC}"
    fi

    ##named.conf.local
    grep -rli DOMAINNAME /etc/bind/named.conf.local | xargs -i@ sed -i s+DOMAINNAME+${DOMAIN}+g @
    grep -rli IPADDRESSREVERSE /etc/bind/named.conf.local | xargs -i@ sed -i s+IPADDRESSREVERSE+${REVERSE}+g @

    mv /etc/bind/db.domain.lan /etc/bind/db.$DOMAIN
    mv /etc/bind/db.rev.1.16.172.in-addr.arpa /etc/bind/db.rev.$REVERSE.in-addr.arpa

    ##db.koompi.lan
    grep -rli DOMAINNAME /etc/bind/db.$DOMAIN | xargs -i@ sed -i s+DOMAINNAME+${DOMAIN}+g @
    grep -rli IPLAN /etc/bind/db.$DOMAIN| xargs -i@ sed -i s+IPLAN+${LANIP}+g @
    
    ##db.rev.1.16.172.in-addr.arpa
    grep -rli DOMAINNAME /etc/bind/db.rev.$REVERSE.in-addr.arpa | xargs -i@ sed -i s+DOMAINNAME+${DOMAIN}+g @
    grep -rli IPEND /etc/bind/db.rev.$REVERSE.in-addr.arpa | xargs -i@ sed -i s+IPEND+${IPEND}+g @   

    systemctl enable bind9.service
    systemctl restart bind9.service
    STATUS=$(systemctl is-active bind9.service)

    echo -e "${GREEN}[ ${STATUS} ] Configure bind success!${NC}"
}

bind-config