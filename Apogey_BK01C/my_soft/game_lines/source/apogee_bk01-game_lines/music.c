#define C  1
#define D  2
#define E  3
#define F  4
#define G  5
#define A  6
#define C2 7

uint musicFreq[1] = { 
  1300000/262,
  1300000/294,
  1300000/330,
  1300000/349,
  1300000/392,
  1300000/440,
  1300000/523
}; 

uchar music[1] = { 
  F,8, A,4, C2,4, A,4, F,8, C,4, D,4, E,4,
  F,8, A,4, C2,4, A,4, G,8, C,4, D,4, E,4, E,8, C,4, D,4, E,4, F,16,
  F,8, A,4, C2,4, A,4, G,8, C,4, D,4, E,4, E,8, C,4, D,4, E,4, F,16,
  0
};