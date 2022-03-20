@echo off
cls
del disk-h.64000.com >nul
tasm -gb -b -85 disk-h.asm disk-h.64000.com >errors.txt
if errorlevel 1 goto err
type errors.txt
del errors.txt
def ..\makeRom\disk-h.*.com
copy disk-h.64000.com ..\makeRom\disk-h.64000.com
exit
:err
type errors.txt 
pause