@echo off
cls
del loader.bin >nul
del bios8.bin >nul
del bios64.bin >nul
tasm -gb -b -85 loader.asm loader.bin >errors.txt
if errorlevel 1 goto err
type errors.txt 
del errors.txt >nul
copy /b stdbios_a_corrected.bin+stdbios_b.bin+stdbios_c.bin+loader.bin bios8.rom
copy /b bios8.rom+bios8.rom+bios8.rom+bios8.rom+bios8.rom+bios8.rom+bios8.rom+bios8.rom bios64.rom
exit
:err
type errors.txt 
pause