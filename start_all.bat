@echo off
title ResQNet - Disaster Assistance Platform Launcher
color 0A
echo ========================================================
echo        STARTING RESQNET FULL-STACK SYSTEM
echo ========================================================
echo.

echo [1/2] Launching ResQNet Backend API (Port 5000)...
start "ResQNet Backend API [Port 5000]" cmd /k "cd /d %~dp0backend && npm.cmd run dev"

timeout /t 3 /nobreak >nul

echo [2/2] Launching ResQNet Frontend UI (Port 3000)...
start "ResQNet Frontend UI [Port 3000]" cmd /k "cd /d %~dp0frontend && npm.cmd run dev"

echo.
echo ========================================================
echo ResQNet is now starting!
echo Frontend: http://localhost:3000
echo Backend API: http://localhost:5000/api/health
echo ========================================================
pause
