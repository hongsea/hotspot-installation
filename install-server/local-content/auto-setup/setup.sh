#!/bin/bash

echo "Install pm2"
npm install pm2

echo "pm2 startup"
GET=$(pm2 startup | grep sudo)
$GET

VITAMINIR="/var/www/local-content/vitaminair.koompi.lan"
REPO_VITAMINIR=VitaminAir

FIFIPATH="/var/www/local-content/world.koompi.org"

#Set up website vitaminir
#vitaminir.koompi.lan
# $(pwd)/vitaminir.sh $VITAMINIR $REPO_VITAMINIR

#Set up website smallworld venture
#world.koompi.org
# $(pwd)/smallworldventure.sh $SMALLWORLD $REPO_SMALLWORLD

#Set up website world.koompi.org
$(pwd)/world.koompi.org.sh $FIFIPATH