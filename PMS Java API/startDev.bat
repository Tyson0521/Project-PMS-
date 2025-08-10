@echo off
setlocal enabledelayedexpansion

:: -----------------------------
:: Configurable starting port
:: -----------------------------
set PORT=8080

:: -----------------------------
:: Check if Java is installed
:: -----------------------------
java -version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Java is not installed or not in PATH.
    echo Please install Java 21+ and try again.
    pause
    exit /b 1
)

:: -----------------------------
:: Find next free port
:: -----------------------------
:CHECKPORT
netstat -ano | findstr :%PORT% >nul
if %ERRORLEVEL% EQU 0 (
    set /a PORT+=1
    goto CHECKPORT
)

echo Starting Spring Boot on port %PORT% with auto-restart...

:: -----------------------------
:: Auto-restart on file changes
:: -----------------------------
npx nodemon ^
  --watch startDev.bat ^
  --exec "cmd /c mvnw spring-boot:run -Dspring-boot.run.arguments=--server.port=%PORT%"
