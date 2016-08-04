@echo off

rem cmd.exe preloaded settings
if "%1" == "__init__" (
	cls
	doskey clear=cls
	doskey ls=dir /a
	doskey 
	goto :eof
)

rem update 
if "%1" == "update" (
	bitsadmin.exe /transfer "console.bat"^
		https://raw.githubusercontent.com/Javanile/Console.bat/master/console.bat^
		%~dpf0 > nul 2> nul
	echo console.bat restart required type exit or close.	
	goto :eof
)

rem install 
if "%1" == "install" (
	bitsadmin.exe /transfer "console.bat"^
		https://raw.githubusercontent.com/Javanile/Console.bat/master/console.bat^
		%2\console.bat
	echo console.bat installed on %2
	echo use Desktop shortcup to launch
	goto :eof
)

rem prepare dos prompt
set PROMP0=%PROMPT%
set PROMPT=#$S

rem launch indipend cmd.exe process
cmd /K call "%~dpf0" __init__

rem restore dos prompt
set PROMPT=%PROMP0%

