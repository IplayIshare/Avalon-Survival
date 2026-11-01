@echo off
setlocal
set "gameDir=%~dp0client"
if not exist "%gameDir%\Albion-Online_BE.exe" goto missing
if not exist "%gameDir%\version.txt" goto wrongversion
findstr.exe /x /l /c:"albiononline-win32-full-1.32.030.345319" "%gameDir%\version.txt" >nul
if errorlevel 1 goto wrongversion
start "" /D "%gameDir%" "%gameDir%\Albion-Online_BE.exe" +server 157.10.201.13:5055
exit /b 0
:missing
echo Chua co client. Chay 1-Tai-client.cmd truoc.
echo Neu da co game, chep dung ban 1.32.030.345319 vao thu muc client.
pause
exit /b 1
:wrongversion
echo Client khong dung phien ban 1.32.030.345319 hoac thieu version.txt.
echo Xem README.md de lay dung client. Khong tu dong cap nhat ban game nay.
pause
exit /b 1
