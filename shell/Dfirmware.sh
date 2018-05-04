#!/bin/sh
cd /home/daily/Butterfly/
/usr/bin/cvs -q update -P -d
cd ..
/bin/chmod -R 755 Butterfly
source /home/daily/daily_cm.bash
work
app

for build_model in DCM465 TCM460 DCM425 \
CME600
do
    ./makeapp $build_model clean
    ./makeapp $build_model
    /home/daily/mv2daily $build_model
done
