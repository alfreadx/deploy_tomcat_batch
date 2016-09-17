@echo off

for /F "usebackq tokens=1,2,10" %%i in (`TASKLIST /V /NH /FI "IMAGENAME EQ javaw.exe" /FI "SESSIONNAME EQ RDP-Tcp#1"`) do (
	REM echo %%j
	TASKKILL /F /PID %%j
)

for /F "tokens=5" %%i in ('netstat -nao  ^| FINDSTR "0.0.0.0:8080"') do (
	REM echo %%i
	TASKKILL /F /PID %%i
)
