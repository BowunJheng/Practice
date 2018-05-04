@echo off
for /l %%a in (0,1,3) do call :setzero %%a
goto :end
:setzero
echo %1
:end
