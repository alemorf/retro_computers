sjasmplus loader1.asm
if errorlevel 1 goto err
sjasmplus loader0.asm
if errorlevel 1 goto err
del loader0.rka
copy /b rkaheader.bin+loader0.bin+rkafooter.bin loader0.rka
goto end
:err
pause
:end