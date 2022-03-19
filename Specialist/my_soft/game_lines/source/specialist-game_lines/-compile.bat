@echo off
cls
del lines.asm
..\C8080\c8080.exe lines.c spec_interface.c graph.c keyb.c unmlz.c spec_music.c graph/title.c graph/screen.c graph/balls.c graph/playerD.c graph/player.c graph/playerWin.c graph/kingLose.c >errors.txt
if errorlevel 1 goto err
type errors.txt
del errors.txt >nul
..\C8080\tasm -gb -b -85 lines.asm lines.bin >errors.txt
if errorlevel 1 goto err
-make-rks.js
goto end
:err
type errors.txt
pause
:end