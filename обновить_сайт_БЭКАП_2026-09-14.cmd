@echo off
chcp 65001 >nul
cd /d "%~dp0"
git add -A
git commit -m "site update %date% %time%"
git push
echo.
echo GOTOVO. Stranica obnovitsya cherez 1-2 minuty.
pause
