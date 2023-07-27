@echo off

if not "%1"=="Administrator" (
  powershell -Command "Start-Process cmd.exe -ArgumentList '/k cd /d %~dp0 & call "\"Full Install & Reinstall.bat"\" Administrator' -Verb RunAs"
  exit /b
)

title "Full Install & Reinstall - Warning"
mode con:cols=71 lines=12

cls
color 4
echo  =====================================================================
echo                                [WARNING]
echo.
echo    This operation will remove ALL files and folders in the current 
echo    directory where this script is located. 
echo.
echo    PLEASE ENSURE this script is not placed in a directory containing
echo    important files and folders as they will be PERMANENTLY DELETED.
echo.
echo  =====================================================================
echo.

set /p "choice=To continue type in the phrase: 'Yes, do as I say!': "
if /i not "%choice%"=="Yes, do as I say!" goto terminate

title "Full Install & Reinstall - In Progress"
mode con:cols=71 lines=12

cls
color 2
echo Starting Installation / Reinstallation

for %%F in ("%~dp0*.*") do (
    if not "%%~nxF"=="Full Install & Reinstall.bat" if not "%%~nxF"=="README.md" del "%%F"
)
for /d %%D in ("%~dp0*") do (
    if /i not "%%~nxD"==".git" rd /s /q "%%D"
)

mkdir "Temporary Files"
bitsadmin /transfer "Download Miniconda" /download /priority normal "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe" "%~dp0\Temporary Files\Miniconda3-latest-Windows-x86_64.exe"
start /wait "" ".\Temporary Files\Miniconda3-latest-Windows-x86_64.exe" /InstallationType=JustMe /AddToPath=0 /RegisterPython=0 /S /D=%cd%\Miniconda
rd /s /q ".\Temporary Files"

cls
mode con:cols=71 lines=9
echo  =====================================================================
echo                               [COMPLETED]
echo.
echo               The installation has successfully completed.
echo.
echo          This window will close automatically after 10 seconds.
echo.
echo  =====================================================================
timeout /t 10 /nobreak > nul
exit

:terminate
title "Full Install & Reinstall - Terminated"
mode con:cols=71 lines=11

cls
color 6
echo  =====================================================================
echo                              [TERMINATED]
echo.
echo            You have chosen not to proceed with the operation.
echo.
echo                Your files and folders were NOT affected.
echo.
echo          This window will close automatically after 10 seconds.
echo.
echo  =====================================================================
timeout /t 10 /nobreak > nul
exit