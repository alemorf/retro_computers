@echo off
cls
del errors.txt >nul
tasm -gb -b -85 test.asm test.bin >errors.txt
if errorlevel 1 goto err
-make-rka.js
del test.rka
-make-rka.js
goto end
:err
type errors.txt
pause
:end