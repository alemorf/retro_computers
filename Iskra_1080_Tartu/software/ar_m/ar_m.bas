10 REM************************************************
20 REM*     programma proverki znanij matematiki    * 
30 REM*            u uchenikov mladshih klassov      *
40 REM******************************************j*****
50 CLS:PRINT:PRINT
60 LOCATE 15,6:INPUT "К╫к тебя зовут ?";I$:PRINT:PRINT
70 PRINT I$;" , я хочу проверить твои знания по арифметике."
80 PRINT"Я буду предлагать примеры , а ты постарайся их решить."
90 PRINT"Если готов, нажми на любую клавишу  "
100 A1=USR(51187) 
110 X=1:W=0
120 CLS:PRINT:PRINT
130 PRINT TAB(15);"ПОМНИ!"
140 PRINT"Если при ответе ошибешься и случайно нажмешь "
150 PRINT"не ту клавишу,то нажми клавишу 'DEL',а затем - нужную."
170 PRINT"После набора всего ответа нажми клавишу '";CHR$(251);CHR$(169);"'":PRINT
180 R=ABS(INT(RND(1)*20-10))
190 IF R=0 OR R=1 THEN GOTO 180
200 G=ABS(INT(RND(1)*20-10))
210 IF G=0 OR G=1 THEN GOTO 200
220 KL=INT(RND(1)*5)
230 IF KL=0 THEN GOTO 220
240 ON KL GOSUB 510, 550, 600, 630
250 PRINT:PRINT I$;",сколько будет";P;U$;R;" = ";
260 INPUT D
270 IF D=Q THEN GOTO 370
280 LOCATE 15,12:PRINT"НЕПРАВИЛЬНО !!!":PRINT
290 PRINT"Тебе,";I$;",надо подумать.":PRINT
300 PRINT I$;",сколько будет ";P;U$;R;" = ";
310 INPUT D:PRINT
320 IF D=Q THEN GOTO 370
330 PRINT"Плохо,";I$;"!Ты не смог решить этот пример."
340 PRINT"Вот правильное решение:"
350 PRINT
355 PRINT TAB(8);P;U$;R;" = ";Q:PRINT
360 GOTO 390
370 W=W+1
380 LOCATE 15,12:PRINT"М О Л О Д Е Ц  !!!":PRINT:PRINT TAB(15);I$;"! Правильно !":PRINT
390 IF X=10 THEN GOTO 450
400 X=X+1
410 PRINT TAB(15);"Реши еще пример                  "
420 PRINT"Если готов,то нажми любую клавишу "
430 A1=USR(51187)
440 GOTO 120
450 PRINT:PRINT
460 IF W=10 THEN PRINT"Молодец ,";I$;",ты знаешь арифметику на пять!"
470 IF W=8 OR W=9 THEN  PRINT"Молодец ,";I$;",ты знаешь арифметику на 4 !" 
480 IF W=6 OR W=7 THEN  PRINT I$;",ты знаешь арифметику на 3 ." 
490 IF W&lt;6 THEN PRINT I$;",ты плохо знаешь арифметику." 
500 STOP
510 U$="прибавить"
520 G=G*3:R=R*3
530 P=G:Q=G+R
540 RETURN
550 U$="отнять"
560 IF R THEN G=G+3
570 G=G*3:R=R*3
580 IF G&lt;R THEN G=G:G=R:R=Q
590 P=G:Q=G-R:RETURN
600 U$="умножить на " 
610 P=G:Q=G*R
620 RETURN
630 U$="разделить на "   
640 P=G*R:Q=G
650 RETURN
660 END