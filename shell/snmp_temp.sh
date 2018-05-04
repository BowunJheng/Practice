#!/bin/sh
MAX_ITEM=1200
/usr/bin/snmpset -c private -v 1 192.168.100.1 .1.3.6.1.4.1.4413.2.99.1.1.1.2.1.2.1 s password
/usr/bin/snmpset -c private -v 1 192.168.100.1 .1.3.6.1.4.1.4413.2.99.1.1.1.1.0 i 1
/usr/bin/snmpset -c private -v 1 192.168.100.1 .1.3.6.1.4.1.4413.2.99.1.1.2.2.1.1.0 i 2
echo "" > Battery.log
echo "" > Utility.log
for add_item in $(seq 0 $MAX_ITEM)
do
    echo $add_item
    /usr/bin/snmpwalk -Os -c public -v 1 192.168.100.1 .1.3.6.1.4.1.4413.2.2.2.1.10.1.1.1.19 | awk '{print "'$add_item' "$0 }' >>  Battery.log
    /usr/bin/snmpwalk -Os -c public -v 1 192.168.100.1 .1.3.6.1.2.1.33.1.2.7 | awk '{print "'$add_item' "$0 }' >>  Utility.log
    sleep 1
done
