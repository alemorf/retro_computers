sjasmplus loader0.asm
if errorlevel 1 goto err
sjasmplus unmlz.asm
if errorlevel 1 goto err
sjasmplus menu.asm
if errorlevel 1 goto err
del unmlz.bin
goto end
:err
pause
:end