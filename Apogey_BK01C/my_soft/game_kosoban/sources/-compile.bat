@echo off
rem c8080\c8080.exe game.c gprint.c
rem if errorlevel 1 goto err
..\c8080\c8080.exe game.c music.c screen.c credits.c interface.c
if errorlevel 1 goto err
c8080\tasm -gb -b -85 game.asm game.bin >errors.txt
if errorlevel 1 goto err
rem sjasmplus game.asm >errors.txt
rem if errorlevel 1 goto err
-make-rka.js
start c:\emu\emu game.rka
goto end
:err
type errors.txt
pause
:end