@echo off
set ADBFILE="adb"
set APKFILE="ilitekTouchAP_v1_4_18_0.apk"
set HEXFILE="ILI2113A_WGJ7371A_V08_Header.hex"
rem ==================================
%ADBFILE% install %APKFILE%
sleep 1
%ADBFILE% shell "rm -f /sdcard/%HEXFILE% 2> /dev/null"
%ADBFILE% push %HEXFILE% /sdcard/
%ADBFILE% shell input keyevent 4
sleep 1
%ADBFILE% shell "su -c 'chmod 0777 /dev/ilitek_ctrl'"
%ADBFILE% shell am start -n ilitek.android/.Command -e hex /sdcard/%HEXFILE% -e cmd upgrade
sleep 20
%ADBFILE% shell rm /sdcard/%HEXFILE%
%ADBFILE% uninstall ilitek.android
pause