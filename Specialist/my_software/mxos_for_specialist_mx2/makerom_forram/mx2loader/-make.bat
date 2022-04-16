@echo off
cls
del mx2loader.bin >nul
tasm -gb -b -85 mx2loader.asm mx2loader.bin >errors.txt
if errorlevel 1 goto err
type errors.txt
del errors.txt
def ..\makeRom\mx2loader.*.bin
exit
:err
type errors.txt 
pause