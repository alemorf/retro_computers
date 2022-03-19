10 CLS 4:SCRN 0,3:PRINT "tarakanxi bega":A=RND
20 INPUT "na kakogo tarakana wy stawite  ";T:IF T>5 GOTO 20
30 PRINT CHR$(31);"*******     tarakanxi  bega       *******"
40 PRINT "-----------------------------------------"
50 FOR I=1 TO 5:N(I)=2:NEXT:GOSUB 100
60 PRINT "-----------------------------------------"
70 FOR I=1 TO 5+T:N(I)=N(I)+RND(A):OUT 242,8:OUT 242,0:NEXT
80 PRINT CHR$(12):PRINT:GOSUB 100:PRINT:C=C+1
85 IF C/2=INT(C/2) THEN PRINT "!dawaj wasq!" ELSE PRINT "            "
86 FOR I=1 TO 5
90 IF N(I)=>39 THEN 150 ELSE NEXT:RANDOMIZE A:GOTO 70
100 PRINT "1";TAB(N(1))"O<";TAB(42)"f"
110 PRINT "2";TAB(N(2))"O<";TAB(42)"i"
120 PRINT "3";TAB(N(3))"*<";TAB(42)"n"
130 PRINT "4";TAB(N(4))"O<";TAB(42)"i"
140 PRINT "5";TAB(N(5))"O<";TAB(42)"{":RETURN
150 PRINT CHR$(7);CHR$(7):PRINT
160 PRINT "wyigral tarakan so startowym nomerom ";I
170 FOR J=1 TO 2000:NEXT:IF I=T GOTO 190 ELSE PRINT "ha-ha"
180 PRINT "e}e razok poprobuem":GOTO 20
190 PRINT "wa{a wzqla":GOTO 180
