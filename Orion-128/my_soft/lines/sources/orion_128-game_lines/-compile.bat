@echo off
cls
del lines.asm
del lines$.bin
del lines$.bru
..\C8080\c8080.exe lines.c orion_interface.c orion_graph.c unmlz.c orion_music.c graph/title.c graph/screen.c graph/balls.c graph/playerD.c graph/player.c graph/playerWin.c graph/kingLose.c graph/cursor.c >errors.txt
if errorlevel 1 goto err
type errors.txt
del errors.txt >nul
..\C8080\tasm -gb -b -85 lines.asm lines$.bin >errors.txt
if errorlevel 1 goto err
-make-bru.js
if errorlevel 1 goto err
del errors.txt
del makerom\vc$.bru
copy lines$.bru makerom\vc$.bru
cd makeRom
-makeRom.js
cd ..
goto end
:err
type errors.txt
pause
:end