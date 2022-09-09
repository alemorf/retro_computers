#pragma once

#include <stddef.h>
#include <stdint.h>

void __fastcall memset(void* destination, uint8_t byte, size_t size) @ "memset.c";
void __fastcall memcpy(void* destination, const void* source, size_t size) @ "memcpy.c";
void __fastcall memmove(void* destination, const void* source, size_t size) @ "memmove.c";
void* __fastcall memchr8(void* destination, uint8_t byte, uint8_t size) @ "memchr8.c";
int8_t __fastcall memcmp(const void* buffer1, const void* buffer2, size_t size) @ "memcmp.c";
void __fastcall memswap(void* buffer1, void* buffer2, size_t size) @ "memswap.c";
size_t __fastcall strlen(const char* s) @ "strlen.c";
char* __fastcall strcpy(char* d, const char* s) @ "strcpy.c";
int8_t __fastcall strcmp(const char* d, const char* s) @ "strcmp.c";
const char* __fastcall strchr(const char* d, char s) @ "strchr.c";
