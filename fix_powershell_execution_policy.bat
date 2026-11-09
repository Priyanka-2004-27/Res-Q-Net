@echo off
title Fix PowerShell Script Execution Policy for npm
color 0B
echo ========================================================
echo   Fixing Windows PowerShell Script Execution Policy
echo ========================================================
echo.
powershell -Command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned -Force"
echo.
echo [DONE] PowerShell policy updated! You can now run 'npm' commands.
pause
