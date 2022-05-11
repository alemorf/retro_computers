@echo off
cls
..\release\pdp11asm.exe SCALE144.MAC
if errorlevel 1 goto error
start d:\bin\emu\EMU.exe SCALE144.BIN
exit
:error
pause
