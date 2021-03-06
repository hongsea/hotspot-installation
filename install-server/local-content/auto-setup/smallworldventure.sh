#!/bin/bash

PATHSMALLWORLD=$1
REPONAME=$2

cd $PATHSMALLWORLD
pwd
git clone https://github.com/koompi/$REPONAME.git
cd $REPONAME
npm install
npm run build
cd .next
pm2 --name www.vitaminair.lan start npm -- start
pm2 save