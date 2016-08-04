@echo off

rem cmd.exe preloaded settings
if "%1" == "__init__" (
	cls
	doskey clear=cls
	doskey ls=dir /a
	doskey console=%~dpf0 
	cd %~dp0
	goto :exit
)

rem update 
if "%1" == "update" (
	bitsadmin.exe /transfer "console.bat"^
		https://raw.githubusercontent.com/Javanile/Console.bat/master/console.bat^
		%~dpf0 > nul 2> nul
	echo console.bat restart required type exit or close.	
	goto :exit
)

rem install 
if "%1" == "install" (
	bitsadmin.exe /transfer "console.bat"^
		https://raw.githubusercontent.com/Javanile/Console.bat/master/console.bat^
		%2\console.bat
	echo Set oWS = WScript.CreateObject("WScript.Shell"^) > console.vbs
	echo sLinkFile = "%HOMEDRIVE%%HOMEPATH%\Desktop\%~n2.lnk" >> console.vbs
	echo Set oLink = oWS.CreateShortcut(sLinkFile^) >> console.vbs
	echo oLink.TargetPath = "%2\console.bat" >> console.vbs
	echo oLink.IconLocation = "cmd.exe" >> console.vbs
	echo oLink.Save >> console.vbs
	cscript console.vbs
	rem del CreateShortcut.vbs
	echo console.bat installed on %2
	echo use Desktop shortcup to launch
	goto :exit
)

rem prepare dos prompt
set PROMP0=%PROMPT%
set PROMPT=#$S

rem launch indipend cmd.exe process
cmd /K call "%~dpf0" __init__

rem restore dos prompt
set PROMPT=%PROMP0%

:exit