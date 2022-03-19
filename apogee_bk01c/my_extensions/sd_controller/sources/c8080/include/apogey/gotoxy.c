void gotoxy(char x, char y) {
  putch(0x1B);
  putch('Y');
  putch(y+0x20);
  putch(x+0x20);
}
