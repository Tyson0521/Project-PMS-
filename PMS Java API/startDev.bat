@echo off
setlocal enabledelayedexpansion

:: -----------------------------
:: Configurable starting port
:: -----------------------------
set PORT=8080
set DB_PORT=5432
set DB_HOST=localhost

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
:: Check if PostgreSQL is running
:: -----------------------------
echo Checking PostgreSQL on %DB_HOST%:%DB_PORT%...
netstat -ano | findstr :%DB_PORT% >nul
if %ERRORLEVEL% NEQ 0 (
    echo PostgreSQL is NOT running on %DB_HOST%:%DB_PORT%.
    echo Please start your PostgreSQL server and try again.
    pause
    exit /b 1
) else (
    echo PostgreSQL is running on %DB_HOST%:%DB_PORT%.
)

:: -----------------------------
:: Find next free app port
:: -----------------------------
:CHECKPORT
netstat -ano | findstr :%PORT% >nul
if %ERRORLEVEL% EQU 0 (
    set /a PORT+=1
    goto CHECKPORT
)

echo Starting Spring Boot API on port %PORT% with auto-restart...

:: -----------------------------
:: Auto-restart on file changes
:: -----------------------------
npx nodemon ^
  --watch src ^
  --watch pom.xml ^
  --watch application.properties ^
  --ext java,xml,properties ^
  --exec "cmd /c .\mvnw spring-boot:run -e -Dspring-boot.run.arguments=--server.port=%PORT%"
