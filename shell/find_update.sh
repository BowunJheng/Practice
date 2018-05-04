#!/bin/sh
SEARCH_DIR="/home/share/"
SEARCHTIME_DAY=7
TIME=`date +"%Y%m%d_%H"`
MAIN_FILENAME="_��s����_Update_Index.TXT"
OUTPUT_INDEXFILE=$SEARCH_DIR$TIME$MAIN_FILENAME
TITLE="\n==============================================================\n"$SEARCHTIME_DAY"�Ѥ��ҧ�s���ؿ��@����(��@)\n==============================================================\n\n"
TITLE2="\n\n==============================================================\n"$SEARCHTIME_DAY"�Ѥ��ҧ�s���ɮ׸ԲӦC��(��G)\n==============================================================\n\n"
DELETE_FILENAME=$SEARCH_DIR"*"$MAIN_FILENAME

/bin/rm -rf $DELETE_FILENAME

/bin/echo -e $TITLE > $OUTPUT_INDEXFILE

/usr/bin/find $SEARCH_DIR -type d -mtime -$SEARCHTIME_DAY -print | /bin/sort >> $OUTPUT_INDEXFILE

/bin/echo -e $TITLE2 >> $OUTPUT_INDEXFILE

/usr/bin/find $SEARCH_DIR -type f -mtime -$SEARCHTIME_DAY -print | /bin/sort >> $OUTPUT_INDEXFILE
