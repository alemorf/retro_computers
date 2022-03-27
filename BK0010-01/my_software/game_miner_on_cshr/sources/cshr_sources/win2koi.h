void win2koi(char* str) {
  static const unsigned char xlat[] = {
       128,129,130,131,132,133,134,135,136,137,060,139,140,141,142,143,
       144,145,146,147,148,169,150,151,152,153,154,062,176,157,183,159,
       160,246,247,074,164,231,166,167,179,169,180,060,172,173,174,183,
       156,177,073,105,199,181,182,158,163,191,164,062,106,189,190,167,
       225,226,247,231,228,229,246,250,233,234,235,236,237,238,239,240,
       242,243,244,245,230,232,227,254,251,253,154,249,248,252,224,241,
       193,194,215,199,196,197,214,218,201,202,203,204,205,206,207,208,
       210,211,212,213,198,200,195,222,219,221,223,217,216,220,192,209
  };

  for(int i=0; str[i]; i++)
    if(str[i]&0x80)
      str[i] = xlat[str[i]&0x7F];
}