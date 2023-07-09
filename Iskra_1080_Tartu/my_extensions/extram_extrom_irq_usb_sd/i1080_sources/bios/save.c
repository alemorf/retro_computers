uint8_t ConstStrings[];

asm(" align 128");
asm("file_end: savebin \"boot.cpm\", 0, $");
