#!/bin/sh
if test -z $1;then
	echo "[ How ]"
	echo "$0 <modulename>"
	exit
fi
HTDOCS_PATH="/usr/local/apache224/cable"
CVS_SERVER=":pserver:bw.cheng@127.0.0.1:/cvs/cable"

echo "[!] The CVS default user is bw.cheng. If you want to change it, the first step is to fix this script. The second step is to fix and copy html.sh file. The last setp is to command \"cvs login\" with \"root (superuser)\" to memory the your cryption password."

/usr/bin/cvs -d $CVS_SERVER login
/usr/bin/cvs -d $CVS_SERVER co $1
if test -d $1;then
	cd $1
	/bin/ln -s ../cvschangelogbuilder.pl .
	/bin/ln -s ../html.sh .
	/bin/mkdir -p $HTDOCS_PATH/$1
	./html.sh $1
	cd ..
fi

echo '	
Done~~
	1. Add the modulename into "./cron_cvslog_daily.sh" or 
	"./cron_cvslog_weekly.sh" to build the report daily or weekly.

	2. Edit the cvs web page to show this module or not.
	/usr/local/apache224/cable/index.php:
		$SHOW_LIST=array(
			,"yourmodule"
		);
		$REPORT=array(
			,"yourmodule" => "daily/weekly"
		);
'
