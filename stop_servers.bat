@echo off
title Stop ResQNet Servers
color 0C
echo ========================================================
echo         STOPPING ALL RESQNET BACKGROUND TASKS
echo ========================================================
echo.
echo Freeing Port 5000 (Backend)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :5000') do (
    taskkill /F /PID %%a >nul 2>&1
)

echo Freeing Port 3000 (Frontend)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :3000') do (
    taskkill /F /PID %%a >nul 2>&1
)

echo.
echo [DONE] Ports 5000 and 3000 have been freed successfully!
pause
