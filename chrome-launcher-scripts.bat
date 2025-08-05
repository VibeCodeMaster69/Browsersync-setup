:: launch-chrome-test.bat - Launch Chrome profiles for testing
@echo off
setlocal enabledelayedexpansion

:: Configuration
set CHROME_PATH="C:\Program Files\Google\Chrome\Application\chrome.exe"
set PROFILE_BASE=C:\ChromeProfiles

:: For external site testing
set URL=http://localhost:3000/market/brc20?tick=ligo

:: Or use external IP if needed
:: set URL=http://192.168.254.146:3000/market/brc20?tick=ligo

echo ========================================
echo Chrome Profile Launcher for BrowserSync
echo ========================================
echo.

set /p START="Enter starting profile number (1): " || set START=1
set /p COUNT="Enter number of profiles to launch (2): " || set COUNT=2

echo.
echo Launching %COUNT% profiles starting from Profile%START%...
echo URL: %URL%
echo.

set /a END=%START%+%COUNT%-1

for /l %%i in (%START%,1,%END%) do (
    set PROFILE_DIR=%PROFILE_BASE%\Profile%%i
    
    echo Launching Profile%%i...
    start "" %CHROME_PATH% --user-data-dir="!PROFILE_DIR!" --no-first-run "%URL%"
    
    :: Small delay between launches
    timeout /t 1 /nobreak >nul
)

echo.
echo ========================================
echo Launched %COUNT% Chrome profiles!
echo Check BrowserSync UI: http://localhost:3001
echo ========================================
pause