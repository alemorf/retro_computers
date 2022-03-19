@echo off
cls
del errors.txt >nul
del *.mlz >nul
tasm -gb -b -85 starwars.asm starwars.bin >errors.txt
if errorlevel 1 goto err
for %%1 in (film*.txt) do megalz %%1
copy /b starwars.bin+film_0.txt.mlz+film_1.txt.mlz+film_2.txt.mlz+film_3.txt.mlz+film_4.txt.mlz+film_5.txt.mlz+film_6.txt.mlz+film_7.txt.mlz+film_8.txt.mlz+film_9.txt.mlz
-make-rka.js
del starwars.rka
-make-rka.js
goto end
:err
type errors.txt
pause
:end