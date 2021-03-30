#!/bin/bash

##Color
RED='\033[0;31m'
GREEN='\e[32m'
YELLOW='\033[1;33m'
BLUE='\033[1;32m'
NC='\033[0m' 

##Install package
package_install(){
./src/banner.sh "Install Package"

    for PKG in $(cat $(pwd)/package_x86_64)
    do
        dpkg -s ${PKG} &> /dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[ OK ] Package ${PKG} is installed!${NC}"
        else
            echo -e "${GREEN}[ INSTALL ] Installing ${PKG}...!${NC}"
            apt-get install -y ${PKG}
            echo -e "${GREEN}[ OK ] Package ${PKG} is installed!${NC}"
        fi
    done

}

package_install
