@echo off
setlocal enabledelayedexpansion

:: -----------------------------
:: Check if .env file exists
:: -----------------------------
if exist ".env" (
    echo Loading environment variables from .env...
    for /f "usebackq tokens=1,* delims==" %%a in (".env") do (
        set %%a=%%b
    )
) else (
    echo .env file not found, asking for environment...
    :ASK_ENV
    echo Please enter host environment:
    echo   1 - localhost
    echo   2 - ver2
    echo   3 - douat
    echo   4 - sandbox
    set /p envtype=Enter choice [1-4]: 

    if "%envtype%"=="1" (
        set DB_HOST=localhost
        set DB_NAME=PMS
        set DB_PORT=5432
        set DB_USER=postgres
        set DB_PWD=P@55word
    ) else if "%envtype%"=="2" (
        set DB_HOST=localhost
        set DB_NAME=postgres2
        set DB_PORT=5432
        set DB_USER=postgres2
        set DB_PWD=P@55word
    ) else if "%envtype%"=="3" (
        set DB_HOST=***REMOVED***
        set DB_NAME=postgres3
        set DB_PORT=5432
        set DB_USER=postgres3
        set DB_PWD=***REMOVED***
    ) else if "%envtype%"=="4" (
        set DB_HOST=***REMOVED***
        set DB_NAME=postgres4
        set DB_PORT=5432
        set DB_USER=postgres4
        set DB_PWD=***REMOVED***
    ) else (
        echo Invalid choice! Try again.
        goto ASK_ENV
    )
)

:: -----------------------------
:: Start timer
:: -----------------------------
for /f "tokens=2 delims==" %%I in ('"wmic os get LocalDateTime /value"') do set DTS=%%I
set STARTTIME=%DTS:~0,14%

echo Running Flyway migration on %DB_NAME%@%DB_HOST%:%DB_PORT%...

:: -----------------------------
:: Run Flyway
:: -----------------------------
flyway -url="jdbc:postgresql://%DB_HOST%:%DB_PORT%/%DB_NAME%" ^
       -user=%DB_USER% ^
       -password=%DB_PWD% ^
       -locations=filesystem:./migrations-lego ^
       -outOfOrder=true ^
       -connectRetries=50 ^
       repair migrate

if %ERRORLEVEL% NEQ 0 (
    echo Flyway migration failed!
    pause
    exit /b 1
)

:: -----------------------------
:: Load test data if localhost
:: -----------------------------
if "%envtype%"=="1" (
    echo Loading test data...
    set PGPASSWORD=%DB_PWD%
    psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d %DB_NAME% -f ./lego_test_data.sql
)

:: -----------------------------
:: End timer
:: -----------------------------
for /f "tokens=2 delims==" %%I in ('"wmic os get LocalDateTime /value"') do set DTE=%%I
set ENDTIME=%DTE:~0,14%

echo Full database build completed.
echo Started at %STARTTIME%
echo Ended   at %ENDTIME%

pause
