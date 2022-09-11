C_FILES=$(wildcard *.c iskra1080/*.c graph/*.c)
H_FILES=$(wildcard *.h iskra1080/*.h graph/*.h)

all: check $(C_FILES) $(H_FILES)
		./c8080/c8080 -Ic8080/include $(C_FILES)

files:
	find . -type f >lines_for_iskra_1080.files

format:
	clang-format -i $(C_FILES) $(H_FILES)

check:
	cppcheck -Ic8080/include --enable=all $(C_FILES) $(H_FILES)

clean:
	rm output.i1080 output.lst output.asm

font.c: font.bin
	xxd -i font.bin font.c

graph/imgTitle.c: ./graph/convert/convert graph/imgTitle.png
	./graph/convert/convert 0 graph/imgTitle.png 0 0x0000FF 0xFFFF00 0x00FFFF

graph/imgScreen.c: ./graph/convert/convert graph/imgScreen.png
	./graph/convert/convert 0 graph/imgScreen.png 0 0x0000FF 0xFFFF00 0xFFFFFF

graph/imgBalls.c: ./graph/convert/convert graph/imgBalls.png
	./graph/convert/convert 1 graph/imgBalls.png 0 0x0000FF 0xFFFF00 0xFFFFFF

graph/imgBoard.c: ./graph/convert/convert graph/imgBoard.png
	./graph/convert/convert 1 graph/imgBoard.png 0 0x0000FF 0xFFFF00 0xFFFFFF

graph/imgPlayer.c: ./graph/convert/convert graph/imgPlayer.png
	./graph/convert/convert 2 graph/imgPlayer.png 0 0x0000FF 0xFFFF00 0xFFFFFF

graph/imgPlayerD.c: ./graph/convert/convert graph/imgPlayerD.png
	./graph/convert/convert 2 graph/imgPlayerD.png 0 0x0000FF 0xFFFF00 0xFFFFFF

graph/imgPlayerWin.c: ./graph/convert/convert graph/imgPlayerWin.png
	./graph/convert/convert 2 graph/imgPlayerWin.png 0 0x0000FF 0xFFFF00 0xFFFFFF

graph/imgKingLose.c: ./graph/convert/convert graph/imgKingLose.png
	./graph/convert/convert 2 graph/imgKingLose.png 0 0x0000FF 0xFFFF00 0xFFFFFF



