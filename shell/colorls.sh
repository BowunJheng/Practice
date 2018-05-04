#!/bin/sh
if test $# -gt 0; then
	while test $# -gt 0;
	do
		if test $#=-l;then
			shift
			if test $# -gt 0;then
				while test $# -gt 0;
				do
					/usr/local/bin/colorls -FlG --color=always $1
					shift
				done
				exit
			else
				/usr/local/bin/colorls -FlG --color=always
				exit
			fi
		fi
		shift
	done
else
	/usr/local/bin/colorls -FG --color=always
fi
