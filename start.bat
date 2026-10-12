@echo off
setlocal

echo ===================================================
echo Starting Open EasyX on Windows (No Docker)
echo ===================================================
echo.

echo Checking prerequisites...

where git >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Git is not installed or not in PATH.
    echo Please install Git from https://git-scm.com/
    pause
    exit /b 1
)

where node >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] Node.js is not installed or not in PATH.
    echo Please install Node.js (version 22.5 or newer) from https://nodejs.org/
    pause
    exit /b 1
)

where ffmpeg >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERROR] FFmpeg is not installed or not in PATH.
    echo Please install FFmpeg and add it to your system PATH.
    pause
    exit /b 1
)

echo.
echo Pulling latest updates from repository...
git pull origin main

echo.
echo Installing Node.js dependencies...
call npm install
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install Node.js dependencies.
    pause
    exit /b 1
)

echo.
echo Building web application...
call npm run build
if %errorlevel% neq 0 (
    echo [ERROR] Failed to build the web application.
    pause
    exit /b 1
)

:: Create necessary directories if they don't exist
if not exist "data" mkdir data
if not exist "media" mkdir media
if not exist "plugins-external" mkdir plugins-external

:: Set environment variables for local execution
set EASYX_DATA_DIR=data
set EASYX_MEDIA_DIR=media
set EASYX_EXTERNAL_PLUGINS_DIR=plugins-external
set EASYX_EMBEDDED_SUBTITLE_WORKER=false

echo.
echo ===================================================
echo Open EasyX is starting...
echo Once started, open http://localhost:3210 in your browser.
echo Press Ctrl+C to stop the server.
echo ===================================================
echo.

call npm start

pause
