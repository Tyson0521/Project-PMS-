@echo off
set PORT=3000

REM Find next free port
:CHECK_PORT
netstat -ano | findstr :%PORT% >nul
if %errorlevel%==0 (
    set /a PORT=%PORT%+1
    goto CHECK_PORT
)

echo Starting Vite on port %PORT% with auto-restart...
npx nodemon --watch .env --watch startWeb.bat --exec "npm run dev -- --port %PORT%"
