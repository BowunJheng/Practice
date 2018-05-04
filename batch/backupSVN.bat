@echo off
set MYPATH=%~dp0SVN\
set SVNPATH=D:\SVN
set zipArg=a -t7z
set zipCmd=C:\Progra~1\7-Zip\7z %zipArg%
set SVNCmd=svn update
FOR /F "tokens=* delims= " %%a IN ("%TIME:~0,2%") DO SET hour=0%%a

@For /f "tokens=1-3 delims=/ " %%a in ('date /t') do (set currdate=%%a%%b%%c%hour%) 

for /D %%A IN (%SVNPATH%\*) DO (
del "%MYPATH%%%~nA*.7z"
%SVNCmd% "%%A"
%zipCmd% "%MYPATH%%%~nA_%currdate%.7z" "%%A"
)
