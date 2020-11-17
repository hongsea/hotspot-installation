#!/bin/bash

##color
RED='\033[0;31m'
GREEN='\e[32m'
YELLOW='\033[1;33m'
BLUE='\033[1;32m'
NC='\033[0m' 

##get arguments from install.sh
USERNAME=$1
PASSWORD=$2

##postgresql
postgresql_config(){
./src/banner.sh "Install Postgresql"

    systemctl enable docker
    sudo systemctl start docker
    echo -e "${GREEN}[ OK ] Start service docker!${NC}"

    # read -p "Postgresql Username[]: " USERNAME
    # read -p "Postgresql Password[]: " PASSWORD

    cp -r -v $(pwd)/postgresql /opt/
    if [[ "$?" == 0 ]];then
        echo -e "${GREEN}[ OK ] Copy docker compose!${NC}"
    else
        echo -e "${RED}[ Failed ] Copy docker compose!${NC}"
    fi 

    grep -rli USERNAME /opt/postgresql/docker-compose.yml | xargs -i@ sed -i s+USERNAME+"${USERNAME}"+g @
    grep -rli PASSWD /opt/postgresql/docker-compose.yml | xargs -i@ sed -i s+PASSWD+${PASSWORD}+g @
    echo -e "${GREEN}[ OK ] Configure docker-compose!${NC}"

    docker-compose -f /opt/postgresql/docker-compose.yml down
    docker-compose -f /opt/postgresql/docker-compose.yml up -d
    echo -e "${GREEN}[ OK ] Start docker-compose!${NC}"

}

postgresql_config