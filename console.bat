@echo off

rem set current version
set CONSOLE_VERSION=0.0.3
set CONSOLE_PROCESS=%~dpf0

rem cmd.exe preloaded settings
if "%1" == "__init__" (
	cls
	doskey clear=cls
	doskey ls=dir /a
	doskey console=%~dpf0 $*
	doskey edit=%~dpf0 edit $1
	doskey wget=%~dpf0 wget $1
	color
	cd %~dp0
	goto:eof
)

rem update 
if "%1" == "update" (
	bitsadmin.exe /transfer "console.bat"^
		https://raw.githubusercontent.com/Javanile/Console.bat/master/console.bat^
		%~dpf0 > nul 2> nul
	echo console.bat restart required type exit or close.	
	goto:eof
)

rem install 
if "%1" == "install" (
	if [%2] == [] goto :syntaxerror
	bitsadmin.exe /transfer "console.bat"^
		https://raw.githubusercontent.com/Javanile/Console.bat/master/console.bat^
		%2\console.bat > nul 2> nul
	echo set o = WScript.CreateObject("WScript.Shell"^).CreateShortcut("%HOMEDRIVE%%HOMEPATH%\Desktop\%~n2.lnk"^):^
		o.TargetPath = "%2\console.bat":^
		o.IconLocation = "cmd.exe":^
		o.Save > _.vbs
	cscript _.vbs > nul 2> nul
	del _.vbs
	set CONSOLE_RELOAD=%2\console.bat
	echo.
	echo console.bat installed on %2
	echo use Desktop shortcup to launch
	goto:eof
)

rem 
if "%1" == "wget" (
	echo wget
	goto:eof
)

rem edit command
if "%1" == "edit" (
	start /B "" "%CONSOLE_EDIT%" %2
	goto:eof
)

rem edit command
if "%1" == "reload" (
	set CONSOLE_PROCESS=%2
	set CONSOLE_RELOAD=YES
	echo set variable
	goto:eof
)

rem edit command
if "%1" == "--help" (
	echo.
	echo   Console.bat subcommands
	echo   -----------------------
	echo   console install ^<path^>    Install console.bat to ^<path^> and create shortcut
	echo   console update            Update console.bat to latest version
	echo.
	echo   Linux inspired commands
	echo   -----------------------
	echo   ls        List file on directory
	goto:eof
)

rem edit command
if "%1" == "--version" (
	echo.
	echo   Console.bat v%CONSOLE_VERSION%
	echo   ------------------
	echo   Powered by Francesco Bianco ^<bianco@javanile.org^>
	echo   Licensed with The GNU General Public License v3.0
	goto:eof
)

rem unknown subcommand 
if not [%1] == [] (
	echo.
	echo   Unknown subcommand: '%1'
	echo   Type 'console --help' for usage.
	goto:eof	
)

rem detect edit command
set CONSOLE_EDIT=%ProgramFiles(x86)%\Notepad++\notepad++.exe

rem prepare dos prompt
if [%PROMP0%] == [] set PROMP0=%PROMPT%
set PROMPT=#$S

rem launch indipend cmd.exe process
cmd /K call "%CONSOLE_PROCESS%" __init__

rem restore dos prompt
set PROMPT=%PROMP0%

rem exit
goto:eof

rem invoce a syntaxerror
:syntaxerror
echo.
echo   Syntax error: missing argument 
echo   Type 'console --help' for usage.
echo.


