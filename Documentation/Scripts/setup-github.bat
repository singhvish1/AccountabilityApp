@echo off
echo ========================================
echo   AccountabilityLock - GitHub Setup
echo   Account: singhvish1
echo ========================================
echo.

REM Check if Git is installed
git --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git is not installed!
    echo Please install Git from: https://git-scm.com/download/win
    echo After installation, restart this script.
    pause
    exit /b 1
)

echo [OK] Git is installed
echo.

REM Navigate to project directory
cd /d "%~dp0"
echo Current directory: %CD%
echo.

REM Check if already initialized
if exist ".git\" (
    echo [INFO] Git repository already initialized
    echo.
) else (
    echo [STEP 1] Initializing Git repository...
    git init
    echo [OK] Repository initialized
    echo.
)

REM Check Git configuration
echo [STEP 2] Checking Git configuration...
git config user.name >nul 2>&1
if errorlevel 1 (
    echo [CONFIG] Please set your Git username:
    set /p username="Enter your name (e.g., Vish Singh): "
    git config --global user.name "%username%"
)

git config user.email >nul 2>&1
if errorlevel 1 (
    echo [CONFIG] Please set your Git email:
    set /p email="Enter your GitHub email: "
    git config --global user.email "%email%"
)

echo [OK] Git configured
echo     Name: 
git config user.name
echo     Email: 
git config user.email
echo.

REM Add all files
echo [STEP 3] Adding files to Git...
git add .
echo [OK] Files added
echo.

REM Show status
echo [STATUS] Files ready to commit:
git status --short
echo.

REM Create commit
echo [STEP 4] Creating commit...
git commit -m "Initial commit: AccountabilityLock iOS app - Accountability-based app blocker with push notifications"
if errorlevel 1 (
    echo [WARNING] Nothing to commit or commit failed
    echo.
) else (
    echo [OK] Commit created
    echo.
)

REM Set branch to main
echo [STEP 5] Setting default branch to main...
git branch -M main
echo [OK] Branch set to main
echo.

REM Check if remote exists
git remote get-url origin >nul 2>&1
if errorlevel 1 (
    echo [STEP 6] Adding GitHub remote...
    git remote add origin https://github.com/singhvish1/AccountabilityLock.git
    echo [OK] Remote added
    echo.
) else (
    echo [INFO] Remote already exists:
    git remote get-url origin
    echo.
)

REM Final instructions
echo ========================================
echo   READY TO PUSH!
echo ========================================
echo.
echo BEFORE RUNNING THE NEXT COMMAND:
echo 1. Go to https://github.com/singhvish1
echo 2. Click the + button (top right)
echo 3. Select "New repository"
echo 4. Name: AccountabilityLock
echo 5. Do NOT initialize with README, .gitignore, or license
echo 6. Click "Create repository"
echo.
echo AFTER CREATING THE REPO ON GITHUB:
echo.
echo Run this command to push:
echo     git push -u origin main
echo.
echo When prompted:
echo     Username: singhvish1
echo     Password: [Use Personal Access Token]
echo.
echo To create token: https://github.com/settings/tokens
echo.
echo ========================================
pause
