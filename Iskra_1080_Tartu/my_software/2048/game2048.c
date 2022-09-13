#define ESC_HOME_CURSOR  "\x1B\x3D\x20\x20"
#define ESC_CLEAR_SCREEN "\x1B\x2A"

//#pragma output noprotectmsdos
//#pragma output nostreams
//#pragma output nofileio
//#pragma output noredir

/*
 ============================================================================
 Name        : 2048.c
 Author      : Maurits van der Schee
 Description : Console version of the game "2048" for GNU/Linux
 ============================================================================
 */

#define _XOPEN_SOURCE 500

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdbool.h>
#include <stdint.h>
#include <time.h>

#define SIZE 4
uint32_t score=0;
uint8_t board[SIZE][SIZE];

void drawBoard() {
	uint8_t x,y;
	uint8_t t;
    printf(ESC_HOME_CURSOR);

    printf("2048.c %23d pts",score);
    for (y=0;y<SIZE;y++) {
        printf("\n\n\n\n");
        for (x=0;x<SIZE;x++) {
            if (board[x][y]!=0) {
                char s[8];
                snprintf(s,8,"%u",1<<board[x][y]);
                t = 7-strlen(s);
                printf("|%*s%s%*s",t-t/2,"",s,t/2,"");
            } else {
                printf("|       ");
            }
        }
    }
    printf("\n\n\n\n");
}

void prepareScreen() {
    uint8_t x,y,i;
    printf(ESC_CLEAR_SCREEN);

    printf("2048.c %17d pts\n\n",score);
    for (x=0;x<SIZE;x++)
        printf("+-------");
    printf("+\n");
    for (y=0;y<SIZE;y++) {
        for (i=0;i<3;i++) {
            for (x=0;x<SIZE;x++)
                printf("|       ");
            printf("|\n");
        }
        for (x=0;x<SIZE;x++)
            printf("+-------");
        printf("+\n");
    }
    printf("\n          w,a,s,d or r,q       \n");
    drawBoard();
}

uint8_t findTarget(uint8_t array[SIZE],uint8_t x,uint8_t stop) {
	uint8_t t;
	// if the position is already on the first, don't evaluate
	if (x==0) {
		return x;
	}
	for(t=x-1;;t--) {
		if (array[t]!=0) {
			if (array[t]!=array[x]) {
				// merge is not possible, take next position
				return t+1;
			}
			return t;
		} else {
			// we should not slide further, return this one
			if (t==stop) {
				return t;
			}
		}
	}
	// we did not find a
	return x;
}

bool slideArray(uint8_t array[SIZE]) {
	bool success = false;
	uint8_t x,t,stop=0;

	for (x=0;x<SIZE;x++) {
		if (array[x]!=0) {
			t = findTarget(array,x,stop);
			// if target is not original position, then move or merge
			if (t!=x) {
				// if target is zero, this is a move
				if (array[t]==0) {
					array[t]=array[x];
				} else if (array[t]==array[x]) {
					// merge (increase power of two)
					array[t]++;
					// increase score
					score+=(uint32_t)1<<array[t];
					// set stop to avoid double merge
					stop = t+1;
				}
				array[x]=0;
				success = true;
			}
		}
	}
	return success;
}

void rotateBoard() {
	uint8_t i,j,n=SIZE;
	uint8_t tmp;
	for (i=0; i<n/2; i++) {
		for (j=i; j<n-i-1; j++) {
			tmp = board[i][j];
			board[i][j] = board[j][n-i-1];
			board[j][n-i-1] = board[n-i-1][n-j-1];
			board[n-i-1][n-j-1] = board[n-j-1][i];
			board[n-j-1][i] = tmp;
		}
	}
}

bool moveUp() {
	bool success = false;
	uint8_t x;
	for (x=0;x<SIZE;x++) {
		success |= slideArray(board[x]);
	}
	return success;
}

bool moveLeft() {
	bool success;
	rotateBoard();
	success = moveUp();
	rotateBoard();
	rotateBoard();
	rotateBoard();
	return success;
}

bool moveDown() {
	bool success;
	rotateBoard();
	rotateBoard();
	success = moveUp();
	rotateBoard();
	rotateBoard();
	return success;
}

bool moveRight() {
	bool success;
	rotateBoard();
	rotateBoard();
	rotateBoard();
	success = moveUp();
	rotateBoard();
	return success;
}

bool findPairDown() {
	bool success = false;
	uint8_t x,y;
	for (x=0;x<SIZE;x++) {
		for (y=0;y<SIZE-1;y++) {
			if (board[x][y]==board[x][y+1]) return true;
		}
	}
	return success;
}

uint8_t countEmpty() {
	uint8_t x,y;
	uint8_t count=0;
	for (x=0;x<SIZE;x++) {
		for (y=0;y<SIZE;y++) {
			if (board[x][y]==0) {
				count++;
			}
		}
	}
	return count;
}

bool gameEnded() {
	bool ended = true;
	if (countEmpty()>0) return false;
	if (findPairDown()) return false;
	rotateBoard();
	if (findPairDown()) ended = false;
	rotateBoard();
	rotateBoard();
	rotateBoard();
	return ended;
}

void addRandom() {
	static bool initialized = false;
	uint8_t x,y;
	uint8_t r,len=0;
	uint8_t n,list[SIZE*SIZE][2];

	if (!initialized) {
		//srand(time(NULL));
		initialized = true;
	}

	for (x=0;x<SIZE;x++) {
		for (y=0;y<SIZE;y++) {
			if (board[x][y]==0) {
				list[len][0]=x;
				list[len][1]=y;
				len++;
			}
		}
	}

	if (len>0) {
		r = rand()%len;
		x = list[r][0];
		y = list[r][1];
		n = (rand()%10)/9+1;
		board[x][y]=n;
	}
}

void initBoard() {
	uint8_t x,y;
	for (x=0;x<SIZE;x++) {
		for (y=0;y<SIZE;y++) {
			board[x][y]=0;
		}
	}
    addRandom();
    addRandom();
    prepareScreen();
    score = 0;
    drawBoard();
}

int test() {
	uint8_t array[SIZE];
	// these are exponents with base 2 (1=2 2=4 3=8)
	static const uint8_t data[] = {
		0,0,0,1,	1,0,0,0,
		0,0,1,1,	2,0,0,0,
		0,1,0,1,	2,0,0,0,
		1,0,0,1,	2,0,0,0,
		1,0,1,0,	2,0,0,0,
		1,1,1,0,	2,1,0,0,
		1,0,1,1,	2,1,0,0,
		1,1,0,1,	2,1,0,0,
		1,1,1,1,	2,2,0,0,
		2,2,1,1,	3,2,0,0,
		1,1,2,2,	2,3,0,0,
		3,0,1,1,	3,2,0,0,
		2,0,1,1,	2,2,0,0
	};
	const uint8_t *in,*out;
	uint8_t t,tests;
	uint8_t i;
	bool success = true;

	tests = (sizeof(data)/sizeof(data[0]))/(2*SIZE);
	for (t=0;t<tests;t++) {
		in = data+t*2*SIZE;
		out = in + SIZE;
		for (i=0;i<SIZE;i++) {
			array[i] = in[i];
		}
		slideArray(array);
		for (i=0;i<SIZE;i++) {
			if (array[i] != out[i]) {
				success = false;
			}
		}
		if (success==false) {
			for (i=0;i<SIZE;i++) {
				printf("%d ",in[i]);
			}
			printf("=> ");
			for (i=0;i<SIZE;i++) {
				printf("%d ",array[i]);
			}
			printf("expected ");
			for (i=0;i<SIZE;i++) {
				printf("%d ",in[i]);
			}
			printf("=> ");
			for (i=0;i<SIZE;i++) {
				printf("%d ",out[i]);
			}
			printf("\n");
			break;
		}
	}
	if (success) {
		printf("All %u tests executed successfully\n",tests);
	}
	return !success;
}

int main(int argc, char *argv[]) {
	asm {
		ld sp, 9000h
	}
	char c;
	bool success;

    // TODO: if (argc == 2 && strcmp(argv[1],"test")==0) {
    // TODO: 	return test();
    // TODO: }

	initBoard();
	while (true) {
		c=getchar();
		switch(c) {
			case 97:	// 'a' key
			case 104:	// 'h' key
			case 68:	// left arrow
				success = moveLeft();  break;
			case 100:	// 'd' key
			case 108:	// 'l' key
			case 67:	// right arrow
				success = moveRight(); break;
			case 119:	// 'w' key
			case 107:	// 'k' key
			case 65:	// up arrow
				success = moveUp();    break;
			case 115:	// 's' key
			case 106:	// 'j' key
			case 66:	// down arrow
				success = moveDown();  break;
			default: success = false;
		}
		if (success) {
			drawBoard();
			sleep(2);
			addRandom();
			drawBoard();
			if (gameEnded()) {
				printf("            GAME OVER          \n");
				break;
			}
		}
		if (c=='q') {
			printf("            QUIT? (y/n)         \n");
			c=getchar();
			if (c=='y') {
				break;
			}
			prepareScreen();
		}
		if (c=='r') {
			printf("          RESTART? (y/n)       \n");
			c=getchar();
			if (c=='y') {
				initBoard();
			}
			prepareScreen();
		}
	}

	printf(ESC_CLEAR_SCREEN);

	return EXIT_SUCCESS;
}
