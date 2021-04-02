#!/bin/bash

##Color
RED='\033[0;31m'
GREEN='\e[32m'
YELLOW='\033[1;33m'
BLUE='\033[1;32m'
NC='\033[0m'

DOMAIN=$1
RADIUSSERVER=$2

nginxc(){
./src/banner.sh "Configure Nginx"

    cp -r ./nginx/* /etc/nginx/
    if [[ $? == 0 ]];then
        echo -e "${GREEN}[ OK ] Copy config!${NC}"    
    else
        echo -e "${RED}[ Failed ] Copy config!${NC}"
    fi

    sudo mv /etc/nginx/sites-available/hotspot.koompi.pi.conf /etc/nginx/sites-available/hotspot.$DOMAIN.conf
    sudo mv /etc/nginx/sites-available/world.koompi.pi.conf /etc/nginx/sites-available/world.$DOMAIN.conf
    ln -s /etc/nginx/sites-available/* /etc/nginx/sites-enabled/
    nginx -t
    grep -rli DOMAINNAME /etc/nginx/sites-available/hotspot.$DOMAIN.conf | xargs -i@ sed -i s+DOMAINNAME+${DOMAIN}+g @
    grep -rli DOMAINNAME /etc/nginx/sites-available/world.$DOMAIN.conf | xargs -i@ sed -i s+DOMAINNAME+${DOMAIN}+g @
    grep -rli RADIUSSERVER /etc/nginx/sites-available/world.$DOMAIN.conf | xargs -i@ sed -i s+RADIUSSERVER+${RADIUSSERVER}+g @

    systemctl disable apache2.service
    systemctl enable nginx.service
    systemctl restart nginx.service
    STATUS=$(systemctl is-active nginx.service)
    echo -e "${GREEN}[ ${STATUS} ] Start service nginx!${NC}"
}
nginxc