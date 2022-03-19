@echo off
cls
del shell.asm
REM ..\..\C8080\c8080.exe shell.c cmd_copymove.c cmd_new.c cmd_freespace.c cmd_delete.c cmd_sel.c interface.c fs.c>errors.txt
..\..\C8080\c8080.exe shell.c cmd_copymove.c cmd_new.c cmd_freespace.c cmd_delete.c cmd_sel.c interface.c>errors.txt
if errorlevel 1 goto err
type errors.txt
del errors.txt >nul
..\..\C8080\tasm -gb -b -85 shell.asm shell.bin >errors.txt
if errorlevel 1 goto err
-make-rka.js
del shell.rka
copy shell.rk shell.rka
goto end
:err
type errors.txt
pause
:end