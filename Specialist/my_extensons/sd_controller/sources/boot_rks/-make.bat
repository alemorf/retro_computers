@echo off
cls
del boot.bin >nul
del bios.bin >nul
tasm -gb -b -85 boot.asm boot.bin >errors.txt
if errorlevel 1 goto err
type errors.txt
tasm -gb -b -85 s.asm s.bin >errors.txt
if errorlevel 1 goto err
type errors.txt
tasm -gb -b -85 e.asm e.bin >errors.txt
if errorlevel 1 goto err
type errors.txt
del errors.txt >nul
copy s.bin+boot.bin+e.bin boot.rks
copy boot.rks \\book\e\boot\boot.rks
if errorlevel 1 goto err
exit
:err
type errors.txt 
pause