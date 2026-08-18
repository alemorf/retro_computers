' QBASIC CGA SOKOBAN
' (C) 2026 ALEKSEY MOROZOV
' AS IS

DECLARE SUB GETIMG (IMG() AS LONG)
DECLARE SUB PUTIMG (X AS INTEGER, Y AS INTEGER, N AS INTEGER)
DECLARE SUB DRAWCELL (X AS INTEGER, Y AS INTEGER)
DECLARE FUNCTION CHECKDONE% ()
DECLARE SUB CENTER (Y AS INTEGER, TEXT$)
DEFINT A-Z

SCREEN 1

CONST MAXX = 7, MAXY = 7
CONST IMGSIZE = 16
CONST PLAYER = 2, BOX = 3, TARGET = 4, BOXTARGET = 5

DIM SHARED MAP(MAXX, MAXY) AS INTEGER
DIM SHARED MAP2(MAXX, MAXY) AS INTEGER
DIM SHARED IMG0(IMGSIZE) AS LONG
DIM SHARED IMG1(IMGSIZE) AS LONG
DIM SHARED IMG2(IMGSIZE) AS LONG
DIM SHARED IMG3(IMGSIZE) AS LONG
DIM SHARED IMG4(IMGSIZE) AS LONG
DIM SHARED IMG5(IMGSIZE) AS LONG

DATA "                "
DATA "                "
DATA "                "
DATA "                "
DATA "                "
DATA "                "
DATA "                "
DATA "                "
DATA "                "
DATA "                "
DATA "                "
DATA "                "
DATA "                "
DATA "                "
DATA "                "
DATA "                "

DATA "2222#2222222#222"
DATA "1111#2111111#211"
DATA "1111#2111111#211"
DATA "################"
DATA "#2222222#2222222"
DATA "#2111111#2111111"
DATA "#2111111#2111111"
DATA "################"
DATA "2222#2222222#222"
DATA "1111#2111111#211"
DATA "1111#2111111#211"
DATA "################"
DATA "#2222222#2222222"
DATA "#2111111#2111111"
DATA "#2111111#2111111"
DATA "################"

DATA "                "
DATA "     #######    "
DATA "    #########   "
DATA "   ##..###..##  "
DATA "   #.........#  "
DATA "   #..#...#..#  "
DATA "   #..#...#..#  "
DATA "    #.......#   "
DATA "   #1#######1#  "
DATA "  #11111#11111# "
DATA "  #1#111#111#1# "
DATA "   ##1111111##  "
DATA "     #######    "
DATA "    #### ####   "
DATA "    ###   ###   "
DATA "                "

DATA "################"
DATA "#..............#"
DATA "#.############.#"
DATA "#.#..#....#..#.#"
DATA "#.#...#..#...#.#"
DATA "#.##...##...##.#"
DATA "#.#.#...#..#.#.#"
DATA "#.#..#...##..#.#"
DATA "#.#..##...#..#.#"
DATA "#.#.#..#...#.#.#"
DATA "#.##...##...##.#"
DATA "#.#...#..#...#.#"
DATA "#.#..#....#..#.#"
DATA "#.############.#"
DATA "#..............#"
DATA "################"

DATA "                "
DATA "                "
DATA "   11      11   "
DATA "  1111    1111  "
DATA "  1111    1111  "
DATA "   1111  1111   "
DATA "    11111111    "
DATA "     111111     "
DATA "     111111     "
DATA "    11111111    "
DATA "   1111  1111   "
DATA "  1111    1111  "
DATA "  1111    1111  "
DATA "   11      11   "
DATA "                "
DATA "                "

DATA "################"
DATA "#11111111111111#"
DATA "#1############1#"
DATA "#1#11#....#11#1#"
DATA "#1#111#..#111#1#"
DATA "#1##111##111##1#"
DATA "#1#.#111#11#.#1#"
DATA "#1#..#111##..#1#"
DATA "#1#..##111#..#1#"
DATA "#1#.#11#111#.#1#"
DATA "#1##111##111##1#"
DATA "#1#111#..#111#1#"
DATA "#1#11#....#11#1#"
DATA "#1############1#"
DATA "#11111111111111#"
DATA "################"

FOR N = 0 TO 5
  FOR Y = 0 TO IMGSIZE - 1
    READ A$
    FOR X = 0 TO IMGSIZE - 1
      PSET (X, Y), (ASC(MID$(A$, X + 1, 1)) + 1) MOD 4
    NEXT
  NEXT
  SELECT CASE N
    CASE 0: GETIMG IMG0()
    CASE 1: GETIMG IMG1()
    CASE 2: GETIMG IMG2()
    CASE 3: GETIMG IMG3()
    CASE 4: GETIMG IMG4()
    CASE 5: GETIMG IMG5()
  END SELECT
NEXT

FIRSTLEVEL:
RESTORE LEVELS
LEVEL = 0

NEXTLEVEL:
LEVEL = LEVEL + 1
FOR Y = 0 TO MAXY
  READ A$
  IF A$ = "" THEN GOTO FIRSTLEVEL
  FOR X = 0 TO MAXX
    MAP2(X, Y) = ASC(MID$(A$, X + 1, 1)) MOD 16
  NEXT
NEXT

RESTARTLEVEL:
FOR Y = 0 TO MAXY
  FOR X = 0 TO MAXX
    D = MAP2(X, Y)
    IF D = TARGET THEN D = 0
    IF D = PLAYER THEN PX = X: PY = Y
    MAP(X, Y) = D
  NEXT
NEXT

CLS
CENTER 1, "SOKOBAN"
CENTER 2, "LEVEL" + STR$(LEVEL)
CENTER 25, "2026 ALEMORF ESC-EXIT SPACE-RESTART"
FOR Y = 0 TO MAXY
  FOR X = 0 TO MAXX
    DRAWCELL X, Y
  NEXT
NEXT

DO
  PX1 = PX: PY1 = PY
  SELECT CASE INKEY$
    CASE CHR$(27): SCREEN 0: END
    CASE " ": GOTO RESTARTLEVEL
    CASE CHR$(0) + "H": PY1 = PY1 - 1
    CASE CHR$(0) + "P": PY1 = PY1 + 1
    CASE CHR$(0) + "K": PX1 = PX1 - 1
    CASE CHR$(0) + "M": PX1 = PX1 + 1
  END SELECT

  ' MOVE BOX
  IF MAP(PX1, PY1) = BOX THEN
    PX2 = PX1 * 2 - PX
    PY2 = PY1 * 2 - PY
    IF MAP(PX2, PY2) = 0 THEN
      MAP(PX2, PY2) = BOX
      MAP(PX1, PY1) = 0
      DRAWCELL PX2, PY2
    END IF
  END IF

  ' MOVE PLAYER
  IF MAP(PX1, PY1) = 0 THEN
    MAP(PX, PY) = 0
    DRAWCELL PX, PY
    PX = PX1: PY = PY1
    MAP(PX, PY) = PLAYER
    DRAWCELL PX, PY
    
    IF CHECKDONE THEN
      PLAY "ML MB L16 O1 C E G A"
      GOTO NEXTLEVEL
    END IF
  END IF
LOOP

LEVELS:
DATA "..111..."
DATA "..141..."
DATA "..1 1111"
DATA "1113 341"
DATA "14 32111"
DATA "111131.."
DATA "...141.."
DATA "...111.."

DATA "11111111"
DATA "1 4   21"
DATA "1   43 1"
DATA "111 3111"
DATA "..1  1.."
DATA "..1  1.."
DATA "..1111.."
DATA "........"

DATA "....1111"
DATA "..111  1"
DATA "111    1"
DATA "14  3121"
DATA "1443 3 1"
DATA "1114 3 1"
DATA "..111  1"
DATA "....1111"

DATA ""

SUB CENTER (Y AS INTEGER, TEXT$)
  LOCATE Y, (40 - LEN(TEXT$)) \ 2
  PRINT TEXT$;
END SUB

FUNCTION CHECKDONE
  CHECKDONE = 0
  FOR Y = 0 TO MAXY
    FOR X = 0 TO MAXX
      IF MAP2(X, Y) = TARGET AND MAP(X, Y) <> BOX THEN EXIT FUNCTION
    NEXT
  NEXT
  CHECKDONE = 1
END FUNCTION

SUB DRAWCELL (X AS INTEGER, Y AS INTEGER)
  C = MAP(X, Y)
  IF MAP2(X, Y) = TARGET THEN
    IF C = 0 THEN C = TARGET
    IF C = BOX THEN C = BOXTARGET
  END IF
  PUTIMG 96 + X * IMGSIZE, 32 + Y * IMGSIZE, C
END SUB

DEFSNG A-Z
SUB GETIMG (IMG() AS LONG)
  GET (0, 0)-(IMGSIZE - 1, IMGSIZE - 1), IMG
END SUB

SUB PUTIMG (X AS INTEGER, Y AS INTEGER, N AS INTEGER)
  SELECT CASE N
    CASE 0: PUT (X, Y), IMG0, PSET
    CASE 1: PUT (X, Y), IMG1, PSET
    CASE 2: PUT (X, Y), IMG2, PSET
    CASE 3: PUT (X, Y), IMG3, PSET
    CASE 4: PUT (X, Y), IMG4, PSET
    CASE 5: PUT (X, Y), IMG5, PSET
  END SELECT
END SUB

