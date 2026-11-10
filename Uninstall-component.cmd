@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1" -Uninstall
set "result=%errorlevel%"
if "%result%"=="0" (echo Uninstall completed.) else (echo Operation failed.)
echo Press any key to continue...
pause >nul
exit /b %result%
