@echo off
cls
..\release\pdp11asm.exe bk0010_miner.asm
if errorlevel 1 goto error
start d:\bin\emu\EMU.exe bk0010_miner.bin
exit
:error
pause
