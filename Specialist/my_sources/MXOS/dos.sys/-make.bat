@echo off
cls

rem сдюкемхе пегскэрхпсчыху тюикнб

del dos.49152.sys >nul
del dos.49152.mlz >nul
del dos.57344.sys >nul
del unpacker0.bin >nul

rem йнлохкъжхъ ня

tasm -gb -b -85 dos.asm dos.49152.sys >errors.txt
if errorlevel 1 goto err
type errors.txt
del errors.txt
del ..\makeRom\DOS.*.SYS

rem дкъ сднаярбю

rem copy dos.49152.sys ..\makeRom\dos.49152.sys
rem exit

rem йнлохкъжхъ пюяоюйнбыхйю

tasm -gb -b -85 unpacker.asm unpacker0.bin >errors.txt
if errorlevel 1 goto err
type errors.txt
del errors.txt

rem яфюрхе

megalz dos.49152.sys dos.49152.mlz
if errorlevel 1 goto err
copy /b unpacker0.bin+dos.49152.mlz dos.57344.SYS

rem дкъ сднаярбю

copy dos.57344.SYS ..\makeRom\dos.57344.SYS

exit
:err
type errors.txt 
pause