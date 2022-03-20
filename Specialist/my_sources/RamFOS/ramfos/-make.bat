@echo off
cls
del ramfos.bin >nul
tasm -gb -b -85 ramfos.asm ramfos.bin >errors.txt
if errorlevel 1 goto err
type errors.txt
exit
:err
type errors.txt 
pause