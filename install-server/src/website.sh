#!/bin/bash

##Color
RED='\033[0;31m'
GREEN='\e[32m'
YELLOW='\033[1;33m'
BLUE='\033[1;32m'
NC='\033[0m' 

function website(){
./src/banner.sh "Running website"

    sudo cp -r ./local-content/* /var/www/
    echo -e "${GREEN}[ OK ] Copy source code.${NC}"

    echo -e "${GREEN}[ OK ] Pm2 on startup.${NC}"
    GET=$(pm2 startup | grep sudo)
    $GET
    
    echo -e "${GREEN}[ RUN ] Website: world.koompi.org${NC}"
    cd /var/www/world.koompi.org/

    npm install
    sudo npm install pm2
    echo -e "${GREEN}[ OK ] Install pm2.${NC}"

    pm2 --name world.koompi.org start npm index.js
    pm2 save
    echo -e "${GREEN}[ RUNNING ] world.koompi.org${NC}"
}

website