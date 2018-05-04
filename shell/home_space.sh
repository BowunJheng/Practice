#!/bin/sh
DIRPATH="/home/anonymousftp/NFS/"
CONTENT="\n
每分鐘會自動更新一次可用的硬碟容量大小!!\n
PS. 請不要取檔名為 "Avail_*" 開頭的文字檔.\n
============================================\n
Update the avail capacity size of the harddisk per minute!!\n
PS. Please don't name the text file as start with regular word \"Avail_*\".\n
\n
BW
"
LSDIRHD=`/bin/ls -1 $DIRPATH`
ADDONDIR="/home/anonymousftp/"

for EachPath in $LSDIRHD
do
    /bin/rm -f $DIRPATH$EachPath/Avail_*.txt
    SPACE_NAME=`/bin/df -m $DIRPATH$EachPath | /bin/awk '{if(NR==2) if($4<=0) print("empty"); else if($4>=1024) print ($4/1024)"_GB";else print $4"_MB";}'`
    echo -e $CONTENT > $DIRPATH$EachPath/Avail_$SPACE_NAME.txt
done

for EachPath in $ADDONDIR
do
    /bin/rm -f $EachPath/Avail_*.txt
    SPACE_NAME=`/bin/df -m $EachPath | /bin/awk '{if(NR==2) if($4<=0) print("empty"); else if($4>=1024) print ($4/1024)"_GB";else print $4"_MB";}'`
    echo -e $CONTENT > $EachPath/Avail_$SPACE_NAME.txt
done
