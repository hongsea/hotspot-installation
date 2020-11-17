#!/bin/bash

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

banner "$@"