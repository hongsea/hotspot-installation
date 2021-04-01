#!/bin/bash

##Color
RED='\033[0;31m'
GREEN='\e[32m'
YELLOW='\033[1;33m'
BLUE='\033[1;32m'
NC='\033[0m'

systemd(){
./src/banner.sh "Config Systemd"
    cp -rv ./systemd/* /lib/systemd/system/
    rm -rf /etc/nginx/sites-enabled/default
    if [[ $? == 0 ]];then
        echo -e "${GREEN}[ OK ] Copy config!${NC}"    
    else
        echo -e "${RED}[ Failed ] Copy config!${NC}"
    fi
    sudo systemctl daemon-reload
    sudo systemctl restart nginx
    STATUS=$(systemctl is-active nginx)
    echo -e "${GREEN}[ OK ] Config successful!${NC}"
    echo -e "${GREEN} [ ${STATUS} ] Start nginx service!"
}
systemd

