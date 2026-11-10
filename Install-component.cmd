@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0install.ps1"
set "result=%errorlevel%"
if "%result%"=="0" (echo Installation completed.) else (echo Operation failed.)
echo Press any key to continue...
pause >nul
exit /b %result%
