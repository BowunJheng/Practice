#!/bin/sh
Diff=`date +%S`
Diff=`expr $Diff % 5`
MsgDatP1="/usr/local/share/games/fortune/liuyong"
MsgDatP2="/usr/local/share/games/fortune/tangshi"
MsgDatP3="/usr/local/share/games/fortune/yijing"
if test $Diff -eq 0; then
        lunar -h `date "+%Y %m %d"` | g2b
elif test $Diff -eq 1; then
        /usr/games/fortune $MsgDatP1
elif test $Diff -eq 2; then
	/usr/games/fortune $MsgDatP2
elif test $Diff -eq 3; then
        /usr/games/fortune $MagDatP3
else
	/usr/games/fortune
fi
