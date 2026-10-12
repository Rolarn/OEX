Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "Starting Open EasyX on Windows (No Docker)" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Checking prerequisites..."

# Check Git
if (-not (Get-Command "git" -ErrorAction SilentlyContinue)) {
    Write-Error "[ERROR] Git is not installed or not in PATH."
    Write-Host "Please install Git from https://git-scm.com/" -ForegroundColor Yellow
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

# Check Node.js
if (-not (Get-Command "node" -ErrorAction SilentlyContinue)) {
    Write-Error "[ERROR] Node.js is not installed or not in PATH."
    Write-Host "Please install Node.js (version 22.5 or newer) from https://nodejs.org/" -ForegroundColor Yellow
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

# Check FFmpeg
if (-not (Get-Command "ffmpeg" -ErrorAction SilentlyContinue)) {
    Write-Error "[ERROR] FFmpeg is not installed or not in PATH."
    Write-Host "Please install FFmpeg and add it to your system PATH." -ForegroundColor Yellow
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Pulling latest updates from repository..." -ForegroundColor Green
git pull origin main

Write-Host ""
Write-Host "Installing Node.js dependencies..." -ForegroundColor Green
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Error "[ERROR] Failed to install Node.js dependencies."
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Building web application..." -ForegroundColor Green
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Error "[ERROR] Failed to build the web application."
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

# Create necessary directories
if (-not (Test-Path -Path "data")) { New-Item -ItemType Directory -Path "data" | Out-Null }
if (-not (Test-Path -Path "media")) { New-Item -ItemType Directory -Path "media" | Out-Null }
if (-not (Test-Path -Path "plugins-external")) { New-Item -ItemType Directory -Path "plugins-external" | Out-Null }

# Set environment variables for local execution
$env:EASYX_DATA_DIR="data"
$env:EASYX_MEDIA_DIR="media"
$env:EASYX_EXTERNAL_PLUGINS_DIR="plugins-external"
$env:EASYX_EMBEDDED_SUBTITLE_WORKER="false"

Write-Host ""
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host "Open EasyX is starting..." -ForegroundColor Cyan
Write-Host "Once started, open http://localhost:3210 in your browser." -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop the server." -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan
Write-Host ""

npm start

Read-Host -Prompt "Press Enter to exit"
