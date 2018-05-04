#!/sbin/sh
ICECAST_DIR="~/icecast";
case "$1" in
'start')
	if test -f $ICECAST_DIR/bin/icecast.start;
		then
		echo 'Please stop icecast service first.'
		echo './icecast.sh stop'
		exit 1
	fi
	if test -f $ICECAST_DIR/bin/icecast;
		then
		`$ICECAST_DIR/bin/icecast > $ICECAST_DIR/bin/icecast.start &`
		echo 'icecast service starting.'
	fi
	;;

'stop')
	if test -f $ICECAST_DIR/bin/icecast.start; 
		then
		icepid=`ps -Af|sed -n s/icecast//p|grep icecast|awk '{print $2;}'`
		kill -9 $icepid
		`rm $ICECAST_DIR/bin/icecast.start`
		echo 'icecast service stoping.'
	fi
	;;
'restart')
	if test -f $ICECAST_DIR/bin/icecast.start;
		then
		$0 stop
		$0 start
	fi
	;;
*)
	echo "Usage: $0 { start | stop | restart }"
	exit 1
	;;
esac
