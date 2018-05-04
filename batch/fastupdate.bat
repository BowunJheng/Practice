@echo off
@set SVNCMD=C:\Program Files\TortoiseSVN\bin\svn.exe
@echo SVN: update all folders in %cd%
FOR /f %%p IN ('dir /ad /b "%cd%"') DO ( if NOT "%%p" == "SZ" ( call :UPDATE %%p ) )
pause
goto :EXIT
:UPDATE
@echo %1
"%SVNCMD%" update "%cd%\%1"
:EXIT
