uint8_t ConstStrings[1];

asm(" align 128");
asm("file_end: savebin \"boot.cpm\", 0, $");
