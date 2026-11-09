@echo off
title Create New MongoDB Database for ResQNet
color 0B
echo ========================================================
echo        CREATE NEW MONGODB DATABASE FOR RESQNET
echo ========================================================
echo.
set /p dbname="Enter New Database Name (Press ENTER for 'resqnet_new_db'): "
if "%dbname%"=="" set dbname=resqnet_new_db

echo.
echo Creating and seeding database: %dbname% ...
cd /d %~dp0backend
node create_new_db.js %dbname%

echo.
pause
