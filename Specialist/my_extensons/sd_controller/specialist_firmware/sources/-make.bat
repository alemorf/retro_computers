@echo off
copy /b stdbios_a.bin+stdbios_b.bin+stdbios_c.bin+stdbios_c.bin bios8.rom
copy /b bios8.rom+bios8.rom+bios8.rom+bios8.rom+bios8.rom+bios8.rom+bios8.rom+bios8.rom bios64.rom
exit
:err
type errors.txt 
pause