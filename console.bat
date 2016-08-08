@echo off

rem set current version
set CONSOLE_VER=0.0.8
set CONSOLE_BAT=%~dpf0
set CONSOLE_DIR=%~dp0
set CONSOLE_SRC=https://raw.githubusercontent.com/Javanile/Console.bat/master/console.bat

rem cmd.exe preloaded settings
if "%1" == "__init__" (
	cls
	doskey console=%CONSOLE_BAT% $*
	doskey clear=%CONSOLE_BAT% clear
	doskey edit=%CONSOLE_BAT% edit $1
	doskey wget=%CONSOLE_BAT% wget $1 $2
	doskey open=%CONSOLE_BAT% open $1 $2
	doskey home=%CONSOLE_BAT% home
	doskey ls=%CONSOLE_BAT% ls $1
	doskey rm=%CONSOLE_BAT% rm $1 $2 $3
	color
	goto :eof
)

rem update 
if "%1" == "update" (
	bitsadmin.exe /transfer "update" %CONSOLE_SRC% %CONSOLE_BAT% > nul 2> nul
	echo.
	echo   Console.bat successfull updated!
	echo   Type 'exit' or close and reopen.
	goto :eof
)

rem install 
if "%1" == "install" (
	if [%2] == [] goto :syntaxerror
	bitsadmin.exe /transfer "install" %CONSOLE_SRC% %2\console.bat > nul 2> nul
	echo set o = WScript.CreateObject("WScript.Shell"^).CreateShortcut("%HOMEDRIVE%%HOMEPATH%\Desktop\%~n2.lnk"^): o.TargetPath = "%2\console.bat": o.IconLocation = "cmd.exe": o.Save > %2\_.vbs
	cscript %2\_.vbs > nul 2> nul 
	del %2\_.vbs
	attrib %2\console.bat +h +s
	echo.
	echo   Console.bat successfull installed!
	echo   Double-click on desktop icon to open.
	goto :eof
)

rem install 
if "%1" == "include" (
	set sync=call %CONSOLE_BAT% sync
	set console=call %CONSOLE_BAT%
	goto :eof
)

rem open 
if "%1" == "clear" (
	cls
	goto :eof
)

rem open 
if "%1" == "home" (
	cd %CONSOLE_DIR%
	echo.
	echo   Opening root projects directory
	echo   -------------------------------
	echo   %CD%
	goto :eof
)

rem open 
if "%1" == "open" (
	if [%2] == [] goto :syntaxerror
	cd %CONSOLE_DIR%
    for /d %%a in (%2*) do (
		cd %%a 
		goto :subopen
	)
    for /d %%a in (*) do (
		cd %%a
		for /d %%b in (%2*) do (
			cd %%b 
			goto :subopen
		)		
		cd ..
	)
	for /d %%a in (*) do (
		cd %%a
		for /d %%b in (*) do (
			cd %%b 
			for /d %%c in (%2*) do (
				cd %%c 
				goto :subopen
			)
			cd ..
		)		
		cd ..
	)
	for /d %%a in (*) do (
		cd %%a
		for /d %%b in (*) do (
			cd %%b 
			for /d %%c in (*) do (
				cd %%c 
				for /d %%d in (%2*) do (
					cd %%d 
					goto :subopen
				)
				cd ..
			)
			cd ..
		)		
		cd ..
	)
	echo.
	echo   Project directory not found: '%2*\%3*'
	goto :eof
	:subopen
	if not [%3] == [] (
		for /d %%a in (%3*) do (
			cd %%a 
			goto :open
		)	
		for /d %%a in (*) do (
			cd %%a 
			for /d %%b in (%3*) do (
				cd %%b 
				goto :open
			)	
			cd ..
		)	
		for /d %%a in (*) do (
			cd %%a 
			for /d %%b in (*) do (
				cd %%b 
				for /d %%c in (%3*) do (
					cd %%c 
					goto :open
				)
				cd ..
			)	
			cd ..
		)			
	)	
	:open
	echo.
	echo   Opening project directory
	echo   -------------------------
	echo   %CD%
	goto :eof 
)

rem ls
if "%1" == "ls" (
	echo.
	dir /w /o:gn %2 | findstr /c:"^[^ ]" /r
	goto :eof
)

rem ls
if "%1" == "rm" (
	if "%2" == "-fr" (
		erase /s /q /f %3 
		rmdir /s /q %3
		goto :eof
	)
	goto :syntaxerror
)

rem ls
if "%1" == "sync" (
	echo.
	xcopy /c /d /e /h /i /r /y %2 %3
	goto :eof
)

rem wget
if "%1" == "wget" (
	bitsadmin.exe /transfer "wget" %2
	goto :eof
)

rem edit command
if "%1" == "edit" (
	start /B "" "%CONSOLE_EDIT%" %2
	goto :eof
)

rem edit command
if "%1" == "--help" (
	echo.
	echo   Console.bat subcommands
	echo   -----------------------
	echo   console install ^<path^>    Install console.bat to ^<path^> and create shortcut
	echo   console update            Update console.bat to latest version
	echo   open ^<name^> ^[subname^]     Open project folder with name and subname
	echo   home                      Open root projects folder
	echo.
	echo   Linux inspired commands
	echo   -----------------------
	echo   ls        List file on directory
	goto :eof
)

rem edit command
if "%1" == "--version" (
	echo.
	echo   Console.bat v%CONSOLE_VER%
	echo   ------------------
	echo   Powered by Francesco Bianco ^<bianco@javanile.org^>
	echo   Licensed with The GNU General Public License v3.0
	goto :eof
)

rem unknown subcommand 
if not [%1] == [] (
	echo.
	echo   Unknown subcommand: '%1'
	echo   Type 'console --help' for usage.
	goto :eof	
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
cmd.exe /K call "%CONSOLE_BAT%" __init__

rem restore dos prompt
set PROMPT=%PROMP0%

rem exit
goto :eof 

rem invoce a syntaxerror
:syntaxerror
echo.
echo   Syntax error: missing argument 
echo   Type 'console --help' for usage.
echo.


