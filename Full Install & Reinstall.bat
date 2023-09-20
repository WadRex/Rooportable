@echo off

if not "%1"=="Administrator" (
  powershell -Command "Start-Process cmd.exe -ArgumentList '/k cd /d %~dp0 & call "\"Full Install & Reinstall.bat"\" Administrator' -Verb RunAs"
  exit
)

cls
title "Full Install & Reinstall - Warning"
mode con:cols=71 lines=12
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

cls
title "Full Install & Reinstall - In Progress"
mode con:cols=120 lines=30
color 7
echo Starting Installation / Reinstallation

for %%F in ("%~dp0*.*") do (
    if not "%%~nxF"=="Full Install & Reinstall.bat" if not "%%~nxF"=="Launch Roop.bat" if not "%%~nxF"=="README.md" del "%%F"
)
for /d %%D in ("%~dp0*") do (
    if /i not "%%~nxD"==".git" rd /s /q "%%D"
)

mkdir "Temporary Files"
bitsadmin /transfer "Download Microsoft Visual C++ Redistributable" /download /priority normal "https://aka.ms/vs/17/release/vc_redist.x64.exe" "%~dp0\Temporary Files\vc_redist.x64.exe"
start /wait "" ".\Temporary Files\vc_redist.x64.exe" /install /quiet /norestart
rd /s /q ".\Temporary Files"

mkdir "Temporary Files"
bitsadmin /transfer "Download Miniconda" /download /priority normal "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe" "%~dp0\Temporary Files\Miniconda3-latest-Windows-x86_64.exe"
start /wait "" ".\Temporary Files\Miniconda3-latest-Windows-x86_64.exe" /InstallationType=JustMe /AddToPath=0 /RegisterPython=0 /S /D=%cd%\Miniconda
rd /s /q ".\Temporary Files"

echo y | .\Miniconda\Scripts\conda.exe create --prefix .\Miniconda\envs python=3.10
CALL .\Miniconda\Scripts\activate.bat .\Miniconda\envs

echo y | .\Miniconda\Scripts\conda.exe install git==2.41.0 -c conda-forge
echo y | .\Miniconda\Scripts\conda.exe install ffmpeg==6.0.0 -c conda-forge
echo y | .\Miniconda\Scripts\conda.exe install cudatoolkit==11.8.0 -c conda-forge

git clone https://github.com/s0md3v/roop.git Roop
git -C Roop checkout 43a8d9f7f371d083852183ea752ef8cdd944dab3

if exist ".\Roop\roop\core_temporary.py" del /f /q ".\Roop\roop\core_temporary.py"
for /f "delims=: tokens=1,*" %%a in ('findstr /n .* ".\Roop\roop\core.py"') do (
    if "%%a"=="141" (
        echo.#%%b >>".\Roop\roop\core_temporary.py"
    ) else if "%%a"=="142" (
        echo.#%%b >>".\Roop\roop\core_temporary.py"
    ) else if "%%a"=="156" (
        echo.#%%b >>".\Roop\roop\core_temporary.py"
    ) else if "%%a"=="157" (
        echo.#%%b >>".\Roop\roop\core_temporary.py"
    ) else (
        echo.%%b >>".\Roop\roop\core_temporary.py"
    )
)
move /y ".\Roop\roop\core_temporary.py" ".\Roop\roop\core.py"

if exist ".\Roop\roop\ui_temporary.py" del /f /q ".\Roop\roop\ui_temporary.py"
for /f "delims=: tokens=1,*" %%a in ('findstr /n .* ".\Roop\roop\ui.py"') do (
    if "%%a"=="253" (
        echo.#%%b >>".\Roop\roop\ui_temporary.py"
    ) else if "%%a"=="254" (
        echo.#%%b >>".\Roop\roop\ui_temporary.py"
    ) else (
        echo.%%b >>".\Roop\roop\ui_temporary.py"
    )
)
move /y ".\Roop\roop\ui_temporary.py" ".\Roop\roop\ui.py"

mkdir "Temporary Files"
bitsadmin /transfer "Download InsightFace Pre-Built Wheel" /download /priority normal "https://github.com/WadRex/Rooportable/releases/download/insightface-0.7.3-cp310-cp310-win_amd64.whl/insightface-0.7.3-cp310-cp310-win_amd64.whl" "%~dp0\Temporary Files\insightface-0.7.3-cp310-cp310-win_amd64.whl"
echo y | pip install ".\Temporary Files\insightface-0.7.3-cp310-cp310-win_amd64.whl"
rd /s /q ".\Temporary Files"

echo y | pip install -r ".\Roop\requirements.txt"

CALL conda.bat deactivate

mkdir "Temporary Files"
bitsadmin /transfer "Download 'bufallo' Model" /download /priority normal "https://github.com/deepinsight/insightface/releases/download/v0.7/buffalo_l.zip" "%~dp0\Temporary Files\buffalo_l.zip"
mkdir ".\Roop\models\buffalo_l"
tar -xf ".\Temporary Files\buffalo_l.zip" -C ".\Roop\models\buffalo_l"
rd /s /q ".\Temporary Files"

bitsadmin /transfer "Download 'inswapper' Model" /download /priority normal "https://github.com/WadRex/Rooportable/releases/download/inswapper_128.onnx/inswapper_128.onnx" "%~dp0\Roop\models\inswapper_128.onnx"

bitsadmin /transfer "Download 'GFPGAN' Model" /download /priority normal "https://github.com/WadRex/Rooportable/releases/download/GFPGANv1.4.pth/GFPGANv1.4.pth" "%~dp0\Roop\models\GFPGANv1.4.pth"

cls
title "Full Install & Reinstall - Completed"
mode con:cols=71 lines=9
color 2
echo  =====================================================================
echo                               [COMPLETED]
echo.
echo               The installation has successfully completed.
echo.
echo          This window will close automatically after 10 seconds.
echo.
echo  =====================================================================
timeout /t 10 /nobreak > nul
if "%2"=="Launcher" (
  powershell -Command "Start-Process cmd.exe -ArgumentList '/k cd /d %~dp0 & call "\"Launch Roop.bat"\" Administrator Launcher' -Verb RunAs"
)
exit

:terminate
cls
title "Full Install & Reinstall - Terminated"
mode con:cols=71 lines=11
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