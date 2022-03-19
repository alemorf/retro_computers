..\c8080\c8080.exe lines.c balls.c balls2.c gameScreen.c gameScreen2.c intro.c king.c king2.c kingLose.c kingLose2.c player.c player2.c playerWin.c playerWin2.c lvov_interface.c lvov_music.c
if errorlevel 1 goto err
..\c8080\tasm -gb -b -85 lines.asm lines.lvt >errors.txt
if errorlevel 1 goto err
goto end
:err
type errors.txt
pause
:end