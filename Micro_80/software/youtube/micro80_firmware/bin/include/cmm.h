// Заголовочный файл для программ на языке CMM
// Система команд микропроцессора КР580ВМ80А

#pragma once

#ifdef __CMM

// Для удобства
typedef char int8_t;
typedef unsigned char uint8_t;
typedef short int16_t;
typedef unsigned short uint16_t;
typedef long int32_t;
typedef unsigned long uint32_t;
typedef unsigned short uintptr_t;

// Регистры процессора
extern uint8_t a, b, c, d, e, h, l;  // Далее r8 обозначает один из этих регистров
extern uint16_t bc, de, hl, sp;      // Далее r16 обозначает один из этих регистров

// *** Присвоение / копирование ***
// КОД НА CMM               | АССЕМБЛЕР            | ФЛАГИ    | ДЛИТЕЛЬНОСТЬ
// r8 = r8                  | mov r8, r8           | нет      | 5 тактов
// r8 = *hl                 | mov r8, m            | нет      | 7 тактов
// *hl = r8                 | mov m, r8            | нет      | 7 тактов
// r8 = const_number        | mvi r8, const_number | нет      | 7 тактов
// *hl = const_number       | mvi m, const_number  | нет      | 10 тактов
// r16 = const_number       | lxi r16, const_number| нет      | 10 тактов
// a = variable             | lda variable         | нет      | 13 тактов
// a = *bc                  | ldax b               | нет      | 7 тактов
// a = *de                  | ldax d               | нет      | 7 тактов
// *bc = a                  | stax b               | нет      | 7 тактов
// *de = a                  | stax d               | нет      | 7 тактов
// variable = a             | sta variable         | нет      | 13 тактов
// hl = variable            | lhld variable        | нет      | 16 тактов
// variable = hl            | shld variable        | нет      | 16 тактов
// sp = hl                  | sphl                 | нет      | 5 тактов

// Никакие другие варианты присвоения не поддерживаются процессором и компилироваться не будут

// *** Порты ввода-вывода ***
// a = in(const_number)     | in const_number      | нет      | 10 тактов
// out(a, const_number);    | out const_number     | нет      | 10 тактов

uint8_t in(uint8_t const_number);
void out(uint8_t a, uint8_t const_number);

// *** Стек ***
// push(bc, de, hl или a)   | push r16             | нет      | 10 тактов
// pop(bc, de, hl или a)    | pop r16              | нет      | 11 тактов

// Можно указывать несколько регистров.
// Вместе с регистром А в стек сохраняется регистр флагов

void push(uint16_t a_bc_de_hl, ...);
void pop(uint16_t a_bc_de_hl, ...);

// *** Переход по адресу HL ***
// return hl();             | pchl                 | нет      | 5 тактов

// *** Сравнение регистра A ***
// compare(a, r8)           | cmp r8               | все      | 4 такта
// compare(a, *hl)          | cmp m                | все      | 7 тактов
// compare(a, const_num)    | cpi const_number     | все      | 7 тактов

void compare(uint8_t a, uint8_t r8_xhl_or_const_number);

// Команда compare скрыто вызывается в конструкциях: "if (a ==", "while (a >=", "for (; a !="

// *** Циклической сдвиг A через флаг СF ***
// carry_rotate_left(a, const_num)   | RAL         | CF       | 4 такта
// carry_rotate_right(a, const_num)  | RAR         | CF       | 4 такта

void carry_rotate_left(uint8_t a, uint8_t const_number);
void carry_rotate_right(uint8_t a, uint8_t const_number);

// *** Циклической сдвиг A ***
// cyclic_rotate_left(a, const_num)  | RLC         | CF       | 4 такта
// cyclic_rotate_right(a, const_num) | RRC         | CF       | 4 такта

void cyclic_rotate_left(uint8_t a, uint8_t const_number);
void cyclic_rotate_right(uint8_t a, uint8_t const_number);

// *** Установить флаг CF ***
// set_flag_c()             | STC                  | CF = 1   | 4 такта

void set_flag_c(void);

// *** Обмен регистров ***
// swap(hl, de)             | XCHG                 | нет      | 4 такта
// swap(hl, *sp)            | XTHL                 | нет      | 18 тактов

void swap(uint16_t hl, uint16_t de_or_xsp);

// *** Инвертирование регистра А ***
// invert(a)                | CMA                  | нет      | 4 такта

void invert(uint8_t a);

// *** Арифметические и логические операции ***
// a += r8                  | add r8               | нет      | 4 такта
// a += *hl                 | add m                | нет      | 7 тактов
// a += const_number        | adi const_number     | нет      | 7 тактов
// a -= *hl                 | sub r8               | нет      | 4 такта
// a -= r8                  | sub m                | нет      | 7 тактов
// a -= const_number        | sui const_number     | нет      | 7 тактов
// a &= r8                  | and r8               | нет      | 4 такта
// a &= *hl                 | and m                | нет      | 7 тактов
// a &= const_number        | ani const_number     | нет      | 7 тактов
// a |= r8                  | ora r8               | нет      | 4 такта
// a |= *hl                 | ora m                | нет      | 7 тактов
// a |= const_number        | ori const_number     | нет      | 7 тактов
// a ^= r8                  | xor r8               | нет      | 4 такта
// a ^= *hl                 | xor m                | нет      | 7 тактов
// a ^= const_number        | xri const_number     | нет      | 7 тактов
// hl += r16                | dad r16              | CF       | 10 тактов
// r8++                     | inr r8               | кроме CF | 5 тактов
// r8--                     | dcr r8               | кроме CF | 5 тактов
// (*hl)++                  | inr m                | кроме CF | 10 тактов
// (*hl)--                  | dcr m                | кроме CF | 10 тактов
// r16++                    | inx r16              | нет      | 5 тактов
// r16--                    | dcx r16              | нет      | 5 тактов

// *** Выход из подпрограммы ***
// return;                  | ret                  | нет      | 10 тактов
// if (flag_?) return;      | r?                   | нет      | 5 или 11 тактов

// Заметте, что if (flag_?) { return; } компилируется как jmp $+4 и ret

// *** Переход и вызов подпрограммы ***
// function()               | call function        | нет      | 17 тактов
// if (flag_?) function();  | c? function          | нет      | 11 или 17 тактов
// return function();       | jmp function         | нет      | 10 тактов
// goto label;              | jmp label            | нет      | 10 тактов
// break;                   | jmp ...              | нет      | 10 тактов
// continue;                | jmp ...              | нет      | 10 тактов
// if (flag_?) return fn(); | j? function          | нет      | 10 тактов
// if (flag_?) goto label;  | j? function          | нет      | 10 тактов
// if (flag_?) break;       | j? ...               | нет      | 10 тактов
// if (flag_?) continue;    | j? ...               | нет      | 10 тактов
// if (flag_?) A            | j? l1 / A / l1:      | нет      | 10 тактов
// if (flag_?) A else B;    | j? l1: / A / jmp l2 / l1: / B / l2:
// do { A } while(flag_?);  | l1: / A / j? l1:
// while(flag_?) A          | l1: / j? l2 / A / jmp l1 / l2:
// for (A; flag_?; B) C     | TODO

// Для наглядности после flag_? можно разместить скобки и в скобках
// произвольный код. Он будет выполнен перед условным переходом. Например:
//
// if (flag_z(a |= b))
//
// аналогично
//
// a |= n;
// if (flag_z) return;
//
// Для наглядности при вызове подпрограммы в скобках можно разместить команды.
// Они будут выполнены перед условным переходом. Например:
//
// hl = "Hello world";
// function();
//
// аналогично
//
// function(hl = "Hello world");
//
// Так же можно использовать сравнение
//
// if (a <  ?)   аналогично  if (flag_c (compare(a, ?))
// if (a >= ?)   аналогично  if (flag_nc(compare(a, ?))
// if (a == 0)   аналогично  if (flag_z (a |= a))
// if (a != 0)   аналогично  if (flag_nz(a |= a))
// if (a == ?)   аналогично  if (flag_z (compare(a, ?))
// if (a != ?)   аналогично  if (flag_nz(compare(a, ?))
//
// do { a = in(10); } while(a != 5);
//
// аналогично
//
// do { a = in(10); compare(a, 5); } while(flag_nz);
//
// Вмеcто имени функции можно использовать адрес в памяти.
//
// 100()
//
// Это просто запись в Си без приведения типа
//
// typedef (void(*function_t)();
// ((function_t)100)()
//
// Если последняя команда в функции это call, то она заменяется на jmp
// Если последняя команда в функции не jmp или ret, то к функции добавляется ret
// Если последняя команда в функции jmp $ + 3, то она удаляется

uint8_t flag_z();
uint8_t flag_nz();
uint8_t flag_c();
uint8_t flag_nc();
uint8_t flag_m();
uint8_t flag_p();
uint8_t flag_pe();

// Конструкция
//   push_pop(A) { B }
// аналогична
//   push(A)
//   B
//   pop(A)

// *** Сложение/вычитание с флагом переноса ***
// carry_add(a, r8)           | adc r8            | нет      | 4 такта
// carry_add(a, *hl)          | adc m             | нет      | 7 тактов
// carry_add(a, const_number) | aci const_number  | нет      | 7 тактов
// carry_sub(a, r8)           | sbc r8            | нет      | 4 такта
// carry_sub(a, *hl)          | sbc m             | нет      | 7 тактов
// carry_sub(a, const_number) | sbi const_number  | нет      | 7 тактов

void carry_add(uint8_t a, uint8_t r8_xhl_const_number);
void carry_sub(uint8_t a, uint8_t r8_xhl_const_number);

// *** Разные простые команды ***
// enable_interrupts()               | EI         | нет      | 4 такта
// disable_interrupts()              | DI         | нет      | 4 такта
// daa()                             | DAA        | нет      | 4 такта
// halt()                            | HLT        | нет      | 7 тактов
// nop()                             | NOP        | нет      | 4 такта

void enable_interrupts(void);
void disable_interrupts(void);
void nop(void);
void halt(void);
void daa(void);

/*
TODO:
3F 	CMC 	CCF 	Инвертировать флаг C 	4
C7 	RST 0 	RST 0 	Запуск подпрограммы по адресу 0 	11
CF 	RST 8 	RST 8 	Запуск подпрограммы по адресу 8 	11
D7 	RST 10h 	RST 10h 	Запуск подпрограммы по адресу 10h 	11
DF 	RST 18h 	RST 18h 	Запуск подпрограммы по адресу 18h 	11
E7 	RST 20h 	RST 20h 	Запуск подпрограммы по адресу 20h 	11
EF 	RST 28h 	RST 28h 	Запуск подпрограммы по адресу 28h 	11
F7 	RST 30h 	RST 30h 	Запуск подпрограммы по адресу 30h 	11
FF 	RST 38h 	RST 38h 	Запуск подпрограммы по адресу 38h 	11
*/

#else

// Для работы в IDE

#include <stdint.h>

class Register {
public:
    template <class T>
    Register &operator=(T value) {
        return *this;
    }
    Register &operator&=(unsigned) {
        return *this;
    }
    Register &operator|=(unsigned) {
        return *this;
    }
    Register &operator^=(unsigned) {
        return *this;
    }
    Register &operator+=(unsigned) {
        return *this;
    }
    Register &operator-=(unsigned) {
        return *this;
    }
    Register &operator++(int) {
        return *this;
    }
    Register &operator--(int) {
        return *this;
    }
    Register &operator*() {
        return *this;
    }

    operator unsigned() {
        return 0;
    }
    void operator()() {
    }
};

extern Register a, b, c, d, e, h, l;
extern Register bc, de, hl, sp;

inline uint8_t flag_z(...) {
    return 0;
}
inline uint8_t flag_nz(...) {
    return 0;
}
inline uint8_t flag_c(...) {
    return 0;
}
inline uint8_t flag_nc(...) {
    return 0;
}
inline uint8_t flag_m(...) {
    return 0;
}
inline uint8_t flag_p(...) {
    return 0;
}
inline uint8_t flag_pe(...) {
    return 0;
}
inline void push(Register &reg, ...) {
}
inline void pop(Register &reg, ...) {
}
inline uint8_t in(uint8_t const_number) {
    return 0;
}
inline void out(uint8_t a, uint8_t const_number) {
}
inline uint8_t compare(Register &a, unsigned) {
    return 0;
}
inline void set_flag_c() {
}
inline void carry_rotate_left(Register &a, uint8_t const_number) {
}
inline void carry_rotate_right(Register &a, uint8_t const_number) {
}
inline void cyclic_rotate_left(Register &a, uint8_t const_number) {
}
inline void cyclic_rotate_right(Register &a, uint8_t const_number) {
}
inline void swap(Register &a, Register &b) {
}
inline void invert(Register &a) {
}

#define push_pop(...) for (push(__VA_ARGS__);; pop(__VA_ARGS__))

#define __address(X)

#endif
