#!/bin/sh
SAVECOUNT=20
TIME=`date +"%Y%m%d_%H%M"`
FILECOUNT=`/bin/ls -1 /ramdisk_backup/ |/usr/bin/wc | /bin/awk '{print $1}'`
while test $FILECOUNT -ge $SAVECOUNT;
	do
		DEL_FILE=`/bin/ls -1 /ramdisk_backup/ | /bin/awk '{if(NR==1) print $1}'`
		echo $DEL_FILE
		/bin/rm -rf /ramdisk_backup/$DEL_FILE
		FILECOUNT=`expr $FILECOUNT - 1`
	done
/bin/tar cf /ramdisk_backup/jsim_$TIME.tar /mnt/
