@echo off
cls
del sdbios.rk >nul
tasm -gb -b -85 sdbios.asm sdbios.bin >errors.txt
if errorlevel 1 goto err
type errors.txt 
del errors.txt >nul
if errorlevel 1 goto err
-make-rka.js
exit
:err
type errors.txt 
pause