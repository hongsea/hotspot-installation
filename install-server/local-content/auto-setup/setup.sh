#!/bin/bash

VITAMINIR="/var/www/local-content/vitaminair.koompi.lan"
REPO_VITAMINIR=VitaminAir
SMALLWORLD="/var/www/local-content/smallworld.koompi.lan"
REPO_SMALLWORLD=
KOOMPIDOCS="/var/www/local-content/www.koompi.org"
KOOMPIOFFICIAL="/var/www/local-content/www.koompi.com"

#Set up website vitaminir
#vitaminir.koompi.lan
$(pwd)/vitaminir.sh $VITAMINIR $REPO_VITAMINIR

#Set up website smallworld venture
#smallworld.koompi.lan
# $(pwd)/smallworldventure.sh $SMALLWORLD $REPO_SMALLWORLD