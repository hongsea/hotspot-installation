#!/bin/bash

PATHDIR=$1

cd $PATHDIR
npm install

pm2 --name world.koompi.org start npm index.js
pm2 save