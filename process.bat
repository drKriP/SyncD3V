:: copy_file.bat
@echo off
setlocal enabledelayedexpansion

echo --------------------------------------------
echo Sync D3V Starting...
echo --------------------------------------------
:: Read config file
for /f "tokens=1,2 delims==" %%A in (config.txt) do (
    if "%%A"=="SOURCE" set SOURCE=%%B
    if "%%A"=="DESTINATION" set DESTINATION=%%B
    if "%%A"=="LOGPATH" set LOGPATH=%%B
)

:: Check if source file exists
if not exist "%SOURCE%" (
    echo Source file does not exist: %SOURCE%
    exit /b 1
)

:: Copy the file and overwrite if it exists
copy /Y "%SOURCE%" "%DESTINATION%"
if %ERRORLEVEL%==0 (
    echo File copied successfully and replaced if existed!
) else (
    echo Failed to copy file.
)

echo Tomcat is running. Stopping...
call "%CATALINA_HOME%\bin\shutdown.bat"
    
:: Wait for Tomcat to shut down completely
timeout /t 3 >nul
    

:: Clear Tomcat logs before restarting
echo Clearing Tomcat logs...
del /Q "%CATALINA_HOME%\logs\*.*"

:: Clear Application logs before restarting
echo Clearing Tomcat logs...
echo rmdir /S /Q "%LOGPATH%"
rmdir /S /Q "%LOGPATH%"
echo mkdir "%LOGPATH%"
mkdir "%LOGPATH%"

:: Wait for clearing logs
timeout /t 2 >nul

:: Start Tomcat
echo Starting Tomcat...
call "%CATALINA_HOME%\bin\startup.bat"

:: Wait for user input before closing
echo --------------------------------------------
echo Press any key to exit...
echo --------------------------------------------
pause >nul