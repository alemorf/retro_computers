C_FILES=iskra1080/drawimage.c iskra1080/drawtext.c iskra1080/keyboard.c iskra1080/palette.c \
	iskra1080/playtone.c iskra1080/fillrect.c\
	graph/imgTitle.c graph/imgScreen.c graph/imgBalls.c graph/imgBoard.c\
	graph/imgPlayer.c graph/imgPlayerWin.c graph/imgPlayerD.c graph/imgKingLose.c\
	font.c lines.c path.c hal.c music.c unmlz.c

H_FILES=iskra1080/drawimage.h iskra1080/drawtext.h iskra1080/keyboard.h iskra1080/palette.h\
	iskra1080/playtone.h\
	graph/imgTitle.h graph/imgScreen.h graph/imgBalls.h graph/imgBoard.h\
	graph/imgPlayer.h graph/imgPlayerWin.h graph/imgPlayerD.h graph/imgKingLose.h\
	chargen.h lines.h hal.h music.h unmlz.h

all: $(C_FILES) $(H_FILES)
		./c8080/c8080 -Ic8080/include $(C_FILES)

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



