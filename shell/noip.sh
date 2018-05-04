#!/bin/sh
case "$1" in
	start)
		echo "Starting noip."
		/usr/local/sbin/noip
		;;
	*)
		echo "Usage: $0 start"
		exit 1
esac
exit 0
