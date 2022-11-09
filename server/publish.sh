#!/bin/bash

CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build 

scp ./aMusicServer  root@47.242.156.243:/data/kuge.app/

rm ./aMusicServer
