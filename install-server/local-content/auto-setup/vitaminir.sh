#!/bin/bash

PATHVITAMINIR=$1
REPONAME=$2

cd $PATHVITAMINIR
pwd
git clone https://github.com/koompi/$REPONAME.git
cd $REPONAME
npm install
npm run build
cd .next
pm2 --name vitaminair.koompi.lan start npm -- start
pm2 save