loc_1120:
dec (R1)
beq loc_1160
bvs loc_1150 ; выдаёт ошибку ***
ADD #167777, R1
mov R1, -(R4) ;44
br loc_1170 ;46

loc_1150: dec R0

loc_1152: movb (R0), -(R4)
movb -(R0), -(R4)
br loc_1120

loc_1160: movb -(R0), R2
loc_1170:

.end