@echo off
cls
del romfnt.0.com >nul
tasm -gb -b -85 romfnt.asm romfnt.0.com >errors.txt
if errorlevel 1 goto err
type errors.txt
del errors.txt
copy romfnt.0.com ..\makeRom\romfnt.0.com
exit
:err
type errors.txt 
pause