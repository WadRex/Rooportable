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

:processor_selection
cls
echo POSSIBLE FRAME PROCESSORS:
echo 1. FACE SWAPPER (TAKES 'SOURCE' AND 'TARGET' AS AN INPUT)
echo 2. FACE ENHANCER (TAKES 'TARGET' AS AN INPUT)
set /p "choice=SELECT FRAME PROCESSOR BY TYPING '1' or '2': "
if /i "%choice%"=="1" (
    set "processor=face_swapper"
    cls    
    echo YOU SELECTED "FACE SWAPPER"
) else if /i "%choice%"=="2" (
    set "processor=face_enhancer"
    cls
    echo YOU SELECTED "FACE ENHANCER"
) else (
    goto processor_selection
)

if not exist "%USERPROFILE%\.insightface" (
  mkdir "%USERPROFILE%\.insightface\models"
) else (  
  rd /s /q "%USERPROFILE%\.insightface"
  mkdir "%USERPROFILE%\.insightface\models"
)

mklink /D "%USERPROFILE%\.insightface\models\buffalo_l" "%~dp0Roop\models\buffalo_l"

cd Roop
python .\run.py --execution-provider "%provider%" --keep-fps --many-faces --frame-processor "%processor%"

rmdir "%USERPROFILE%\.insightface\models\buffalo_l"
rd /s /q "%USERPROFILE%\.insightface"

exit