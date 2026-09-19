@echo off
chcp 65001 >nul
cd /d "%~dp0"

rem --- snyat zavisshiy zamok git (iz-za nego publikaciya molcha ne rabotala s 13.09) ---
if exist ".git\index.lock" (
  echo [i] Nayden zavisshiy zamok .git\index.lock - snimayu.
  del /f /q ".git\index.lock"
)

rem --- ubrat bekapy i chernoviki iz papki sayta (na sayt oni ne dolzhny uezzhat) ---
if not exist "..\_backup_site" mkdir "..\_backup_site"
for %%F in (index_*.html oferta_*.html politika_*.html spasibo_*.html cheklist_*.html *_2026-*.cmd) do move /y "%%F" "..\_backup_site\" >nul 2>&1

git add -A
if errorlevel 1 goto :oshibka

rem --- 19.09.2026: kommit mozhet byt uzhe sdelan (Cowork), togda tolko push ---
git diff --cached --quiet
if not errorlevel 1 (
  git fetch -q origin
  for /f %%N in ('git rev-list --count @{u}..HEAD') do set NEPUSH=%%N
  if "%NEPUSH%"=="0" (
    echo [i] Izmeneniy net i vse kommity uzhe na sayte - publikovat nechego.
    goto :konec
  )
  echo [i] Novyh izmeneniy net, no est %NEPUSH% neopublikovannyh kommitov - publikuyu ih.
  goto :push
)

git commit -m "site update %date% %time%"
if errorlevel 1 goto :oshibka

:push

git push
if errorlevel 1 goto :oshibka

echo.
echo ============================================
echo  OPUBLIKOVANO. Posledniy kommit:
git --no-pager log -1 --pretty=format:"   %%h  %%ad  %%s" --date=format:"%%d.%%m.%%Y %%H:%%M"
echo.
echo  Stranica: https://sverka-smet.ru/
echo  Obnovitsya cherez 1-2 minuty.
echo  Otkryvayte s Ctrl+F5 - inache brauzer pokazhet staruyu stranicu iz kesha.
echo ============================================
goto :konec

:oshibka
echo.
echo ############################################
echo  NE OPUBLIKOVANO. Git vernul oshibku - tekst vyshe.
echo  Sayt v seti NE izmenilsya. Pokazhite etot ekran.
echo ############################################

:konec
echo.
pause
