@echo off
cls
del disk-a.64000.com >nul
tasm -gb -b -85 disk-a.asm disk-a.64000.com >errors.txt
if errorlevel 1 goto err
type errors.txt
del errors.txt
def ..\makeRom\disk-a.*.com
exit
:err
type errors.txt 
pause