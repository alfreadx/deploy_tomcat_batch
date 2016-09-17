@echo off
setlocal enableextensions


set TOMCAT_DIR=%~1

set TOMCAT_WEBAPPS_DIR=%TOMCAT_DIR%\webapps

set DEPLOY_WAR_PATH=%~2

set WAR_FILE_NAME=%~nx2

set WEBAPP_NAME=%~3

set WEBAPP_WAR_PATH=%TOMCAT_WEBAPPS_DIR%\%WEBAPP_NAME%.war

set RD_WEBAPP_PATH=%TOMCAT_WEBAPPS_DIR%\%WEBAPP_NAME%

set RD_WORK_PATH=%TOMCAT_DIR%\work

set STARTUP_PATH=%TOMCAT_DIR%\bin

set NOW_TIME=%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%

set LOG_FILE="%TOMCAT_DIR%\logs\deploy_log\log_%NOW_TIME%.txt"


REM 先檢查傳進來的參數，之後
REM 1.關掉tomcat
REM 2.刪除webapps/cimWeb
REM 3.刪除webapps/cimWeb.war
REM 4.刪除work
REM 5.複製cimWeb.war
REM 6.啟動tomcat


rem 開log資料夾
mkdir  "%LOG_FILE:~1,-26%"
echo >> %LOG_FILE%

rem 紀錄輸入進來的參數
echo [ %TIME% ] output var to log >> %LOG_FILE%
echo [ %TIME% ] output TOMCAT_DIR: %TOMCAT_DIR% >> %LOG_FILE%
echo [ %TIME% ] output DEPLOY_WAR_PATH: %DEPLOY_WAR_PATH% >> %LOG_FILE%
echo [ %TIME% ] output WAR_FILE_NAME: %WAR_FILE_NAME% >> %LOG_FILE%
echo [ %TIME% ] output WEBAPP_NAME: %WEBAPP_NAME% >> %LOG_FILE%



rem 檢查傳進來的參數，是否存在該路徑、該檔案
:check_param_exist
if not exist "%DEPLOY_WAR_PATH%" (
	echo [ %TIME% ] %DEPLOY_WAR_PATH% not exist. >> %LOG_FILE%
	goto bat_end
)
if not exist "%TOMCAT_DIR%" (
	echo [ %TIME% ] %TOMCAT_DIR% not exist. >> %LOG_FILE%
	goto bat_end
)


:getPid_and_kill_tomcat
for /F "usebackq tokens=1,2,10" %%i in (`TASKLIST /V /NH /FI "WINDOWTITLE EQ Tomcat" /FI "STATUS EQ RUNNING"`) do (
	if %ERRORLEVEL% EQU 0 (
		echo [ %TIME% ] i=%%i,j=%%j,k=%%k >> %LOG_FILE%
		echo [ %TIME% ] KILL PROCESS ID %%j ,WINDOWTITLE is %%k, Program name is %%i >> %LOG_FILE%
		TASKKILL /F /PID %%j >> %LOG_FILE%
		if %ERRORLEVEL% EQU 0 (
			echo [ %TIME% ] taskkill success! >> %LOG_FILE%
		)
	)
)
:force_shutdown
ECHO [ %TIME% ] Use force_shutdown.bat to kill Tomcat process. >> %LOG_FILE%
CMD /C force_shutdown.bat >> %LOG_FILE%
ECHO [ %TIME% ] SLEEP 3 SECONDS >> %LOG_FILE%
ping 127.0.0.1 -n 3 -w 1000 > nul
 
:remove_webapp_dir
echo [ %TIME% ] Remove %RD_WEBAPP_PATH% >> %LOG_FILE%
RD /S /Q "%RD_WEBAPP_PATH%" >> %LOG_FILE%
if %ERRORLEVEL% GTR 0 (
	echo [ %TIME% ] Remove %RD_WEBAPP_PATH% failed! >> %LOG_FILE%
) else (
	echo [ %TIME% ] Remove %RD_WEBAPP_PATH% success! >> %LOG_FILE%
)

:remove_webapp_war
echo [ %TIME% ] Remove %WEBAPP_WAR_PATH% >> %LOG_FILE%
DEL /F "%WEBAPP_WAR_PATH%" >> %LOG_FILE%
if %ERRORLEVEL% GTR 0 (
	echo [ %TIME% ] Remove %WEBAPP_WAR_PATH% failed! >> %LOG_FILE%
) else (
	echo [ %TIME% ] Remove %WEBAPP_WAR_PATH% success! >> %LOG_FILE%
)

:remove_work_dir
echo [ %TIME% ] Remove %RD_WORK_PATH% >> %LOG_FILE%
RD /S /Q "%RD_WORK_PATH%" >> %LOG_FILE%
if %ERRORLEVEL% GTR 0 (
	echo [ %TIME% ] Remove %RD_WORK_PATH% failed! >> %LOG_FILE%
) else (
	echo [ %TIME% ] Remove %RD_WORK_PATH% success! >> %LOG_FILE%
)


:copy_webapp_war_to_tomcat
xcopy /k /y /v /q "%DEPLOY_WAR_PATH%" "%TOMCAT_WEBAPPS_DIR%" >> %LOG_FILE%
if %ERRORLEVEL% GTR 0 (
	echo [ %TIME% ] copy failed! "%DEPLOY_WAR_PATH%" to "%TOMCAT_WEBAPPS_DIR%" >> %LOG_FILE%
) else (
	echo [ %TIME% ] copy success! "%DEPLOY_WAR_PATH%" to "%TOMCAT_WEBAPPS_DIR%" >> %LOG_FILE%
)

:rename
cd /d "%TOMCAT_WEBAPPS_DIR%"
REM if "%DEPLOY_WAR_PATH:~0,12%" EQU "\\10.1.20.98" (
	REM set SOURCE_WAR_FILENAME=%DEPLOY_WAR_PATH:~29%
REM ) else (
set SOURCE_WAR_FILENAME=%WAR_FILE_NAME%
REM )
ECHO [ %TIME% ] RENAME WAR FILE. %SOURCE_WAR_FILENAME% to %WEBAPP_NAME%.war >> %LOG_FILE%
ren %SOURCE_WAR_FILENAME% %WEBAPP_NAME%.war >> %LOG_FILE%

ECHO [ %TIME% ] SLEEP 3 SECONDS >> %LOG_FILE%
ping 127.0.0.1 -n 3 -w 1000 > nul

:exec_startup
cd /d "%STARTUP_PATH%"
CMD /C startup.bat >> %LOG_FILE%


echo [ %TIME% ] Deploy End. >> %LOG_FILE%
goto:eof

:try_netstat_getPid
echo taskkill failed!

:remove_work_dir_failed
:remove_webapp_dir_failed
:bat_end
goto:eof
