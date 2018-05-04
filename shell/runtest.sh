#!/bin/sh
NETPERF="~/src/netperf-2.4.1/src/netperf"
TESTTIME=30
#SERVERHOST="10.10.68.75"
SERVERHOST="10.10.64.168"
#SERVERHOST="10.10.64.147"
#MAXCWND=(8192 16384 32768 65536 131072)
#MAXCWND=(1024 2048 4096 8192 16384 32768 65536)
MAXCWND=(32768 65536)
PACKETSIZE=(64 128 256 512 1024 1500 1512)
QUITEMODE=1


MCwndItem=`expr ${#MAXCWND[@]} - 1`
PSizeItem=`expr ${#PACKETSIZE[@]} - 1`
if [ $QUITEMODE -eq 1 ];then
    printtestheader=0
else
    printtestheader=1
fi
for elementcwnd in $(seq 0 $MCwndItem)
do
    for elementpsize in $(seq 0 $PSizeItem)
    do
        echo "$NETPERF -l $TESTTIME -P $printtestheader -f k -H $SERVERHOST -- -s ${MAXCWND[$elementcwnd]} -S ${MAXCWND[$elementcwnd]} -m ${PACKETSIZE[$elementpsize]}"
        $NETPERF -l $TESTTIME -P $printtestheader -f k -H $SERVERHOST -- -s ${MAXCWND[$elementcwnd]} -S ${MAXCWND[$elementcwnd]} -m ${PACKETSIZE[$elementpsize]}
    done
done
