#!/bin/bash

##Color
RED='\033[0;31m'
GREEN='\e[32m'
YELLOW='\033[1;33m'
BLUE='\033[1;32m'
NC='\033[0m'

SHARESCREIT=$1
DOMAIN=$2
captive-portal(){
./src/banner.sh "Config Captive Portal"

    mkdir -p /var/www/hotspot.$DOMAIN/
    cp -rv ./captive-portal/* /var/www/hotspot.$DOMAIN/
    if [[ $? == 0 ]];then
        echo -e "${GREEN}[ OK ] Copy config!${NC}"    
    else
        echo -e "${RED}[ Failed ] Copy config!${NC}"
    fi

    grep -rli CHILLISHARESCREIT /var/www/hotspot.$DOMAIN/hotspotlogin.php | xargs -i@ sed -i s+CHILLISHARESCREIT+${SHARESCREIT}+g @
    grep -rli DOMAIN /var/www/hotspot.$DOMAIN/hotspotlogin.php | xargs -i@ sed -i s+DOMAIN+${DOMAIN}+g @
    grep -rli DOMAIN /var/www/hotspot.$DOMAIN/template/default/login-successful.php | xargs -i@ sed -i s+DOMAIN+${DOMAIN}+g @

    echo -e "${RED}[ OK ] Config successful!${NC}"
}
captive-portal