@echo off
tasm -gb -b -85 boot.asm boot.rk >errors.txt
if errorlevel 1 goto err
goto end
:err
type errors.txt
pause
:end