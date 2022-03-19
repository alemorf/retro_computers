sjasmplus unmlz.asm
if errorlevel 1 goto err
sjasmplus menu.asm
if errorlevel 1 goto err
goto end
:err
pause
:end