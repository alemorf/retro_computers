@echo off
cls
del nc.53248.com >nul
tasm -gb -b -85 nc.asm nc.53248.com >errors.txt
if errorlevel 1 goto err
type errors.txt
del errors.txt
copy nc.53248.com ..\makeRom\nc.53248.com
exit
:err
type errors.txt 
pause