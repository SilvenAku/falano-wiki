@echo off
title Falano Universe – Wiki Sync
cd /d "%~dp0"
echo.
echo  ==========================================
echo   FALANO UNIVERSE – Wiki Sync
echo  ==========================================
echo.

powershell.exe -ExecutionPolicy Bypass -File "%~dp0sync-falano.ps1"

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo  ==========================================
    echo   FEHLER: Skript mit Fehlercode %ERRORLEVEL% beendet.
    echo  ==========================================
)

echo.
pause
