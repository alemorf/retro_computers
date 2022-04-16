@echo off
cls
del reboot.53248.com >nul
tasm -gb -b -85 reboot.asm reboot.53248.com >errors.txt
if errorlevel 1 goto err
type errors.txt
del errors.txt
copy reboot.53248.com ..\makeRom\reboot.53248.com
exit
:err
type errors.txt 
pause