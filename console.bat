@echo off

rem set current version
set CONSOLE_VER=0.0.5
set CONSOLE_BAT=%~dpf0
set CONSOLE_DIR=%~dp0
set CONSOLE_SRC=https://raw.githubusercontent.com/Javanile/Console.bat/master/console.bat

rem cmd.exe preloaded settings
if "%1" == "__init__" (
	cls
	doskey clear=cls
	doskey ls=dir /a
	doskey console=%CONSOLE_BAT% $*
	doskey edit=%CONSOLE_BAT% edit $1
	doskey wget=%CONSOLE_BAT% wget $1
	doskey open=%CONSOLE_BAT% open $1
	color
	if "%2" == "__open__" (
		echo.
		echo   Console.bat v%CONSOLE_VER%
		echo   ------------------
		echo   project: %CD%		
	) 
	goto:eof
)

rem update 
if "%1" == "update" (
	bitsadmin.exe /transfer "console.bat" %CONSOLE_SRC% %CONSOLE_BAT% > nul 2> nul
	echo.
	echo   Console.bat successfull updated!
	echo   Type 'exit' or close and reopen.
	goto:eof
)

rem install 
if "%1" == "install" (
	if [%2] == [] goto :syntaxerror
	bitsadmin.exe /transfer "console.bat" %CONSOLE_SRC% %2\console.bat > nul 2> nul
	echo set o = WScript.CreateObject("WScript.Shell"^).CreateShortcut("%HOMEDRIVE%%HOMEPATH%\Desktop\%~n2.lnk"^): o.TargetPath = "%2\console.bat": o.IconLocation = "cmd.exe": o.Save > _.vbs
	cscript _.vbs > nul 2> nul & del _.vbs
	echo.
	echo   Console.bat successfull installed!
	echo   Double-click on desktop icon to open.
	goto:eof
)

rem open 
if "%1" == "open" (
	if [%2] == [] goto :syntaxerror
	cd %CONSOLE_DIR%
    for /d %%a in (%2*) do (
		cd %%a 
		goto :open
	)
    for /d %%a in (*) do (
		cd %%a
		for /d %%b in (%2*) do (
			cd %%b 
			goto :open
		)		
		cd ..
	)
	for /d %%a in (*) do (
		cd %%a
		for /d %%b in (*) do (
			cd %%b 
			for /d %%c in (%2*) do (
				cd %%c 
				goto :open
			)
			cd ..
		)		
		cd ..
	)
	echo.
	echo   Project directory not found: '%2\%3'
	goto:eof
	:open
	if not [%3] == [] (
		for /d %%a in (%3*) do (
			cd %%a 
			goto :subopen
		)		
	)
	:subopen
	cmd /K call "%CONSOLE_BAT%" __init__ __open__ 
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
if "%1" == "--help" (
	echo.
	echo   Console.bat subcommands
	echo   -----------------------
	echo   console install ^<path^>    Install console.bat to ^<path^> and create shortcut
	echo   console update            Update console.bat to latest version
	echo   open ^<name^> ^[subname^] 
	echo.
	echo   Linux inspired commands
	echo   -----------------------
	echo   ls        List file on directory
	goto:eof
)

rem edit command
if "%1" == "--version" (
	echo.
	echo   Console.bat v%CONSOLE_VER%
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

rem save old dos prompt
if [%PROMP0%] == [] set PROMP0=%PROMPT%

rem set new prompt
set PROMPT=#$S

rem 
cd %CONSOLE_DIR%

rem launch indipend cmd.exe process
cmd /K call "%CONSOLE_BAT%" __init__

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


