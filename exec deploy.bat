@echo off

REM 從10.1.20.98\mes_builds\beta (JENKINS建置WAR檔放置的PATH) 取得最新的WAR檔
REM 搜尋的條件由FINDSTR_WARFILE_NAME 定義。
REM 因為BAT檔都放置於TOMCAT的BIN資料夾，故使用%~dp0取得batch檔的path


set WAR_REPO="\\10.1.20.98\mes_builds\beta"
set FINDSTR_WARFILE_NAME=cimWeb-beta

for /f %%i in ('dir /B /TC /O-D %WAR_REPO:~1,-1% ^| findstr "%FINDSTR_WARFILE_NAME%"') do (
	set WAR_FILE=%%i
	goto echowarfile
)

:echowarfile
echo %WAR_FILE%

SET WAR_PATH=%WAR_REPO:~1,-1%\%WAR_FILE%

call deploy "%~dp0.." "%WAR_PATH%" cimWeb


