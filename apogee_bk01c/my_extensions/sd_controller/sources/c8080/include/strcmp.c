char strcmp(const char* d, const char* s) {
  uchar a, b;
  while(1) {
    a=*d, b=*s;
    if(a < b) return 255;
    if(b < a) return 1;
    if(*d==0) return 0;
    ++d, ++s;
  }
}