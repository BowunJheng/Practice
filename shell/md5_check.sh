#!/bin/sh --
HTTP_PROXY="best-proxy.bstec.net.tw:80"; export HTTP_PROXY
BASEURL="ftp://current.freebsd.org/"; export BASEURL
BASEDIR="pub/FreeBSD/snapshots/i386/";export BASEDIR
if [ ."$1" = ."" ]; then
        exec echo "Give me the directory"
fi
cd $1
TMP=`find -d . -name 'CHECKSUM.MD5' -type f`
for i in $TMP; do
        MD5DIR=`echo $i | sed s/CHECKSUM\.MD5// |cut -c 3-`
        cd $MD5DIR
        echo "-----"
        echo $MD5DIR "Status"
        echo "-----"
        MD5=`cat CHECKSUM.MD5|sed s/\ /\#/g`
        for j in $MD5; do
                FILE=`echo $j|awk -F "\)" '{print $1}' |cut -c 6-`
#               echo $FILE
                if [ ! -f $FILE ]; then
                        echo $FILE "is missing"
                        # Rescue Operation
                        echo "fetch from:"$BASEURL$BASEDIR$1"/"$MD5DIR$FILE
                        fetch $BASEURL$BASEDIR$1/$MD5DIR$FILE
                fi
                THISMD5=`md5 $FILE|sed s/\ /\#/g`
                if [ ! ."$j" = ."$THISMD5" ]; then
                        echo $FILE "md5 is incorrect"
                        # Rescue Operation
                        echo "fetch from:"$BASEURL$BASEDIR$1"/"$MD5DIR$FILE
                        fetch $BASEURL$BASEDIR$1/$MD5DIR$FILE
                        THISMD5=`md5 $FILE|sed s/\ /\#/g`
                        if [ ! ."$j" = ."$THISMD5" ]; then
                                echo "Original File or md5: "$MD5DIR$FILE" has E
RROR"
                                exec echo "Program Stopped"
                        fi
                fi
        done
        cd -
done


