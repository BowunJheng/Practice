#!/bin/sh
SEARCH_DIR="/home/share/"
SEARCHTIME_DAY=7
TIME=`date +"%Y%m%d_%H"`
MAIN_FILENAME="_更新索引_Update_Index.TXT"
OUTPUT_INDEXFILE=$SEARCH_DIR$TIME$MAIN_FILENAME
TITLE="\n==============================================================\n"$SEARCHTIME_DAY"天內所更新的目錄一覽表(表一)\n==============================================================\n\n"
TITLE2="\n\n==============================================================\n"$SEARCHTIME_DAY"天內所更新的檔案詳細列表(表二)\n==============================================================\n\n"
DELETE_FILENAME=$SEARCH_DIR"*"$MAIN_FILENAME

/bin/rm -rf $DELETE_FILENAME

/bin/echo -e $TITLE > $OUTPUT_INDEXFILE

/usr/bin/find $SEARCH_DIR -type d -mtime -$SEARCHTIME_DAY -print | /bin/sort >> $OUTPUT_INDEXFILE

/bin/echo -e $TITLE2 >> $OUTPUT_INDEXFILE

/usr/bin/find $SEARCH_DIR -type f -mtime -$SEARCHTIME_DAY -print | /bin/sort >> $OUTPUT_INDEXFILE
