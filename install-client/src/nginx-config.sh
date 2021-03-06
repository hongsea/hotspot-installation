#!/bin/bash

##Color
RED='\033[0;31m'
GREEN='\e[32m'
YELLOW='\033[1;33m'
BLUE='\033[1;32m'
NC='\033[0m'

DOMAIN=$1
nginxc(){
./src/banner.sh "Configure Nginx"

    cp -r ./nginx/* /etc/nginx/
    if [[ $? == 0 ]];then
        echo -e "${GREEN}[ OK ] Copy config!${NC}"    
    else
        echo -e "${RED}[ Failed ] Copy config!${NC}"
    fi

    ln -s /etc/nginx/sites-available/hotspot.koompi.pi.conf /etc/nginx/sites-enabled/
    nginx -t
    grep -rli DOMAINNAME /etc/nginx/sites-available/hotspot.koompi.pi.conf | xargs -i@ sed -i s+DOMAINNAME+${DOMAIN}+g @
    
    systemctl disable apache2.service
    systemctl enable nginx php-fpm
    systemctl start nginx php-fpm

    echo -e "${GREEN}[ OK ] Start service nginx!${NC}"
}
nginxc