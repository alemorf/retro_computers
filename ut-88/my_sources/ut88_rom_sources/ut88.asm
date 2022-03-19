    device zxspectrum48

    org 0h

romTestF=0xFE00

start:
    di
    jp romTestF

crc16 dw 0

    incbin "bios.bin"

    org romTestF

    incbin "testf.bin"

    savebin "ut88.bin", 0, 0xFFFF
