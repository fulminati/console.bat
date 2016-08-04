@echo off

rem 
set CONSOLE_VERSION=0.0.2

rem cmd.exe preloaded settings
if "%1" == "__init__" (
	cls
	doskey clear=cls
	doskey ls=dir /a
	doskey console=%~dpf0 $*
	doskey edit=%~dpf0 edit $1
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
	goto:eof
)

rem edit command
if "%1" == "edit" (
	start /B "" "%CONSOLE_EDIT%" %2
	goto:eof
)

rem edit command
if "%1" == "version" (
	echo.
	echo Console.bat v%CONSOLE_VERSION%
	echo ------------------
	echo Powered by Francesco Bianco ^<bianco@javanile.org^>
	echo Licensed with The GNU General Public License v3.0
	goto:eof
)

rem detect edit command
set CONSOLE_EDIT=%ProgramFiles(x86)%\Notepad++\notepad++.exe

rem prepare dos prompt
set PROMP0=%PROMPT%
set PROMPT=#$S

rem launch indipend cmd.exe process
cmd /K call "%~dpf0" __init__

rem restore dos prompt
set PROMPT=%PROMP0%

:exit