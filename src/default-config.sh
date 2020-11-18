#!/bin/bash -e

##Color
RED='\033[0;31m'
GREEN='\e[32m'
YELLOW='\033[1;33m'
BLUE='\033[1;32m'
NC='\033[0m' 

##default
default_config(){
./src/banner.sh "Configure Default"

    cp -r -v $(pwd)/default/* /etc/default/
    if [[ "$?" == 0 ]];then
        echo -e "${GREEN}[ OK ] Configure Default config!${NC}"
    else
        echo -e "${RED}[ Failed ] Configure Default config!${NC}"
    fi
    
}

default_config