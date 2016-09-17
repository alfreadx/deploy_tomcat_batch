rem dir  /TC /O-D \\10.1.20.98\mes_builds\beta | find "cimWeb-beta" 

@echo off
for /f %%i in ('dir /B /TC /O-D \\10.1.20.98\mes_builds\beta ^| findstr "cimWeb-beta"') do (
	set warfile=%%i
	goto echowarfile
)

REM dir  /TC /O-D \\10.1.20.98\mes_builds\beta | find "cimWeb-beta"
:echowarfile
echo %warfile%