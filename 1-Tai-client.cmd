@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Install-Client.ps1"
set "result=%errorlevel%"
echo.
if not "%result%"=="0" echo Cai dat chua hoan tat. Xem thong bao phia tren.
pause
exit /b %result%
