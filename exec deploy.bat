@echo off

REM �q10.1.20.98\mes_builds\beta (JENKINS�ظmWAR�ɩ�m��PATH) ���o�̷s��WAR��
REM �j�M�������FINDSTR_WARFILE_NAME �w�q�C
REM �]��BAT�ɳ���m��TOMCAT��BIN��Ƨ��A�G�ϥ�%~dp0���obatch�ɪ�path


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


