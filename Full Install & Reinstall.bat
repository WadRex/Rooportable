@echo off

mkdir "Temporary Files"
bitsadmin /transfer "Download Miniconda" /download /priority normal "https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe" "%~dp0\Temporary Files\Miniconda3-latest-Windows-x86_64.exe"
start /wait "" ".\Temporary Files\Miniconda3-latest-Windows-x86_64.exe" /InstallationType=JustMe /AddToPath=0 /RegisterPython=0 /S /D=%cd%\Miniconda
rd /s /q ".\Temporary Files"

