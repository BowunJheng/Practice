#!/bin/sh
Range_ip_start=71
Range_ip_stop=90
while(test $Range_ip_start -le $Range_ip_stop);do
INFO=`lynx -source http://netflow.hcrc.edu.tw/stat/stat.php | grep "140.126.12."$Range_ip_start| wc|awk '{print $1}'`
if test $INFO -ne 0; then
        echo "Congratulation!! 140.126.12.$Range_ip_start(`nslookup 140.126.12.$Range_ip_start|grep Name|awk '{print$2}'`) had listed on netflow TOP30!!"
fi
Range_ip_start=`expr $Range_ip_start + 1`
done
