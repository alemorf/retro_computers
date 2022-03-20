@echo off
cls
del sdbios.rks >nul
tasm -gb -b -85 sdbios.asm sdbios.rks >errors.txt
if errorlevel 1 goto err
type errors.txt 
del errors.txt >nul
copy sdbios.rks \\book\e\boot\sdbios.rks
if errorlevel 1 goto err
exit
:err
type errors.txt 
pause