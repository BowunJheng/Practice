@Echo off
rem Askey Computer Corporation
rem ========= run this test loop for 1 or 2 hours ==============
rem a) opening a SF
rem b) sending some data through UGS during 20 seconds (80 kbps)
rem c) closing this SF
rem d) waiting 20 seconds
rem 
rem Please install net-snmp first. http://www.net-snmp.org
rem ============================================================

:: Parameters
set TotalExecuteTime=120
set CMIP=10.10.76.30
set SRCIP=10.10.85.216
set DSTIP=10.10.85.216
set MibGroup=.1.3.6.1.4.1.1038.28.1.3.1

rem ------------------------------------------------------------
set SecondPerLoop=40
set /a sleepsecond=%SecondPerLoop%/2
set snmpgetopts=-v 1 -c public -O vq
set snmpsetopts=-v 1 -c private
set MibSrcIpAddress=%MibGroup%.2
set MibDstIpAddress=%MibGroup%.3 
set MibDsSfid=%MibGroup%.11
set MibUsSfid=%MibGroup%.12
set MibAdminStatus=%MibGroup%.21
echo %MibAdminStatus%
set MibControlIndex=.1
set Create=2
set Delete=3

set /a MaxCounter= %TotalExecuteTime% * 60 / %SecondPerLoop%
set counter=1
snmpset %snmpsetopts% %CMIP% %MibSrcIpAddress%%MibControlIndex% a %SRCIP%
snmpset %snmpsetopts% %CMIP% %MibDstIpAddress%%MibControlIndex% a %DSTIP%

:STARTLOOP
cls
set /a NowExecTime = %SecondPerLoop% * (%counter%-1) +%sleepsecond%
rem title Total execute time = %NowExecTime%

echo ...
echo ... opening a SF
echo ...
rem a) opening a SF
title opening a SF AND waiting %sleepsecond% seconds
rem snmpset %snmpsetopts% %CMIP% %MibAdminStatus%%MibControlIndex% i %Create%
echo %SRCIP% ===Create=== %DSTIP%
echo DsSfid:
snmpget %snmpgetopts% %CMIP% %MibDsSfid%%MibControlIndex%
echo UsSfid:
snmpget %snmpgetopts% %CMIP% %MibUsSfid%%MibControlIndex%

rem b) sending some data through UGS during 20 seconds (80 kbps)
sleep %sleepsecond%

echo ...
echo ... closing this SF
echo ...

rem c) closing this SF
title closing this SF AND waiting %sleepsecond% seconds
snmpset %snmpsetopts% %CMIP% %MibAdminStatus%%MibControlIndex% i %Delete%
echo %SRCIP% ===Delete=== %DSTIP%

rem d) waiting 20 seconds
sleep %sleepsecond%

if %counter% == %MaxCounter% goto END
set /a counter+=1
goto STARTLOOP
:END
