@echo off
cls
del shell.asm
..\C8080\c8080.exe shell.c graph.c keyb.c cmd_copymove.c cmd_run.c cmd_mkdir.c cmd_freespace.c cmd_delete.c dlg.c >errors.txt
if errorlevel 1 goto err
type errors.txt
del errors.txt >nul
..\C8080\tasm -gb -b -85 shell.asm shell.rks >errors.txt
if errorlevel 1 goto err
rem copy shell.rks \\book\e\boot\shell.rks
goto end
:err
type errors.txt
pause
:end