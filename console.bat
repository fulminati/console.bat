@echo off

if not "%1" == "init" goto:run

cls

doskey clear=cls
doskey ls=dir /a

goto:eof

:run

set PROMPT0=%PROMPT%

set PROMPT=#$S

cmd /K call "%~dpf0" init

set PROMPT=%PROMPT0%

