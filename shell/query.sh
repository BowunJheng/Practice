#!/bin/sh
host -l -a -v $1
rpcinfo -p $1
portscanner $1 0 10000 -v
queso $1
nmap -O $1
#finger $2@h40.s78.ts.hinet.net
