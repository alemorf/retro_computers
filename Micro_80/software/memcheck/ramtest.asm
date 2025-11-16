; RAM test for Micro 80
; Version 0.1
; Copyright (c) 2025 Aleksey Morozov aleksey.f.morozov@gmail.com aleksey.f.morozov@yandex.ru
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, version 3.
;
; This program is distributed in the hope that it will be useful, but
; WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
; General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program. If not, see <http://www.gnu.org/licenses/>.

; For compilation you can use:
; TASM Assembler.  Version 3.2 September, 2001. (C) 2001 Squak Valley Software

RAM_TEST_START = 200h
RAM_TEST_SIZE = 0F500h
RAM_TEST_A = 055h
RAM_TEST_B = RAM_TEST_A ^ 0FFh

        .org 100h

main:
    ; Запись RAM_TEST_A в каждую ячейку ОЗУ
    ld   sp, RAM_TEST_START + RAM_TEST_SIZE ; Начальный адрес
    ld   de, (RAM_TEST_SIZE / 256) | ((256 / 2 / 4) << 8)
    ld   bc, (RAM_TEST_A << 8) | RAM_TEST_A ; Константа для заливки
ramtest_x:
    ld   a, d
ramtest_0:
    push bc
    push bc
    push bc
    push bc
    dec  a
    jp   nz, ramtest_0
    dec  e
    jp   nz, ramtest_x

    ; Проверка записанного RAM_TEST_A, замена его на RAM_TEST_B и т.д.
    ld   b, RAM_TEST_B
    ld   e, 0
ramtest_1:
    ld   de, RAM_TEST_SIZE / 256
    ld   hl, RAM_TEST_START    
ramtest_2:
    ld   a, l
    add  a
    add  a
    add  l
    inc  a
    ld   l, a
    ld   a, (hl)
    cp   c
    jp   nz, ram_test_error
    ld   (hl), b    
    dec  d
    jp   nz, ramtest_2
    inc  h
    dec  e
    jp   nz, ramtest_2
    
    ld   c, b    
    
    ld   a, b
    add  a
    add  a
    add  b
    inc  a
    ld   b, a
    
    jp   ramtest_1

;----------------------------------------------------------------------------

ram_test_error:
    ld   b, a
    ex   hl, de

    ; Очистка цветного экрана
    ld   sp, 0E00Ah
    ld   hl, 04F4Fh
    push hl
    push hl
    push hl
    push hl
    push hl

    ; Адрес вывода
    ld   sp, 0E80Ah

    ; Вывод записанного байта
    ld   hl, $ + 3
    ld   a, b
    jp   ram_test_print_low
    ld   a, b
    jp   ram_test_print_high
    xor  a
    jp   ram_test_print_char

    ; Вывод прочитанного адреса
    ld   a, c
    jp   ram_test_print_low
    ld   a, c
    jp   ram_test_print_low
    xor  a
    jp   ram_test_print_char

    ; Вывод адреса сбойного байта
    ld   a, e
    jp   ram_test_print_low
    ld   a, e
    jp   ram_test_print_high
    ld   a, d
    jp   ram_test_print_low
    ld   a, d
    jp   ram_test_print_high
    jp $
    
;----------------------------------------------------------------------------

ram_test_print_high:
    rrca
    rrca
    rrca
    rrca
ram_test_print_low:
    and  0Fh
    add  '0'
    cp   '9' + 1
    jp   c, ram_test_print_char
    add  'A' - '0' - 10
ram_test_print_char:
    push af
    inc  sp
    inc  hl
    inc  hl
    inc  hl
    inc  hl
    jp   (hl)
    
        .end
