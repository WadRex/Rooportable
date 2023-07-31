@echo off

if not "%1"=="Administrator" (
  powershell -Command "Start-Process cmd.exe -ArgumentList '/k cd /d %~dp0 & call "\"Launch Roop.bat"\" Administrator' -Verb RunAs"
  exit
)

cls
title "Launch Roop"

if not "%2"=="Launcher" (
  if not exist ".\Roop" (
    powershell -Command "Start-Process cmd.exe -ArgumentList '/k cd /d %~dp0 & call "\"Full Install & Reinstall.bat"\" Administrator Launcher' -Verb RunAs"
    exit
  )

  if not exist ".\Miniconda" (
    powershell -Command "Start-Process cmd.exe -ArgumentList '/k cd /d %~dp0 & call "\"Full Install & Reinstall.bat"\" Administrator Launcher' -Verb RunAs"
    exit
  )
)

CALL .\Miniconda\Scripts\activate.bat .\Miniconda\envs

:device_selection
cls
echo POSSIBLE DEVICES:
echo 1. GPU (NVIDIA)
echo 2. GPU (AMD) or CPU
set /p "choice=SELECT DEVICE BY TYPING '1' or '2': "
if /i "%choice%"=="1" (
    set "provider=cuda"
    cls    
    echo YOU SELECTED "GPU (NVIDIA)"
) else if /i "%choice%"=="2" (
    set "provider=cpu"
    cls
    echo YOU SELECTED "GPU (AMD) or CPU"
) else (
    goto device_selection
)

if not exist "%USERPROFILE%\.insightface" (
  mkdir "%USERPROFILE%\.insightface\models"
) else (  
  rd /s /q "%USERPROFILE%\.insightface"
  mkdir "%USERPROFILE%\.insightface\models"
)

mklink /D "%USERPROFILE%\.insightface\models\buffalo_l" "%~dp0Roop\models\buffalo_l"

cd Roop
python .\run.py --execution-provider "%provider%" --keep-fps --many-faces

rmdir "%USERPROFILE%\.insightface\models\buffalo_l"
rd /s /q "%USERPROFILE%\.insightface"

exit