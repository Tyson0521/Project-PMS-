@echo off
setlocal enabledelayedexpansion

:: -----------------------------
:: Load environment variables
:: -----------------------------
if exist ".env" (
    echo Loading environment variables from .env...
    for /f "usebackq tokens=1,* delims==" %%a in (".env") do (
        set %%a=%%b
    )
) else (
    echo .env file not found! Exiting...
    exit /b 1
)

:: -----------------------------
:: Drop & Create Database
:: -----------------------------
set PGPASSWORD=%DB_PWD%
echo Recreating local DB started...

psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d postgres -f drop_db.sql
psql -h %DB_HOST% -p %DB_PORT% -U %DB_USER% -d postgres -f create_db.sql

if %ERRORLEVEL% NEQ 0 (
    echo Database recreation failed!
    pause
    exit /b 1
)

echo Database %DB_NAME% created successfully with user %DB_USER%.
