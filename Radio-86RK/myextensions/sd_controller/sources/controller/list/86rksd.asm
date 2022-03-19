
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8L
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 160 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8L
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x00A0
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _fs_type=R5
	.DEF _fs_csize=R4
	.DEF _fs_n_rootdir=R6
	.DEF _sd_sdhc=R9
	.DEF _readLength=R10

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_0x20000:
	.DB  0x2B,0x2C,0x3B,0x3D,0x5B,0x5D,0x2A,0x3F
	.DB  0x3C,0x3A,0x3E,0x5C,0x7C,0x22,0x0
_0x60000:
	.DB  0x56,0x31,0x2E,0x30,0x20,0x31,0x30,0x2D
	.DB  0x30,0x35,0x2D,0x32,0x30,0x31,0x34,0x20
	.DB  0x0,0x62,0x6F,0x6F,0x74,0x2F,0x73,0x64
	.DB  0x62,0x69,0x6F,0x73,0x2E,0x72,0x6B,0x0
	.DB  0x62,0x6F,0x6F,0x74,0x2F,0x62,0x6F,0x6F
	.DB  0x74,0x2E,0x72,0x6B,0x0
__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x100

	.CSEG
;// SD Controller for Computer "Radio 86RK" / "Apogee BK01"
;// (c) 10-05-2014 vinxru (aleksey.f.morozov@gmail.com)
;
;#include "proto.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;void wait() {
; 0000 0006 void wait() {

	.CSEG
_wait:
; 0000 0007     // Ждем перепад 0->1
; 0000 0008     while(!PINC.5);
_0x3:
	SBIS 0x13,5
	RJMP _0x3
; 0000 0009     while(PINC.5);
_0x6:
	SBIC 0x13,5
	RJMP _0x6
; 0000 000A //    while((PINC&0x3F)==0);
; 0000 000B //    while((PINC&0x3F)==0x20);
; 0000 000C     if((PINC&0x3F)==0) return;
	IN   R30,0x13
	ANDI R30,LOW(0x3F)
	BRNE _0x9
	RET
; 0000 000D #asm
_0x9:
; 0000 000E     RJMP 0
    RJMP 0
; 0000 000F #endasm
; 0000 0010 }
	RET
;
;void sendStart(BYTE c) {
; 0000 0012 void sendStart(BYTE c) {
_sendStart:
; 0000 0013     wait();
;	c -> Y+0
	RCALL _wait
; 0000 0014     DATA_OUT
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0015     PORTD = c;
	LD   R30,Y
	OUT  0x12,R30
; 0000 0016 }
	ADIW R28,1
	RET
;
;void recvStart() {
; 0000 0018 void recvStart() {
_recvStart:
; 0000 0019     wait();
	RCALL _wait
; 0000 001A     DATA_IN
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 001B     PORTD = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 001C }
	RET
;
;BYTE wrecv() {
; 0000 001E BYTE wrecv() {
_wrecv:
; 0000 001F     wait();
	RCALL _wait
; 0000 0020     return PIND;
	IN   R30,0x10
	RET
; 0000 0021 }
;
;void send(BYTE c) {
; 0000 0023 void send(BYTE c) {
_send:
; 0000 0024     wait();
;	c -> Y+0
	RCALL _wait
; 0000 0025     PORTD = c;
	LD   R30,Y
	OUT  0x12,R30
; 0000 0026 }
	RJMP _0x202000F
;/*
;It is an open source software to implement FAT file system to
;small embedded systems. This is a free software and is opened for education,
;research and commercial developments under license policy of following trems.
;
;(C) 2013-2014 vinxru
;(C) 2010, ChaN, all right reserved.
;
;It is a free software and there is NO WARRANTY.
;No restriction on use. You can use, modify and redistribute it for
;personal, non-profit or commercial use UNDER YOUR RESPONSIBILITY.
;Redistributions of source code must retain the above copyright notice.
;
;Version 1.0 10-05-2014
;
;P.S. goto allows you to save memory! Like other horrors bellow.
;
;Program size: 3070 words (6140 bytes), 75% of FLASH at ATMega8 !!!
;*/
;
;/*
;Я не стал добавлять контроль на специальные имена
;CON,PRN,AUX,CLOCK$,NUL,COM1,COM2,COM3,COM4,LPT1,LPT2,LPT3
;что бы не занимать микроконтроллер. Файлы с такими именами
;оставляю на совести программиста.
;*/
;
;//#include <stdafx.h>
;#include "fs.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include "sd.h"
;#include <string.h>
;
;/* Для наглядности */
;
;#define	LD_WORD(ptr)    (*(WORD*)(ptr))
;#define	LD_DWORD(ptr)   (*(DWORD*)(ptr))
;
;/* Значения fs_type */
;
;#define FS_FAT16	0
;#define FS_FAT32	1
;#define FS_ERROR	2
;
;/* Специальные значения кластеров */
;
;#define FREE_CLUSTER    0
;#define LAST_CLUSTER    0x0FFFFFFF
;
;/* Системные переменные. Информация из boot-сектора */
;
;typedef struct {
;#ifndef FS_DISABLE_CHECK
;  BYTE  opened;              /* Что открыто: OPENED_NONE, OPENED_FILE, OPENED_DIR */
;#endif
;  BYTE  entry_able;          /* Результат выполнения функции fs_dirread */
;  WORD  entry_index;         /* Номер записи в каталоге */
;  DWORD entry_cluster;       /* Кластер записи в каталоге */
;  DWORD entry_sector;        /* Сектор записи в каталоге */
;  DWORD entry_start_cluster; /* Первый сектор файла или каталога (0 - корневой каталог FAT16) */
;  DWORD ptr;                 /* Указатель чтения/записи файла*/
;  DWORD size;                /* Размер файла / File size */
;  DWORD cluster;             /* Текущий кластер файла */
;  DWORD sector;              /* Текущий сектор файла */
;  BYTE  changed;             /* Размер файла изменился, надо сохранить */
;} File;
;
;BYTE  fs_type;         /* FS_FAT16, FS_FAT32, FS_ERROR */
;DWORD fs_fatbase;      /* Адрес первой FAT */
;DWORD fs_fatbase2;     /* Адрес второй FAT */
;BYTE  fs_csize;        /* Размер кластера в секторах */
;WORD  fs_n_rootdir;    /* Кол-во записей в корневом каталоге (только FAT16) */
;DWORD fs_n_fatent;     /* Кол-во кластеров */
;DWORD fs_dirbase;      /* Корневой каталог (сектор для FAT16, кластер для FAT32) */
;DWORD fs_database;     /* Адрес второго кластера */
;
;/* Системные переменные. Остальное */
;
;BYTE  lastError;       /* Последняя ошибка */
;DWORD fs_fatoptim;     /* Первый свободный кластер */
;DWORD fs_tmp;          /* Используеются для разных целей */
;WORD  fs_wtotal;       /* Используется функциями fs_write_start, fs_write_end*/
;
;/* Открытые файлы/папки */
;
;File fs_file;
;
;#ifndef FS_DISABLE_SWAP
;File fs_secondFile;
;#endif
;
;/* Структура boot-сектора */
;
;#define BPB_SecPerClus    13
;#define BPB_RsvdSecCnt    14
;#define BPB_NumFATs       16
;#define BPB_RootEntCnt    17
;#define BPB_TotSec16      19
;#define BPB_FATSz16       22
;#define BPB_TotSec32      32
;#define BS_FilSysType     54
;#define BPB_FATSz32       36
;#define BPB_RootClus      44
;#define BS_FilSysType32   82
;#define MBR_Table         446
;
;/**************************************************************************
;*  Чтение сектора в буфер                                                 *
;**************************************************************************/
;
;static BYTE sd_readBuf(DWORD sector) {
; 0001 006E static BYTE sd_readBuf(DWORD sector) {

	.CSEG
_sd_readBuf_G001:
; 0001 006F   return sd_read(buf, sector, 0, 512);
;	sector -> Y+0
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	RCALL SUBOPT_0x3
	RJMP _0x202001A
; 0001 0070 }
;
;/**************************************************************************
;*  Запись буфера в сектор                                                 *
;**************************************************************************/
;
;static BYTE sd_writeBuf(DWORD sector) {
; 0001 0076 static BYTE sd_writeBuf(DWORD sector) {
_sd_writeBuf_G001:
; 0001 0077   return sd_write512(buf, sector);
;	sector -> Y+0
	RCALL SUBOPT_0x0
	RCALL _sd_write512
	RJMP _0x202001A
; 0001 0078 }
;
;/**************************************************************************
;*  Инициализация                                                          *
;**************************************************************************/
;
;BYTE fs_init() {
; 0001 007E BYTE fs_init() {
_fs_init:
; 0001 007F   DWORD bsect, fsize, tsect;
; 0001 0080 
; 0001 0081   /* Сбрасываем оптимизацию */
; 0001 0082   fs_fatoptim = 2;
	SBIW R28,12
;	bsect -> Y+8
;	fsize -> Y+4
;	tsect -> Y+0
	__GETD1N 0x2
	RCALL SUBOPT_0x4
; 0001 0083 
; 0001 0084   /* Предотвращаем ошибки программиста */
; 0001 0085 #ifndef FS_DISABLE_CHECK
; 0001 0086   fs_file.opened = OPENED_NONE;
	RCALL SUBOPT_0x5
; 0001 0087 #ifndef FS_DISABLE_SWAP
; 0001 0088   fs_secondFile.opened = OPENED_NONE;
	RCALL SUBOPT_0x6
; 0001 0089 #endif
; 0001 008A   fs_type = FS_ERROR;
	LDI  R30,LOW(2)
	MOV  R5,R30
; 0001 008B #endif
; 0001 008C 
; 0001 008D   /* Инициализация накопителя */
; 0001 008E   if(sd_init()) return 1;
	RCALL _sd_init
	CPI  R30,0
	BREQ _0x20003
	LDI  R30,LOW(1)
	RJMP _0x202001B
; 0001 008F 
; 0001 0090   /* Ищем файловую систему */
; 0001 0091   bsect = 0;
_0x20003:
	LDI  R30,LOW(0)
	__CLRD1S 8
; 0001 0092   while(1) {
_0x20004:
; 0001 0093     if(sd_readBuf(bsect)) return 1;
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
	BREQ _0x20007
	LDI  R30,LOW(1)
	RJMP _0x202001B
; 0001 0094     if(LD_WORD(buf + 510) == 0xAA55) {
_0x20007:
	__GETW1MN _buf,510
	CPI  R30,LOW(0xAA55)
	LDI  R26,HIGH(0xAA55)
	CPC  R31,R26
	BRNE _0x20008
; 0001 0095       if(LD_WORD(buf + BS_FilSysType  ) == 0x4146) break;
	__GETW1MN _buf,54
	CPI  R30,LOW(0x4146)
	LDI  R26,HIGH(0x4146)
	CPC  R31,R26
	BREQ _0x20006
; 0001 0096       if(LD_WORD(buf + BS_FilSysType32) == 0x4146) break;
	__GETW1MN _buf,82
	CPI  R30,LOW(0x4146)
	LDI  R26,HIGH(0x4146)
	CPC  R31,R26
	BREQ _0x20006
; 0001 0097       /* Возможно это MBR */
; 0001 0098       if(bsect == 0 && buf[MBR_Table+4]) {
	RCALL SUBOPT_0x9
	RCALL __CPD02
	BRNE _0x2000C
	__GETB1MN _buf,450
	CPI  R30,0
	BRNE _0x2000D
_0x2000C:
	RJMP _0x2000B
_0x2000D:
; 0001 0099         bsect = LD_DWORD(buf + (MBR_Table + 8));
	__GETD1MN _buf,454
	RCALL SUBOPT_0xA
; 0001 009A         if(bsect != 0) continue;
	RCALL __CPD10
	BRNE _0x20004
; 0001 009B       }
; 0001 009C     }
_0x2000B:
; 0001 009D abort_noFS:
_0x20008:
_0x2000F:
; 0001 009E     lastError = ERR_NO_FILESYSTEM; return 1;
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xB
	LDI  R30,LOW(1)
	RJMP _0x202001B
; 0001 009F   }
_0x20006:
; 0001 00A0 
; 0001 00A1   /* Размер таблицы FAT в секторах */
; 0001 00A2   fsize = LD_WORD(buf + BPB_FATSz16);
	__GETW1MN _buf,22
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
; 0001 00A3   if(fsize == 0) fsize = LD_DWORD(buf + BPB_FATSz32);
	RCALL SUBOPT_0xE
	RCALL __CPD10
	BRNE _0x20010
	__GETD1MN _buf,36
	RCALL SUBOPT_0xD
; 0001 00A4 
; 0001 00A5   /* Размер файловой системы в секторах */
; 0001 00A6   tsect = LD_WORD( buf + BPB_TotSec16);
_0x20010:
	__GETW1MN _buf,19
	RCALL SUBOPT_0xF
; 0001 00A7   if(tsect == 0) tsect = LD_DWORD(buf + BPB_TotSec32);
	RCALL SUBOPT_0x10
	RCALL __CPD10
	BRNE _0x20011
	__GETD1MN _buf,32
	RCALL SUBOPT_0x11
; 0001 00A8 
; 0001 00A9   /* Размер корневого каталога (должно быть кратно 16 и для FAT32 должно быть рано нулю) */
; 0001 00AA   fs_n_rootdir = LD_WORD(buf + BPB_RootEntCnt);
_0x20011:
	__GETWRMN 6,7,_buf,17
; 0001 00AB 
; 0001 00AC   /* Адреса таблиц FAT в секторах */
; 0001 00AD   fs_fatbase  = bsect + LD_WORD(buf + BPB_RsvdSecCnt);
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x13
	STS  _fs_fatbase,R30
	STS  _fs_fatbase+1,R31
	STS  _fs_fatbase+2,R22
	STS  _fs_fatbase+3,R23
; 0001 00AE   fs_fatbase2 = 0;
	LDI  R30,LOW(0)
	STS  _fs_fatbase2,R30
	STS  _fs_fatbase2+1,R30
	STS  _fs_fatbase2+2,R30
	STS  _fs_fatbase2+3,R30
; 0001 00AF   if(buf[BPB_NumFATs] >= 2) fs_fatbase2 = fs_fatbase + fsize;
	__GETB2MN _buf,16
	CPI  R26,LOW(0x2)
	BRLO _0x20012
	RCALL SUBOPT_0x14
	RCALL __ADDD12
	STS  _fs_fatbase2,R30
	STS  _fs_fatbase2+1,R31
	STS  _fs_fatbase2+2,R22
	STS  _fs_fatbase2+3,R23
; 0001 00B0 
; 0001 00B1   /* Кол-во секторов на кластер */
; 0001 00B2   fs_csize = buf[BPB_SecPerClus];
_0x20012:
	__GETBRMN 4,_buf,13
; 0001 00B3 
; 0001 00B4   /* Кол-во кластеров */
; 0001 00B5   fsize *= buf[BPB_NumFATs];
	__GETB1MN _buf,16
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
	RCALL __MULD12U
	RCALL SUBOPT_0xD
; 0001 00B6   fs_n_fatent = (tsect - LD_WORD(buf + BPB_RsvdSecCnt) - fsize - fs_n_rootdir / 16) / fs_csize + 2;
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0xC
	RCALL __SWAPD12
	RCALL __SUBD12
	RCALL SUBOPT_0x16
	RCALL __SUBD12
	RCALL SUBOPT_0x19
	MOVW R30,R6
	RCALL __LSRW4
	RCALL SUBOPT_0xC
	RCALL __SUBD21
	RCALL SUBOPT_0x1A
	RCALL __DIVD21U
	__ADDD1N 2
	STS  _fs_n_fatent,R30
	STS  _fs_n_fatent+1,R31
	STS  _fs_n_fatent+2,R22
	STS  _fs_n_fatent+3,R23
; 0001 00B7 
; 0001 00B8   /* Адрес 2-ого кластера */
; 0001 00B9   fs_database = fs_fatbase + fsize + fs_n_rootdir / 16;
	RCALL SUBOPT_0x14
	RCALL __ADDD21
	MOVW R30,R6
	RCALL __LSRW4
	RCALL SUBOPT_0x13
	STS  _fs_database,R30
	STS  _fs_database+1,R31
	STS  _fs_database+2,R22
	STS  _fs_database+3,R23
; 0001 00BA 
; 0001 00BB   /* Определение файловой системы */
; 0001 00BC 
; 0001 00BD   /* FAT 12 */
; 0001 00BE   if(fs_n_fatent < 0xFF7) goto abort_noFS;
	RCALL SUBOPT_0x1B
	__CPD2N 0xFF7
	BRSH _0x20013
	RJMP _0x2000F
; 0001 00BF 
; 0001 00C0   /* FAT 16 */
; 0001 00C1   if(fs_n_fatent < 0xFFF7) {
_0x20013:
	RCALL SUBOPT_0x1B
	__CPD2N 0xFFF7
	BRSH _0x20014
; 0001 00C2     fs_dirbase = fs_fatbase + fsize;
	RCALL SUBOPT_0x14
	RCALL __ADDD12
	RCALL SUBOPT_0x1C
; 0001 00C3     fs_type = FS_FAT16;
	CLR  R5
; 0001 00C4     return 0;
	RJMP _0x202001C
; 0001 00C5   }
; 0001 00C6 
; 0001 00C7   /* FAT 32 */
; 0001 00C8   fs_dirbase = LD_DWORD(buf + BPB_RootClus);
_0x20014:
	__GETD1MN _buf,44
	RCALL SUBOPT_0x1C
; 0001 00C9 
; 0001 00CA   /* Сбрасываем счетчик свободного места */
; 0001 00CB   if(LD_WORD(buf + BPB_RsvdSecCnt)>0) {
	__GETW2MN _buf,14
	RCALL __CPW02
	BRSH _0x20015
; 0001 00CC     bsect++;
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0xA
; 0001 00CD     if(sd_readBuf(bsect)) return 1;
	RCALL SUBOPT_0x8
	BREQ _0x20016
	LDI  R30,LOW(1)
	RJMP _0x202001B
; 0001 00CE     if(LD_DWORD(buf) == 0x41615252 && LD_DWORD(buf + 0x1E4) == 0x61417272 && LD_DWORD(buf + 0x1FC) == 0xAA550000) {
_0x20016:
	LDS  R26,_buf
	LDS  R27,_buf+1
	LDS  R24,_buf+2
	LDS  R25,_buf+3
	__CPD2N 0x41615252
	BRNE _0x20018
	__GETD1MN _buf,484
	__CPD1N 0x61417272
	BRNE _0x20018
	RCALL SUBOPT_0x1E
	__CPD1N 0xAA550000
	BREQ _0x20019
_0x20018:
	RJMP _0x20017
_0x20019:
; 0001 00CF       LD_DWORD(buf + 0x1E8) = 0xFFFFFFFF;
	__POINTW1MN _buf,488
	RCALL SUBOPT_0x1F
; 0001 00D0       LD_DWORD(buf + 0x1EC) = 0xFFFFFFFF;
	__POINTW1MN _buf,492
	RCALL SUBOPT_0x1F
; 0001 00D1       if(sd_writeBuf(bsect)) return 1;
	RCALL SUBOPT_0x20
	BREQ _0x2001A
	LDI  R30,LOW(1)
	RJMP _0x202001B
; 0001 00D2     }
_0x2001A:
; 0001 00D3   }
_0x20017:
; 0001 00D4   fs_type = FS_FAT32;
_0x20015:
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0001 00D5 
; 0001 00D6   return 0;
_0x202001C:
	LDI  R30,LOW(0)
_0x202001B:
	ADIW R28,12
	RET
; 0001 00D7 }
;
;/**************************************************************************
;*  Проверка наличия диска и если нужно, то его инициализация              *
;**************************************************************************/
;
;BYTE fs_check() {
; 0001 00DD BYTE fs_check() {
_fs_check:
; 0001 00DE   if(!sd_check()) return 0;
	RCALL _sd_check
	CPI  R30,0
	BRNE _0x2001B
	RJMP _0x2020011
; 0001 00DF   return fs_init();
_0x2001B:
	RCALL _fs_init
	RET
; 0001 00E0 }
;
;/**************************************************************************
;*  Получить кластер из FS_DIRENTRY                                        *
;*  Функция не портит buf (функции, в которых этого не написано, портят)   *
;**************************************************************************/
;
;static DWORD fs_getEntryCluster() {
; 0001 00E7 static DWORD fs_getEntryCluster() {
_fs_getEntryCluster_G001:
; 0001 00E8   DWORD c = LD_WORD(FS_DIRENTRY + DIR_FstClusLO);
; 0001 00E9   if(fs_type != FS_FAT16) c |= ((DWORD)LD_WORD(FS_DIRENTRY + DIR_FstClusHI)) << 16;
	SBIW R28,4
;	c -> Y+0
	__GETW1MN _buf,506
	RCALL SUBOPT_0xF
	TST  R5
	BREQ _0x2001C
	__GETW1MN _buf,500
	RCALL SUBOPT_0xC
	RCALL __LSLD16
	RCALL SUBOPT_0x18
	RCALL __ORD12
	RCALL SUBOPT_0x11
; 0001 00EA   return c;
_0x2001C:
	RCALL SUBOPT_0x10
_0x202001A:
	ADIW R28,4
	RET
; 0001 00EB }
;
;/**************************************************************************
;*  Получить следующий кластер.                                            *
;*  Аргумент и результат находятся в fs_tmp.                               *
;**************************************************************************/
;
;static BYTE fs_nextCluster() {
; 0001 00F2 static BYTE fs_nextCluster() {
_fs_nextCluster_G001:
; 0001 00F3   if(fs_type == FS_FAT16) {
	TST  R5
	BRNE _0x2001D
; 0001 00F4     if(sd_read((BYTE*)&fs_tmp, fs_fatbase + fs_tmp / 256, (WORD)(BYTE)fs_tmp * 2, 2)) goto abort;
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x23
	LDI  R30,LOW(2)
	MUL  R30,R26
	ST   -Y,R1
	ST   -Y,R0
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x3
	CPI  R30,0
	BRNE _0x2001F
; 0001 00F5     fs_tmp &= 0xFFFF;
	RCALL SUBOPT_0x25
	__ANDD1N 0xFFFF
	RJMP _0x2010A
; 0001 00F6   } else {
_0x2001D:
; 0001 00F7     if(sd_read((BYTE*)&fs_tmp, fs_fatbase + fs_tmp / 128, (WORD)((BYTE)fs_tmp % 128) * 4, 4)) goto abort;
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x27
	RCALL __LSLW2
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x3
	CPI  R30,0
	BRNE _0x2001F
; 0001 00F8     fs_tmp &= 0x0FFFFFFF;
	RCALL SUBOPT_0x25
	__ANDD1N 0xFFFFFFF
_0x2010A:
	STS  _fs_tmp,R30
	STS  _fs_tmp+1,R31
	STS  _fs_tmp+2,R22
	STS  _fs_tmp+3,R23
; 0001 00F9   }
; 0001 00FA   /* Для удобства разработки заменяем последний кластер на ноль. */
; 0001 00FB   if(fs_tmp < 2 || fs_tmp >= fs_n_fatent)
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2A
	BRLO _0x20023
	RCALL SUBOPT_0x2B
	BRLO _0x20022
_0x20023:
; 0001 00FC     fs_tmp = 0;
	RCALL SUBOPT_0x2C
; 0001 00FD   return 0;
_0x20022:
	RJMP _0x2020011
; 0001 00FE abort:
_0x2001F:
; 0001 00FF   return 1;
	RJMP _0x2020014
; 0001 0100 }
;
;/**************************************************************************
;*  Преобразовать номер кластера в номер сектора                           *
;*  Аргумент и результат находятся в fs_tmp.                               *
;*  Функция не портит buf                                                  *
;***************************************************************************/
;
;static void fs_clust2sect() {
; 0001 0108 static void fs_clust2sect() {
_fs_clust2sect_G001:
; 0001 0109   fs_tmp = (fs_tmp - 2) * fs_csize + fs_database;
	RCALL SUBOPT_0x25
	__SUBD1N 2
	RCALL SUBOPT_0x2D
	RCALL __MULD12U
	RCALL SUBOPT_0x2E
	RCALL __ADDD12
	RCALL SUBOPT_0x2F
; 0001 010A }
	RET
;
;/**************************************************************************
;*  Получить очередной файл или папку                                      *
;*  Удаленные файлы, метки тома, последний элемент, LFN показываются       *
;*                                                                         *
;*  Описание работы полностью идентично функции ниже, поэтому здесь не     *
;*  приведено                                                              *
;*                                                                         *
;*  Функция не портит buf[0..MAX_FILENAME-1]                               *
;***************************************************************************/
;
;static BYTE fs_readdirInt() {
; 0001 0116 static BYTE fs_readdirInt() {
_fs_readdirInt_G001:
; 0001 0117   if(fs_file.entry_able) {
	RCALL SUBOPT_0x30
	BREQ _0x20025
; 0001 0118     fs_file.entry_index++;
	__POINTW2MN _fs_file,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0001 0119 
; 0001 011A     /* В папке не может быть больше 65536 файлов, а в корне FAT16 не больше  fs_n_rootdir */
; 0001 011B     if(fs_file.entry_index == 0 || (fs_file.entry_cluster == 0 && fs_file.entry_index == fs_n_rootdir)) {
	RCALL SUBOPT_0x31
	SBIW R26,0
	BREQ _0x20027
	RCALL SUBOPT_0x32
	BRNE _0x20028
	RCALL SUBOPT_0x31
	CP   R6,R26
	CPC  R7,R27
	BREQ _0x20027
_0x20028:
	RJMP _0x20026
_0x20027:
; 0001 011C       fs_file.entry_index = 0;
	RCALL SUBOPT_0x33
; 0001 011D retEnd:
_0x2002B:
; 0001 011E       FS_DIRENTRY[DIR_Name] = 0; /* Признак последнего файла для пользователя вызывающего fs_dirread */
	LDI  R30,LOW(0)
	__PUTB1MN _buf,480
; 0001 011F       fs_file.entry_able = 0;
	RCALL SUBOPT_0x34
; 0001 0120       return 0;
	RJMP _0x2020011
; 0001 0121     }
; 0001 0122 
; 0001 0123     /* Граница сектора */
; 0001 0124     if(fs_file.entry_index % 16 == 0) {
_0x20026:
	RCALL SUBOPT_0x35
	ANDI R30,LOW(0xF)
	BRNE _0x2002C
; 0001 0125       fs_file.entry_sector++;
	__POINTW2MN _fs_file,8
	RCALL SUBOPT_0x36
; 0001 0126 
; 0001 0127       /* Граница кластера */
; 0001 0128       if(fs_file.entry_cluster != 0 && ((fs_file.entry_index / 16) % fs_csize) == 0) {
	RCALL SUBOPT_0x32
	BREQ _0x2002E
	RCALL SUBOPT_0x35
	RCALL __LSRW4
	MOVW R26,R30
	MOV  R30,R4
	RCALL SUBOPT_0x15
	RCALL __MODW21U
	SBIW R30,0
	BREQ _0x2002F
_0x2002E:
	RJMP _0x2002D
_0x2002F:
; 0001 0129 
; 0001 012A         /* Следующий кластер */
; 0001 012B         fs_tmp = fs_file.entry_cluster;
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x2F
; 0001 012C         if(fs_nextCluster()) return 1;
	RCALL _fs_nextCluster_G001
	CPI  R30,0
	BREQ _0x20030
	RJMP _0x2020014
; 0001 012D         if(fs_tmp == 0) goto retEnd; /* Последний кластер, устаналиваем fs_file.entry_able = 0 */
_0x20030:
	RCALL SUBOPT_0x25
	RCALL __CPD10
	BREQ _0x2002B
; 0001 012E 
; 0001 012F         /* Сохраняем */
; 0001 0130         fs_file.entry_cluster = fs_tmp;
	RCALL SUBOPT_0x38
; 0001 0131         fs_clust2sect();
; 0001 0132         fs_file.entry_sector = fs_tmp;
; 0001 0133       }
; 0001 0134     }
_0x2002D:
; 0001 0135   } else {
_0x2002C:
	RJMP _0x20032
_0x20025:
; 0001 0136     fs_file.entry_index = 0;
	RCALL SUBOPT_0x33
; 0001 0137     fs_file.entry_able  = 1;
	LDI  R30,LOW(1)
	__PUTB1MN _fs_file,1
; 0001 0138     fs_tmp = fs_file.entry_start_cluster;
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x2F
; 0001 0139 
; 0001 013A     /* Первый кластер и сектор папки. Этот код не имеет смысла выполнять
; 0001 013B     для FAT16, но зато код хорошо сжимается. Т.к. этот кусок кода аналогичен
; 0001 013C     куску выше. */
; 0001 013D     fs_file.entry_cluster = fs_tmp;
	RCALL SUBOPT_0x38
; 0001 013E     fs_clust2sect();
; 0001 013F     fs_file.entry_sector = fs_tmp;
; 0001 0140 
; 0001 0141     /* Корневая папка FS_FAT16 */
; 0001 0142     if(fs_file.entry_cluster == 0) fs_file.entry_sector = fs_dirbase;
	RCALL SUBOPT_0x37
	RCALL __CPD10
	BRNE _0x20033
	RCALL SUBOPT_0x3A
	__PUTD1MN _fs_file,8
; 0001 0143   }
_0x20033:
_0x20032:
; 0001 0144 
; 0001 0145   return sd_read(FS_DIRENTRY, fs_file.entry_sector, (WORD)((fs_file.entry_index % 16) * 32), 32);
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x3C
	RCALL __PUTPARD1
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x2
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	RCALL SUBOPT_0x3
	RET
; 0001 0146 }
;
;/**************************************************************************
;*  Получить очередной файл или папку (удаленные файлы пропускаются)       *
;*                                                                         *
;*  Эта функция вызывается после fs_opendir, которая настраивает все       *
;*  нужные переменные, поэтому вам ничего трогать не надо. Информация      *
;*  ниже приведена для лучшего понимания работы                            *
;*                                                                         *
;*  Если на входе entry_able=0,  то начинается новый поиск в папке         *
;*  по адресу entry_start_cluster. При этом инициализируются переменные:   *
;*  entry_able, entry_index, entry_sector, entry_cluster.                  *
;*                                                                         *
;*  Если на входе fs_file.entry_able=1, то используются эти 4 переменные.  *
;*                                                                         *
;*  На выходе                                                              *
;*    entry_able     - если 0 значит достигнут конец каталога              *
;*    entry_sector   - сектор описателя                                    *
;*    entry_cluster  - кластер описателя                                   *
;*    entry_index    - номер описателя                                     *
;*    FS_DIRENTRY    - описатель                                           *
;*                                                                         *
;*  Функция не портит buf[0..MAX_FILENAME-1]                               *
;**************************************************************************/
;
;BYTE fs_readdir_nocheck() {
; 0001 015F BYTE fs_readdir_nocheck() {
_fs_readdir_nocheck:
; 0001 0160   while(!fs_readdirInt()) {
_0x20034:
	RCALL _fs_readdirInt_G001
	CPI  R30,0
	BRNE _0x20036
; 0001 0161     if(FS_DIRENTRY[DIR_Name] == 0) fs_file.entry_able = 0;
	RCALL SUBOPT_0x3E
	BRNE _0x20037
	RCALL SUBOPT_0x34
; 0001 0162     if(fs_file.entry_able == 0) return 0;
_0x20037:
	RCALL SUBOPT_0x30
	BRNE _0x20038
	RJMP _0x2020011
; 0001 0163     if(FS_DIRENTRY[DIR_Name] == 0xE5) continue; /*  Может быть еще 0x05 */
_0x20038:
	RCALL SUBOPT_0x3F
	CPI  R26,LOW(0xE5)
	BREQ _0x20034
; 0001 0164     if(FS_DIRENTRY[DIR_Name] == '.') continue;
	RCALL SUBOPT_0x3F
	CPI  R26,LOW(0x2E)
	BREQ _0x20034
; 0001 0165     if((FS_DIRENTRY[DIR_Attr] & AM_VOL) == 0) return 0;
	RCALL SUBOPT_0x40
	ANDI R30,LOW(0x8)
	BRNE _0x2003B
	RJMP _0x2020011
; 0001 0166   }
_0x2003B:
	RJMP _0x20034
_0x20036:
; 0001 0167   return 1;
	RJMP _0x2020014
; 0001 0168 }
;
;BYTE fs_readdir() {
; 0001 016A BYTE fs_readdir() {
_fs_readdir:
; 0001 016B #ifndef FS_DISABLE_CHECK
; 0001 016C   /* Папка должна быть открыта */
; 0001 016D   if(fs_file.opened != OPENED_DIR) { lastError = ERR_NOT_OPENED; return 1; }
	RCALL SUBOPT_0x41
	CPI  R26,LOW(0x2)
	BREQ _0x2003C
	RJMP _0x2020012
; 0001 016E #endif
; 0001 016F   return fs_readdir_nocheck();
_0x2003C:
	RCALL _fs_readdir_nocheck
	RET
; 0001 0170 }
;
;/**************************************************************************
;*  Сохранить изменения в обе таблицы FAT                                  *
;**************************************************************************/
;
;static BYTE fs_saveFatSector(DWORD sector) {
; 0001 0176 static BYTE fs_saveFatSector(DWORD sector) {
_fs_saveFatSector_G001:
; 0001 0177   if(fs_fatbase2) if(sd_writeBuf(fs_fatbase2+sector)) return 1;
;	sector -> Y+0
	LDS  R30,_fs_fatbase2
	LDS  R31,_fs_fatbase2+1
	LDS  R22,_fs_fatbase2+2
	LDS  R23,_fs_fatbase2+3
	RCALL __CPD10
	BREQ _0x2003D
	RCALL SUBOPT_0x10
	LDS  R26,_fs_fatbase2
	LDS  R27,_fs_fatbase2+1
	LDS  R24,_fs_fatbase2+2
	LDS  R25,_fs_fatbase2+3
	RCALL SUBOPT_0x42
	CPI  R30,0
	BREQ _0x2003E
	LDI  R30,LOW(1)
	RJMP _0x2020004
; 0001 0178   return sd_writeBuf(fs_fatbase+sector);
_0x2003E:
_0x2003D:
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x42
	RJMP _0x2020004
; 0001 0179 }
;
;/**************************************************************************
;*  Выделить кластер                                                       *
;*                                                                         *
;*  Найденный кластер сохраняется в fs_tmp                                 *
;**************************************************************************/
;
;/* Ради функции fs_getfree пришлось усложнить функцию fs_allocCluster.
;Если функция не используется, то можно с помощью макроса FS_DISABLE_GETFREESPACE
;исключить лишний код */
;
;#ifdef FS_DISABLE_GETFREESPACE
;#define DIS(X)
;#define ALLOCCLUSTER
;#else
;#define DIS(X) X
;#define ALLOCCLUSTER 0
;#endif
;
;static BYTE fs_allocCluster(DIS(BYTE freeSpace)) {
; 0001 018D static BYTE fs_allocCluster(BYTE freeSpace) {
_fs_allocCluster_G001:
; 0001 018E   BYTE i;
; 0001 018F   DWORD s;
; 0001 0190   BYTE *a;
; 0001 0191 
; 0001 0192   /* Начинаем поиск с этого кластера */
; 0001 0193   fs_tmp = fs_fatoptim;
	SBIW R28,4
	RCALL __SAVELOCR4
;	freeSpace -> Y+8
;	i -> R17
;	s -> Y+4
;	*a -> R18,R19
	RCALL SUBOPT_0x44
	RCALL SUBOPT_0x2F
; 0001 0194 
; 0001 0195   /* Последовательно перебираем сектора */
; 0001 0196   while(1) {
_0x2003F:
; 0001 0197     /* Сектор и смещение */
; 0001 0198     s = fs_tmp / 256, i = (BYTE)fs_tmp, a = (BYTE*)((WORD*)buf + i);
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0xD
	LDS  R17,_fs_tmp
	RCALL SUBOPT_0x45
	RCALL SUBOPT_0x46
	MOVW R18,R30
; 0001 0199     if(fs_type != FS_FAT16) s = fs_tmp / 128, i |= 128, a = (BYTE*)((DWORD*)buf - 128 + i);
	TST  R5
	BREQ _0x20042
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0xD
	ORI  R17,LOW(128)
	RCALL SUBOPT_0x47
	SUBI R30,LOW(512)
	SBCI R31,HIGH(512)
	MOVW R26,R30
	RCALL SUBOPT_0x45
	RCALL __LSLW2
	RCALL SUBOPT_0x48
	MOVW R18,R30
; 0001 019A 
; 0001 019B     /* Читаем сектор */
; 0001 019C     if(sd_readBuf(fs_fatbase + s)) goto abort;
_0x20042:
	RCALL SUBOPT_0x14
	RCALL __ADDD12
	RCALL SUBOPT_0x8
	BRNE _0x20044
; 0001 019D 
; 0001 019E     /* Среди 128/256 чисел в секторе ищем 0 */
; 0001 019F     /* Куча проверок внутри цикла не самое быстрое решение, но зато получается очень компактный код. */
; 0001 01A0     do {
_0x20046:
; 0001 01A1       /* Кластеры кончились */
; 0001 01A2       if(fs_tmp >= fs_n_fatent) { DIS(if(freeSpace) return 0;) lastError = ERR_NO_FREE_SPACE; goto abort; }
	RCALL SUBOPT_0x2B
	BRLO _0x20048
	RCALL SUBOPT_0x49
	BREQ _0x20049
	LDI  R30,LOW(0)
	RCALL __LOADLOCR4
	RJMP _0x202000A
_0x20049:
	LDI  R30,LOW(6)
	RCALL SUBOPT_0xB
	RJMP _0x20044
; 0001 01A3 
; 0001 01A4       /* Ищем свободный кластер и помечаем как последний */
; 0001 01A5       if(fs_type == FS_FAT16) {
_0x20048:
	TST  R5
	BRNE _0x2004A
; 0001 01A6         if(LD_WORD(a) == 0) { DIS(if(!freeSpace) {) LD_WORD(a) = (WORD)LAST_CLUSTER; goto founded; DIS(} fs_file.sector++;) }
	MOVW R26,R18
	RCALL __GETW1P
	SBIW R30,0
	BRNE _0x2004B
	RCALL SUBOPT_0x49
	BRNE _0x2004C
	MOVW R26,R18
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
	RJMP _0x2004D
_0x2004C:
	RCALL SUBOPT_0x4A
; 0001 01A7         a += 2;
_0x2004B:
	__ADDWRN 18,19,2
; 0001 01A8       } else {
	RJMP _0x2004E
_0x2004A:
; 0001 01A9         if(LD_DWORD(a) == 0) { DIS(if(!freeSpace) {) LD_DWORD(a) = LAST_CLUSTER; goto founded; DIS(} fs_file.sector++;) }
	MOVW R26,R18
	RCALL __GETD1P
	RCALL __CPD10
	BRNE _0x2004F
	RCALL SUBOPT_0x49
	BRNE _0x20050
	MOVW R26,R18
	RCALL SUBOPT_0x4B
	RCALL __PUTDP1
	RJMP _0x2004D
_0x20050:
	RCALL SUBOPT_0x4A
; 0001 01AA         a += 4;
_0x2004F:
	__ADDWRN 18,19,4
; 0001 01AB       }
_0x2004E:
; 0001 01AC 
; 0001 01AD       /* Счетчик */
; 0001 01AE       ++fs_tmp, ++i;
	LDI  R26,LOW(_fs_tmp)
	LDI  R27,HIGH(_fs_tmp)
	RCALL SUBOPT_0x36
	SUBI R17,-LOW(1)
; 0001 01AF     } while(i != 0);
	CPI  R17,0
	BRNE _0x20046
; 0001 01B0   }
	RJMP _0x2003F
; 0001 01B1 founded:
_0x2004D:
; 0001 01B2   /* Оптимизация */
; 0001 01B3   fs_fatoptim = fs_tmp;
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x4
; 0001 01B4 
; 0001 01B5   /* Сохраняем изменения */
; 0001 01B6   return fs_saveFatSector(s);
	RCALL SUBOPT_0xE
	RCALL __PUTPARD1
	RCALL _fs_saveFatSector_G001
	RCALL __LOADLOCR4
	RJMP _0x202000A
; 0001 01B7 abort:
_0x20044:
; 0001 01B8   return 1;
	LDI  R30,LOW(1)
	RCALL __LOADLOCR4
	RJMP _0x202000A
; 0001 01B9 }
;
;#undef DIS
;
;/**************************************************************************
;*  Изменение таблицы FAT                                                  *
;*                                                                         *
;*  Если fs_tmp!=0, то FAT[cluster] = fs_tmp                               *
;*  Если fs_tmp==0, то swap(FAT[cluster], fs_tmp)                          *
;**************************************************************************/
;
;static BYTE fs_setNextCluster(DWORD cluster) {
; 0001 01C4 static BYTE fs_setNextCluster(DWORD cluster) {
_fs_setNextCluster_G001:
; 0001 01C5   DWORD s, prev;
; 0001 01C6   void* a;
; 0001 01C7 
; 0001 01C8   /* Вычисляем сектор */
; 0001 01C9   s = cluster / 128;
	SBIW R28,8
	RCALL __SAVELOCR2
;	cluster -> Y+10
;	s -> Y+6
;	prev -> Y+2
;	*a -> R16,R17
	RCALL SUBOPT_0x4C
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x4D
; 0001 01CA   if(fs_type == FS_FAT16) s = cluster / 256;
	TST  R5
	BRNE _0x20051
	RCALL SUBOPT_0x4C
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x4D
; 0001 01CB 
; 0001 01CC   /* Читаем сектор */
; 0001 01CD   if(sd_readBuf(fs_fatbase + s)) return 1;
_0x20051:
	RCALL SUBOPT_0x4E
	RCALL SUBOPT_0x43
	RCALL __ADDD12
	RCALL SUBOPT_0x8
	BREQ _0x20052
	RCALL SUBOPT_0x4F
	RJMP _0x202000E
; 0001 01CE 
; 0001 01CF   /* Изменяем отдельный кластер */
; 0001 01D0   if(fs_type == FS_FAT16) {
_0x20052:
	TST  R5
	BRNE _0x20053
; 0001 01D1     a = (WORD*)buf + (BYTE)cluster;
	LDD  R30,Y+10
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x46
	MOVW R16,R30
; 0001 01D2     prev = LD_WORD(a);
	MOVW R26,R16
	RCALL __GETW1P
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x50
; 0001 01D3     LD_WORD(a) = (WORD)fs_tmp;
	RCALL SUBOPT_0x51
	MOVW R26,R16
	ST   X+,R30
	ST   X,R31
; 0001 01D4   } else {
	RJMP _0x20054
_0x20053:
; 0001 01D5     a = (DWORD*)buf + (BYTE)cluster % 128;
	LDD  R26,Y+10
	RCALL SUBOPT_0x27
	LDI  R26,LOW(_buf)
	LDI  R27,HIGH(_buf)
	RCALL __LSLW2
	RCALL SUBOPT_0x48
	MOVW R16,R30
; 0001 01D6     prev = LD_DWORD(a);
	MOVW R26,R16
	RCALL __GETD1P
	RCALL SUBOPT_0x50
; 0001 01D7     LD_DWORD(a) = fs_tmp;
	RCALL SUBOPT_0x25
	MOVW R26,R16
	RCALL __PUTDP1
; 0001 01D8   }
_0x20054:
; 0001 01D9 
; 0001 01DA   /* Оптимизация поиска свободного кластера. Внезапно if() if() занимает меньше ПЗУ, чем && */
; 0001 01DB   if(fs_tmp == FREE_CLUSTER) if(cluster < fs_fatoptim) fs_fatoptim = cluster;
	RCALL SUBOPT_0x25
	RCALL __CPD10
	BRNE _0x20055
	RCALL SUBOPT_0x44
	RCALL SUBOPT_0x4C
	RCALL __CPD21
	BRSH _0x20056
	__GETD1S 10
	RCALL SUBOPT_0x4
; 0001 01DC 
; 0001 01DD   /* Результат */
; 0001 01DE   if(fs_tmp == LAST_CLUSTER || fs_tmp == FREE_CLUSTER)
_0x20056:
_0x20055:
	RCALL SUBOPT_0x29
	__CPD2N 0xFFFFFFF
	BREQ _0x20058
	RCALL SUBOPT_0x29
	RCALL __CPD02
	BRNE _0x20057
_0x20058:
; 0001 01DF     fs_tmp = prev;
	RCALL SUBOPT_0x52
	RCALL SUBOPT_0x2F
; 0001 01E0 
; 0001 01E1   /* Сохраняем сектор */
; 0001 01E2   return fs_saveFatSector(s);
_0x20057:
	RCALL SUBOPT_0x4E
	RCALL __PUTPARD1
	RCALL _fs_saveFatSector_G001
	RCALL __LOADLOCR2
	RJMP _0x202000E
; 0001 01E3 }
;
;/**************************************************************************
;*  Установить в описатель кластер                                         *
;**************************************************************************/
;
;static void fs_setEntryCluster(BYTE* entry, DWORD cluster) {
; 0001 01E9 static void fs_setEntryCluster(BYTE* entry, DWORD cluster) {
_fs_setEntryCluster_G001:
; 0001 01EA   LD_WORD(entry + DIR_FstClusLO) = (WORD)(cluster);
;	*entry -> Y+4
;	cluster -> Y+0
	RCALL SUBOPT_0x53
	__PUTW1SNS 4,26
; 0001 01EB   LD_WORD(entry + DIR_FstClusHI) = (WORD)(cluster >> 16);
	RCALL SUBOPT_0x10
	RCALL __LSRD16
	__PUTW1SNS 4,20
; 0001 01EC }
	RJMP _0x2020002
;
;/**************************************************************************
;*  Очистить кластер и буфер                                               *
;**************************************************************************/
;
;static BYTE fs_eraseCluster(BYTE i) {
; 0001 01F2 static BYTE fs_eraseCluster(BYTE i) {
_fs_eraseCluster_G001:
; 0001 01F3   memset(buf, 0, 512);
;	i -> Y+0
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x55
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	RCALL SUBOPT_0x56
; 0001 01F4   for(; i < fs_csize; ++i)
_0x2005B:
	LD   R26,Y
	CP   R26,R4
	BRSH _0x2005C
; 0001 01F5     if(sd_writeBuf(fs_tmp + i)) return 1;
	LD   R30,Y
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x42
	CPI  R30,0
	BREQ _0x2005D
	LDI  R30,LOW(1)
	RJMP _0x202000F
; 0001 01F6   return 0;
_0x2005D:
	LD   R30,Y
	SUBI R30,-LOW(1)
	ST   Y,R30
	RJMP _0x2005B
_0x2005C:
	LDI  R30,LOW(0)
	RJMP _0x202000F
; 0001 01F7 }
;
;/**************************************************************************
;*  Выделить описатель в каталоге                                          *
;*                                                                         *
;*  entry_able должно быть равно 0                                         *
;*  entry_start_cluster должен содержать первый кластер папки              *
;**************************************************************************/
;
;static BYTE* fs_allocEntry() {
; 0001 0200 static BYTE* fs_allocEntry() {
_fs_allocEntry_G001:
; 0001 0201   /* Ищем в папке пустой описатель. */
; 0001 0202   while(1) {
_0x2005E:
; 0001 0203     if(fs_readdirInt()) return 0;
	RCALL _fs_readdirInt_G001
	CPI  R30,0
	BRNE _0x2020019
; 0001 0204 
; 0001 0205     /* Кластеры кончились */
; 0001 0206     if(!fs_file.entry_able) break;
	RCALL SUBOPT_0x30
	BREQ _0x20060
; 0001 0207 
; 0001 0208     /* Это свободный описатель */
; 0001 0209     if(FS_DIRENTRY[0] == 0xE5 || FS_DIRENTRY[0] == 0) { /* Может быть еще 0x05 */
	RCALL SUBOPT_0x3F
	CPI  R26,LOW(0xE5)
	BREQ _0x20064
	RCALL SUBOPT_0x3F
	CPI  R26,LOW(0x0)
	BRNE _0x20063
_0x20064:
; 0001 020A 
; 0001 020B       /* Читаем сектор */
; 0001 020C       if(sd_readBuf(fs_file.entry_sector)) return 0;
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x8
	BRNE _0x2020019
; 0001 020D 
; 0001 020E       /* Найденный описатель */
; 0001 020F       return buf + (fs_file.entry_index % 16) * 32;
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x57
	RET
; 0001 0210     }
; 0001 0211   }
_0x20063:
	RJMP _0x2005E
_0x20060:
; 0001 0212 
; 0001 0213   /* Ограничение по кол-ву файлов */
; 0001 0214   /* Корневой каталог FAT16 так же вернет fs_file.entry_index == 0 */
; 0001 0215   if(fs_file.entry_index == 0) { lastError = ERR_DIR_FULL; return 0; }
	RCALL SUBOPT_0x35
	SBIW R30,0
	BRNE _0x20067
	LDI  R30,LOW(5)
	RCALL SUBOPT_0xB
	RJMP _0x2020019
; 0001 0216 
; 0001 0217   /* Выделить кластер. Результат в fs_tmp */
; 0001 0218   if(fs_allocCluster(ALLOCCLUSTER)) return 0;
_0x20067:
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x58
	BRNE _0x2020019
; 0001 0219 
; 0001 021A   /* Добавить еще один кластер к папке. */
; 0001 021B   if(fs_setNextCluster(fs_file.entry_cluster)) return 0; /* fs_tmp сохранится, так как он не LAST и не FREE */
	RCALL SUBOPT_0x37
	RCALL SUBOPT_0x59
	CPI  R30,0
	BREQ _0x20069
_0x2020019:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET
; 0001 021C 
; 0001 021D   /* Заполняем ответ */
; 0001 021E   fs_file.entry_cluster = fs_tmp;
_0x20069:
	RCALL SUBOPT_0x38
; 0001 021F   fs_clust2sect();
; 0001 0220   fs_file.entry_sector  = fs_tmp;
; 0001 0221 
; 0001 0222   /* Очищаем кластер и за одно BUF (используется переменная fs_tmp) */
; 0001 0223   fs_eraseCluster(0);
	RCALL SUBOPT_0x55
	RCALL _fs_eraseCluster_G001
; 0001 0224 
; 0001 0225   /* Найденный описатель */
; 0001 0226   return buf;
	RCALL SUBOPT_0x47
	RET
; 0001 0227 }
;
;/**************************************************************************
;*  Открыть/создать файл или папку                                         *
;*                                                                         *
;*  Имя файла в buf. Оно не должно превышать FS_MAXFILE симолов включая 0  *
;*                                                                         *
;*  what = OPENED_NONE - Открыть файл или папку                            *
;*  what = OPENED_FILE - Создать файл (созданный файл открыт)              *
;*  what = OPENED_DIR  - Создать папку (созданная папка не открыта)        *
;*  what | 0x80        - Не создавать файл в папке entry_start_cluster     *
;*                                                                         *
;*  На выходе                                                              *
;*   FS_DIRENTRY                 - описатель                               *
;*   fs_file.entry_able          - 0 (если открыт существующий файл/папка) *
;*   fs_file.entry_sector        - сектор описателя                        *
;*   fs_file.entry_cluster       - кластер описателя                       *
;*   fs_file.entry_index         - номер описателя                         *
;*   fs_file.entry_start_cluster - первый кластер файла или папки          *
;*   fs_parent_dir_cluster       - первый кластер папки предка (CREATE)    *
;*   fs_file.ptr                 - 0 (если открыт файл)                    *
;*   fs_file.size                - размер файла (если открыт файл)         *
;*                                                                         *
;*  Функция не портит buf[0..MAX_FILENAME-1]                               *
;**************************************************************************/
;
;static BYTE fs_open0_create(BYTE dir); /* forward */
;static CONST BYTE* fs_open0_name(CONST BYTE *p); /* forward */
;
;#define FS_DIRFIND      (buf + 469)           /* 11 байт использующиеся внутри функции fs_open0 */
;#define fs_notrootdir (*(BYTE*)&fs_file.size) /* Используется fs_open0, в это время переменные fs_file. не содежат нужных значения */
;#define fs_parent_dir_cluster fs_file.sector  /* Так же используется fs_file.sector для хранения первого кластера папки предка. */
;
;BYTE fs_open0(BYTE what) {
; 0001 0248 BYTE fs_open0(BYTE what) {
_fs_open0:
; 0001 0249   CONST BYTE *path;
; 0001 024A   BYTE r;
; 0001 024B 
; 0001 024C   /* Проверка ошибок программиста */
; 0001 024D #ifndef FS_DISABLE_CHECK
; 0001 024E   if(fs_type == FS_ERROR) { lastError = ERR_NO_FILESYSTEM; goto abort; }
	RCALL __SAVELOCR4
;	what -> Y+4
;	*path -> R16,R17
;	r -> R19
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0x2006A
	LDI  R30,LOW(1)
	RJMP _0x2010B
; 0001 024F   fs_file.opened = OPENED_NONE;
_0x2006A:
	RCALL SUBOPT_0x5
; 0001 0250 #endif
; 0001 0251 
; 0001 0252   /* Предотвращение рекурсии */
; 0001 0253   r = what & 0x80; what &= 0x7F;
	LDD  R30,Y+4
	ANDI R30,LOW(0x80)
	MOV  R19,R30
	LDD  R30,Y+4
	ANDI R30,0x7F
	STD  Y+4,R30
; 0001 0254   fs_parent_dir_cluster = fs_file.entry_start_cluster;
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x5A
; 0001 0255 
; 0001 0256   /* Корневой каталог */
; 0001 0257   fs_notrootdir = 0;
	LDI  R30,LOW(0)
	__PUTB1MN _fs_file,20
; 0001 0258   fs_file.entry_start_cluster = fs_dirbase;
	RCALL SUBOPT_0x3A
	RCALL SUBOPT_0x5B
; 0001 0259   if(fs_type == FS_FAT16) fs_file.entry_start_cluster =  0;
	TST  R5
	BRNE _0x2006C
	RCALL SUBOPT_0x5C
	RCALL SUBOPT_0x5B
; 0001 025A 
; 0001 025B   /* Корневая папка */
; 0001 025C   if(buf[0] == 0) {
_0x2006C:
	LDS  R30,_buf
	CPI  R30,0
	BRNE _0x2006D
; 0001 025D     if(what) goto abort_noPath;
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0x2006E
	RJMP _0x2006F
; 0001 025E     FS_DIRENTRY[0] = 0;             /* Признак корневой папки */
_0x2006E:
	LDI  R30,LOW(0)
	__PUTB1MN _buf,480
; 0001 025F     FS_DIRENTRY[DIR_Attr] = AM_DIR; /* Для упрощения определения файл/папка запишем сюда AM_DIR */
	LDI  R30,LOW(16)
	__PUTB1MN _buf,491
; 0001 0260   } else {
	RJMP _0x20070
_0x2006D:
; 0001 0261     path = buf;
	__POINTWRM 16,17,_buf
; 0001 0262     while(1) {
_0x20071:
; 0001 0263       /* Получаем очередное имя из path в FS_DIRFIND */
; 0001 0264       path = fs_open0_name(path);
	RCALL SUBOPT_0x5D
	RCALL _fs_open0_name_G001
	MOVW R16,R30
; 0001 0265       if(path == (CONST BYTE*)1) goto abort_noPath;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x20074
	RJMP _0x2006F
; 0001 0266       /* Ищем имя в папке */
; 0001 0267       fs_file.entry_able = 0;
_0x20074:
	RCALL SUBOPT_0x34
; 0001 0268       while(1) {
_0x20075:
; 0001 0269         if(fs_readdir_nocheck()) return 1;
	RCALL _fs_readdir_nocheck
	CPI  R30,0
	BREQ _0x20078
	LDI  R30,LOW(1)
	RCALL __LOADLOCR4
	RJMP _0x2020001
; 0001 026A         if(fs_file.entry_able == 0) break;
_0x20078:
	RCALL SUBOPT_0x30
	BREQ _0x20077
; 0001 026B         if(!memcmp(FS_DIRENTRY, FS_DIRFIND, 11)) break;
	RCALL SUBOPT_0x3B
	RCALL SUBOPT_0x5E
	RCALL SUBOPT_0x5F
	RCALL SUBOPT_0x2
	RCALL _memcmp
	CPI  R30,0
	BRNE _0x20075
; 0001 026C       }
_0x20077:
; 0001 026D       /* Последний элементу пути в режиме создания */
; 0001 026E       if(what && path == 0) {
	LDD  R30,Y+4
	CPI  R30,0
	BREQ _0x2007C
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BREQ _0x2007D
_0x2007C:
	RJMP _0x2007B
_0x2007D:
; 0001 026F         fs_parent_dir_cluster = fs_file.entry_start_cluster; /* Сохраняем в этой переменной результат для фунции fs_move */
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x5A
; 0001 0270         if(fs_type == FS_FAT32 && fs_parent_dir_cluster == fs_dirbase) fs_parent_dir_cluster = 0;
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x2007F
	RCALL SUBOPT_0x60
	RCALL SUBOPT_0x3A
	RCALL __CPD12
	BREQ _0x20080
_0x2007F:
	RJMP _0x2007E
_0x20080:
	RCALL SUBOPT_0x5C
	RCALL SUBOPT_0x5A
; 0001 0271         if(fs_file.entry_able == 0) return fs_open0_create(what-1); /* Продолжим там */
_0x2007E:
	RCALL SUBOPT_0x30
	BRNE _0x20081
	LDD  R30,Y+4
	RCALL SUBOPT_0x15
	SBIW R30,1
	ST   -Y,R30
	RCALL _fs_open0_create_G001
	RCALL __LOADLOCR4
	RJMP _0x2020001
; 0001 0272         lastError = ERR_FILE_EXISTS; goto abort;
_0x20081:
	LDI  R30,LOW(8)
	RJMP _0x2010B
; 0001 0273       }
; 0001 0274       /* Файл/папка не найдена */
; 0001 0275       if(fs_file.entry_able == 0) goto abort_noPath;
_0x2007B:
	RCALL SUBOPT_0x30
	BRNE _0x20082
	RJMP _0x2006F
; 0001 0276 
; 0001 0277       /* Что то найдено */
; 0001 0278       fs_file.entry_start_cluster = fs_getEntryCluster();
_0x20082:
	RCALL _fs_getEntryCluster_G001
	RCALL SUBOPT_0x5B
; 0001 0279       /* Это был последний элемент пути */
; 0001 027A       if(path == 0) break;
	RCALL SUBOPT_0x61
	BREQ _0x20073
; 0001 027B       /* Это должна быть папка */
; 0001 027C       if((FS_DIRENTRY[DIR_Attr] & AM_DIR) == 0) goto abort_noPath;
	RCALL SUBOPT_0x40
	ANDI R30,LOW(0x10)
	BREQ _0x2006F
; 0001 027D       /* Предотвращаем рекурсию для функции fs_move */
; 0001 027E       if(r && fs_file.entry_start_cluster == fs_parent_dir_cluster) goto abort_noPath;
	CPI  R19,0
	BREQ _0x20086
	__GETD2MN _fs_file,12
	RCALL SUBOPT_0x62
	RCALL __CPD12
	BREQ _0x20087
_0x20086:
	RJMP _0x20085
_0x20087:
	RJMP _0x2006F
; 0001 027F       /* Наденная папка уже не будет корневой */
; 0001 0280       fs_notrootdir = 1;
_0x20085:
	LDI  R30,LOW(1)
	__PUTB1MN _fs_file,20
; 0001 0281     }
	RJMP _0x20071
_0x20073:
; 0001 0282   }
_0x20070:
; 0001 0283   /* Устанавливаем переменные */
; 0001 0284   fs_file.entry_able = 0;
	RCALL SUBOPT_0x34
; 0001 0285   fs_file.size  = LD_DWORD(FS_DIRENTRY + DIR_FileSize);
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x63
; 0001 0286   fs_file.ptr   = 0;
; 0001 0287 #ifndef FS_DISABLE_CHECK
; 0001 0288   fs_file.opened     = OPENED_FILE;
; 0001 0289   if(FS_DIRENTRY[DIR_Attr] & AM_DIR) fs_file.opened = OPENED_DIR;
	RCALL SUBOPT_0x40
	ANDI R30,LOW(0x10)
	BREQ _0x20088
	LDI  R30,LOW(2)
	STS  _fs_file,R30
; 0001 028A #endif
; 0001 028B 
; 0001 028C   /* Нельзя дважды открывать файл */
; 0001 028D #ifndef FS_DISABLE_CHECK
; 0001 028E #ifndef FS_DISABLE_SWAP
; 0001 028F   if(fs_secondFile.opened==OPENED_FILE && fs_file.opened==OPENED_FILE && fs_secondFile.entry_sector == fs_file.entry_sector && fs_secondFile.entry_index==fs_file.entry_index) {
_0x20088:
	LDS  R26,_fs_secondFile
	CPI  R26,LOW(0x1)
	BRNE _0x2008A
	RCALL SUBOPT_0x64
	BRNE _0x2008A
	__GETD2MN _fs_secondFile,8
	RCALL SUBOPT_0x3C
	RCALL __CPD12
	BRNE _0x2008A
	__GETW2MN _fs_secondFile,2
	RCALL SUBOPT_0x35
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x2008B
_0x2008A:
	RJMP _0x20089
_0x2008B:
; 0001 0290     fs_secondFile.opened = OPENED_NONE; //!9-05-2014 Закрываем второй файл
	RCALL SUBOPT_0x6
; 0001 0291   }
; 0001 0292 #endif
; 0001 0293 #endif
; 0001 0294 
; 0001 0295   return 0;
_0x20089:
	LDI  R30,LOW(0)
	RCALL __LOADLOCR4
	RJMP _0x2020001
; 0001 0296 abort_noPath:
_0x2006F:
; 0001 0297   lastError = ERR_NO_PATH;
	LDI  R30,LOW(4)
_0x2010B:
	STS  _lastError,R30
; 0001 0298 abort:
; 0001 0299   return 1;
	LDI  R30,LOW(1)
	RCALL __LOADLOCR4
	RJMP _0x2020001
; 0001 029A }
;
;static BYTE exists(const flash BYTE* str, BYTE c) {
; 0001 029C static BYTE exists(const flash BYTE* str, BYTE c) {
_exists_G001:
; 0001 029D   while(*str)
;	*str -> Y+1
;	c -> Y+0
_0x2008C:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LPM  R30,Z
	CPI  R30,0
	BREQ _0x2008E
; 0001 029E     if(*str++ == c)
	RCALL SUBOPT_0x65
	LPM  R26,Z
	LD   R30,Y
	CP   R30,R26
	BRNE _0x2008F
; 0001 029F       return c;
	RJMP _0x202000B
; 0001 02A0   return 0;
_0x2008F:
	RJMP _0x2008C
_0x2008E:
	LDI  R30,LOW(0)
	RJMP _0x202000B
; 0001 02A1 }
;
;static CONST BYTE * fs_open0_name(CONST BYTE *p) {
; 0001 02A3 static  BYTE * fs_open0_name( BYTE *p) {
_fs_open0_name_G001:
; 0001 02A4   BYTE c, ni, i;
; 0001 02A5 
; 0001 02A6   memset(FS_DIRFIND, ' ', 11);
	RCALL __SAVELOCR4
;	*p -> Y+4
;	c -> R17
;	ni -> R16
;	i -> R19
	RCALL SUBOPT_0x5E
	RCALL SUBOPT_0x66
; 0001 02A7   i = 0; ni = 8;
	LDI  R19,LOW(0)
	LDI  R16,LOW(8)
; 0001 02A8   while(1) {
_0x20090:
; 0001 02A9     c = *p++;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R17,X+
	STD  Y+4,R26
	STD  Y+4+1,R27
; 0001 02AA     if(c == 0) {
	CPI  R17,0
	BRNE _0x20093
; 0001 02AB       if(i == 0) break; /* Пустое имя файла */
	CPI  R19,0
	BREQ _0x20092
; 0001 02AC       return 0;
	RCALL SUBOPT_0x1
	RCALL __LOADLOCR4
	RJMP _0x2020002
; 0001 02AD     }
; 0001 02AE     if(c == '/') return p;
_0x20093:
	CPI  R17,47
	BRNE _0x20095
	RCALL SUBOPT_0x67
	RCALL __LOADLOCR4
	RJMP _0x2020002
; 0001 02AF     if(c == '.') {
_0x20095:
	CPI  R17,46
	BRNE _0x20096
; 0001 02B0       if(i == 0) break; /* Пустое имя файла */
	CPI  R19,0
	BREQ _0x20092
; 0001 02B1 #ifndef FS_DISABLE_CHECK
; 0001 02B2       if(ni != 8) break; /* Вторая точка */
	CPI  R16,8
	BRNE _0x20092
; 0001 02B3 #endif
; 0001 02B4       i = 8; ni = 11;
	LDI  R19,LOW(8)
	LDI  R16,LOW(11)
; 0001 02B5       continue;
	RJMP _0x20090
; 0001 02B6     }
; 0001 02B7     /* Слишком длинное име */
; 0001 02B8     if(i == ni) break;
_0x20096:
	CP   R16,R19
	BREQ _0x20092
; 0001 02B9     /* Запрещенные символы */
; 0001 02BA #ifndef FS_DISABLE_CHECK
; 0001 02BB     if(exists((const flash BYTE* )"+,;=[]*?<:>\\|\"", c)) break;
	__POINTW1FN _0x20000,0
	RCALL SUBOPT_0x2
	ST   -Y,R17
	RCALL _exists_G001
	CPI  R30,0
	BRNE _0x20092
; 0001 02BC     if(c <= 0x20) break;
	CPI  R17,33
	BRLO _0x20092
; 0001 02BD     if(c >= 0x80) break;
	CPI  R17,128
	BRSH _0x20092
; 0001 02BE #endif
; 0001 02BF     /* Приводим к верхнему регистру */
; 0001 02C0     if(c >= 'a' && c <= 'z') c -= 0x20;
	CPI  R17,97
	BRLO _0x2009E
	CPI  R17,123
	BRLO _0x2009F
_0x2009E:
	RJMP _0x2009D
_0x2009F:
	RCALL SUBOPT_0x45
	SBIW R30,32
	MOV  R17,R30
; 0001 02C1     /* Сохраняем имя */
; 0001 02C2     FS_DIRFIND[i++] = c;
_0x2009D:
	__POINTW2MN _buf,469
	MOV  R30,R19
	SUBI R19,-1
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x48
	ST   Z,R17
; 0001 02C3   }
	RJMP _0x20090
_0x20092:
; 0001 02C4   /* Ошибка */
; 0001 02C5   return (CONST BYTE*)1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL __LOADLOCR4
	RJMP _0x2020002
; 0001 02C6 }
;
;static BYTE fs_open0_create(BYTE dir) {
; 0001 02C8 static BYTE fs_open0_create(BYTE dir) {
_fs_open0_create_G001:
; 0001 02C9   BYTE  new_name[11];
; 0001 02CA   DWORD allocatedCluster;
; 0001 02CB   BYTE* allocatedEntry;
; 0001 02CC 
; 0001 02CD   /* Сохраняем имя, так как весь буфер будет затерт */
; 0001 02CE   memcpy(new_name, FS_DIRFIND, 11);
	SBIW R28,15
	RCALL __SAVELOCR2
;	dir -> Y+17
;	new_name -> Y+6
;	allocatedCluster -> Y+2
;	*allocatedEntry -> R16,R17
	MOVW R30,R28
	ADIW R30,6
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x5E
	RCALL SUBOPT_0x68
; 0001 02CF 
; 0001 02D0   /* Выделяем кластер для папки */
; 0001 02D1   if(dir) {
	BREQ _0x200A0
; 0001 02D2     if(fs_allocCluster(ALLOCCLUSTER)) goto abort; /* fs_file.entry_start_cluster изменен не будет, там первый кластер папки в которой мы создадим файл */
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x58
	BREQ _0x200A1
	RJMP _0x200A2
; 0001 02D3     allocatedCluster = fs_tmp;
_0x200A1:
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x50
; 0001 02D4   }
; 0001 02D5 
; 0001 02D6   /* Добавляем в папку описатель (сектор не сохранен) */
; 0001 02D7   allocatedEntry = fs_allocEntry();
_0x200A0:
	RCALL _fs_allocEntry_G001
	MOVW R16,R30
; 0001 02D8   if(allocatedEntry == 0) {
	RCALL SUBOPT_0x61
	BRNE _0x200A3
; 0001 02D9 
; 0001 02DA     /* В случае ошибки освобождаем кластер */
; 0001 02DB     fs_tmp = FREE_CLUSTER;
	RCALL SUBOPT_0x2C
; 0001 02DC     fs_setNextCluster(allocatedCluster);
	RCALL SUBOPT_0x52
	RCALL SUBOPT_0x59
; 0001 02DD     goto abort;
	RJMP _0x200A2
; 0001 02DE   }
; 0001 02DF 
; 0001 02E0   /* Устаналиваем имя в описатель. */
; 0001 02E1   memset(allocatedEntry, 0, 32);
_0x200A3:
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x55
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	RCALL SUBOPT_0x56
; 0001 02E2   memcpy(allocatedEntry, new_name, 11);
	RCALL SUBOPT_0x5D
	MOVW R30,R28
	ADIW R30,8
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x68
; 0001 02E3 
; 0001 02E4   if(!dir) {
	BRNE _0x200A4
; 0001 02E5     /* Сохраняем описатель на диск */
; 0001 02E6     if(sd_writeBuf(fs_file.entry_sector)) goto abort;
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x69
	BRNE _0x200A2
; 0001 02E7     /* fs_file.entry_sector, fs_file.entry_index - устанавлиается в fs_allocCluster */
; 0001 02E8     fs_file.entry_start_cluster = 0;
	RCALL SUBOPT_0x5C
	RCALL SUBOPT_0x5B
; 0001 02E9     fs_file.size           = 0;
	RCALL SUBOPT_0x5C
	RCALL SUBOPT_0x63
; 0001 02EA     fs_file.ptr            = 0;
; 0001 02EB #ifndef FS_DISABLE_CHECK
; 0001 02EC     fs_file.opened              = OPENED_FILE;
; 0001 02ED #endif
; 0001 02EE     return 0;
	LDI  R30,LOW(0)
	RJMP _0x2020018
; 0001 02EF   }
; 0001 02F0 
; 0001 02F1   /* Это папка */
; 0001 02F2   allocatedEntry[DIR_Attr] = AM_DIR;
_0x200A4:
	MOVW R30,R16
	ADIW R30,11
	LDI  R26,LOW(16)
	STD  Z+0,R26
; 0001 02F3   fs_setEntryCluster(allocatedEntry, allocatedCluster);
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x6A
; 0001 02F4 
; 0001 02F5   /* Сохраняем описатель на диск */
; 0001 02F6   if(sd_writeBuf(fs_file.entry_sector)) goto abort;
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x69
	BRNE _0x200A2
; 0001 02F7 
; 0001 02F8   /* Сектор для новой папки */
; 0001 02F9   fs_tmp = allocatedCluster;
	RCALL SUBOPT_0x52
	RCALL SUBOPT_0x2F
; 0001 02FA   fs_clust2sect();
	RCALL _fs_clust2sect_G001
; 0001 02FB 
; 0001 02FC   /* Очищаем fs_tmp и за одно buf */
; 0001 02FD   fs_eraseCluster(1);
	RCALL SUBOPT_0x6B
	RCALL _fs_eraseCluster_G001
; 0001 02FE 
; 0001 02FF   /* Создаем пустую папку */
; 0001 0300   memset(buf, ' ', 11); buf[0] = '.'; buf[11] = 0x10;
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x66
	LDI  R30,LOW(46)
	STS  _buf,R30
	LDI  R30,LOW(16)
	__PUTB1MN _buf,11
; 0001 0301   fs_setEntryCluster(buf, allocatedCluster);
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x6A
; 0001 0302 
; 0001 0303   memset(buf+32, ' ', 11); buf[32] = '.'; buf[33] = '.'; buf[32+11] = 0x10;
	RCALL SUBOPT_0x6C
	RCALL SUBOPT_0x66
	LDI  R30,LOW(46)
	__PUTB1MN _buf,32
	__PUTB1MN _buf,33
	LDI  R30,LOW(16)
	__PUTB1MN _buf,43
; 0001 0304   if(fs_notrootdir) fs_setEntryCluster(buf + 32, fs_file.entry_start_cluster); /* Сейчас в fs_file.size==0 значит корневой каталог */
	__GETB1MN _fs_file,20
	CPI  R30,0
	BREQ _0x200A7
	RCALL SUBOPT_0x6C
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x6A
; 0001 0305 
; 0001 0306   /* Сохраняем папку */
; 0001 0307   return sd_writeBuf(fs_tmp);
_0x200A7:
	RCALL SUBOPT_0x25
	RCALL __PUTPARD1
	RCALL _sd_writeBuf_G001
	RJMP _0x2020018
; 0001 0308 abort:
_0x200A2:
; 0001 0309   return 1;
	LDI  R30,LOW(1)
_0x2020018:
	RCALL __LOADLOCR2
	ADIW R28,18
	RET
; 0001 030A }
;
;/**************************************************************************
;*  Открыть файл                                                           *
;**************************************************************************/
;
;BYTE fs_open() {
; 0001 0310 BYTE fs_open() {
_fs_open:
; 0001 0311   if(fs_openany()) goto abort;
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x6D
	BRNE _0x200A9
; 0001 0312 #ifndef FS_DISABLE_CHECK
; 0001 0313   if(fs_file.opened == OPENED_FILE) return 0;
	RCALL SUBOPT_0x64
	BRNE _0x200AA
	RJMP _0x2020011
; 0001 0314   fs_file.opened = OPENED_NONE;
_0x200AA:
	RCALL SUBOPT_0x5
; 0001 0315 #else
; 0001 0316   if((FS_DIRENTRY[DIR_Attr] & AM_DIR) == 0) return 0;
; 0001 0317 #endif
; 0001 0318   lastError = ERR_NO_PATH;
	LDI  R30,LOW(4)
	RCALL SUBOPT_0xB
; 0001 0319 abort:
_0x200A9:
; 0001 031A   return 1;
	RJMP _0x2020014
; 0001 031B }
;
;/**************************************************************************
;*  Открыть папку                                                          *
;**************************************************************************/
;
;BYTE fs_opendir() {
; 0001 0321 BYTE fs_opendir() {
_fs_opendir:
; 0001 0322   if(fs_openany()) goto abort;
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x6D
	BRNE _0x200AC
; 0001 0323 #ifndef FS_DISABLE_CHECK
; 0001 0324   if(fs_file.opened == OPENED_DIR) return 0;
	RCALL SUBOPT_0x41
	CPI  R26,LOW(0x2)
	BRNE _0x200AD
	RJMP _0x2020011
; 0001 0325   fs_file.opened = OPENED_NONE;
_0x200AD:
	RCALL SUBOPT_0x5
; 0001 0326 #else
; 0001 0327   if(FS_DIRENTRY[DIR_Attr] & AM_DIR) return 0;
; 0001 0328 #endif
; 0001 0329   lastError = ERR_NO_PATH;
	LDI  R30,LOW(4)
	RCALL SUBOPT_0xB
; 0001 032A abort:
_0x200AC:
; 0001 032B   return 1;
	RJMP _0x2020014
; 0001 032C }
;
;/**************************************************************************
;*  Вычислить номер следующего сектора для чтения/записи                   *
;*  Вызывается только из fs_read0, fs_write_start                          *
;**************************************************************************/
;
;static BYTE fs_nextRWSector() {
; 0001 0333 static BYTE fs_nextRWSector() {
_fs_nextRWSector_G001:
; 0001 0334   if(fs_file.ptr == 0) {
	RCALL SUBOPT_0x6E
	BRNE _0x200AE
; 0001 0335     /* Чтение файла еще не начато */
; 0001 0336     fs_tmp = fs_file.entry_start_cluster;
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x2F
; 0001 0337   } else {
	RJMP _0x200AF
_0x200AE:
; 0001 0338     /* Еще не конец сектора */
; 0001 0339     if((WORD)fs_file.ptr % 512) return 0;
	RCALL SUBOPT_0x6F
	SBIW R30,0
	BREQ _0x200B0
	RJMP _0x2020011
; 0001 033A 
; 0001 033B     /* Следующий сектор */
; 0001 033C     fs_file.sector++;
_0x200B0:
	RCALL SUBOPT_0x4A
; 0001 033D 
; 0001 033E     /* Еще не конец кластера */
; 0001 033F     if(((fs_file.sector - fs_database) % fs_csize) != 0) return 0;
	RCALL SUBOPT_0x62
	RCALL SUBOPT_0x2E
	RCALL __SUBD12
	RCALL SUBOPT_0x2D
	RCALL __MODD21U
	RCALL __CPD10
	BREQ _0x200B1
	RJMP _0x2020011
; 0001 0340 
; 0001 0341     /* Следующий кластер */
; 0001 0342     fs_tmp = fs_file.cluster;
_0x200B1:
	RCALL SUBOPT_0x70
	RCALL SUBOPT_0x2F
; 0001 0343     if(fs_nextCluster()) return 1;
	RCALL _fs_nextCluster_G001
	CPI  R30,0
	BREQ _0x200B2
	RJMP _0x2020014
; 0001 0344   }
_0x200B2:
_0x200AF:
; 0001 0345 
; 0001 0346   /* Если это был последний кластер, добавляем новый */
; 0001 0347   if(fs_tmp == 0) {
	RCALL SUBOPT_0x25
	RCALL __CPD10
	BRNE _0x200B3
; 0001 0348     if(fs_allocCluster(ALLOCCLUSTER)) return 1;
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x58
	BREQ _0x200B4
	RJMP _0x2020014
; 0001 0349     if(fs_file.ptr == 0) fs_file.entry_start_cluster = fs_tmp;
_0x200B4:
	RCALL SUBOPT_0x6E
	BRNE _0x200B5
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x5B
; 0001 034A                     else fs_setNextCluster(fs_file.cluster); /* fs_tmp сохранится, так как он не LAST и не FREE */
	RJMP _0x200B6
_0x200B5:
	RCALL SUBOPT_0x70
	RCALL SUBOPT_0x59
; 0001 034B   }
_0x200B6:
; 0001 034C 
; 0001 034D   /* Ок */
; 0001 034E   fs_file.cluster = fs_tmp;
_0x200B3:
	RCALL SUBOPT_0x25
	__PUTD1MN _fs_file,24
; 0001 034F   fs_clust2sect();
	RCALL _fs_clust2sect_G001
; 0001 0350   fs_file.sector  = fs_tmp;
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x5A
; 0001 0351   return 0;
	RJMP _0x2020011
; 0001 0352 }
;
;/**************************************************************************
;*  Прочитать из файла несколько байт в buf                                *
;*                                                                         *
;*  Пользователь не должен выходить за пределы файла при чтении, иначе     *
;*  возникнет утечка свобожного места на диске.                            *
;*                                                                         *
;*  Аргументы:                                                             *
;*    ptr      - буфер для чтения, может быть buf                          *
;*    len      - кол-во байт, которые необходимо прочитать                 *
;**************************************************************************/
;
;BYTE fs_read0(BYTE* ptr, WORD len) {
; 0001 035F BYTE fs_read0(BYTE* ptr, WORD len) {
_fs_read0:
; 0001 0360   WORD sectorLen;
; 0001 0361 
; 0001 0362   /* Проверка ошибок программиста */
; 0001 0363 #ifndef FS_DISABLE_CHECK
; 0001 0364   if(fs_file.opened != OPENED_FILE) { lastError = ERR_NOT_OPENED; goto abort; }
	RCALL __SAVELOCR2
;	*ptr -> Y+4
;	len -> Y+2
;	sectorLen -> R16,R17
	RCALL SUBOPT_0x64
	BREQ _0x200B7
	RCALL SUBOPT_0x71
	RJMP _0x200B8
; 0001 0365 #endif
; 0001 0366 
; 0001 0367   while(len) {
_0x200B7:
_0x200B9:
	RCALL SUBOPT_0x72
	SBIW R30,0
	BREQ _0x200BB
; 0001 0368     /* Если указатель находится на границе сектора */
; 0001 0369     if(fs_nextRWSector()) goto abort;
	RCALL _fs_nextRWSector_G001
	CPI  R30,0
	BRNE _0x200B8
; 0001 036A 
; 0001 036B     /* Кол-во байт до конца сектора */
; 0001 036C     sectorLen = 512 - ((WORD)fs_file.ptr % 512);
	RCALL SUBOPT_0x6F
	RCALL SUBOPT_0x73
; 0001 036D     if(len < sectorLen) sectorLen = len;
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CP   R26,R16
	CPC  R27,R17
	BRSH _0x200BD
	__GETWRS 16,17,2
; 0001 036E 
; 0001 036F     /* Читаем данные */
; 0001 0370     if(ptr) {
_0x200BD:
	RCALL SUBOPT_0x67
	SBIW R30,0
	BREQ _0x200BE
; 0001 0371       if(sd_read(ptr, fs_file.sector, (WORD)fs_file.ptr % 512, sectorLen)) goto abort;
	RCALL SUBOPT_0x67
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x62
	RCALL __PUTPARD1
	RCALL SUBOPT_0x6F
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x5D
	RCALL _sd_read
	CPI  R30,0
	BRNE _0x200B8
; 0001 0372       ptr += sectorLen;
	MOVW R30,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL SUBOPT_0x48
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0001 0373     }
; 0001 0374 
; 0001 0375     /* Увеличиваем смещение */
; 0001 0376     fs_file.ptr += sectorLen;
_0x200BE:
	RCALL SUBOPT_0x74
	MOVW R30,R16
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x75
; 0001 0377     len -= sectorLen;
	RCALL SUBOPT_0x72
	SUB  R30,R16
	SBC  R31,R17
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0001 0378   }
	RJMP _0x200B9
_0x200BB:
; 0001 0379 
; 0001 037A   /* Увеличение размера файла */
; 0001 037B   if(fs_file.ptr > fs_file.size) fs_file.size = fs_file.ptr, fs_file.changed = 1;
	RCALL SUBOPT_0x74
	RCALL SUBOPT_0x76
	RCALL __CPD12
	BRSH _0x200C0
	RCALL SUBOPT_0x77
	RCALL SUBOPT_0x78
; 0001 037C 
; 0001 037D   return 0;
_0x200C0:
	LDI  R30,LOW(0)
	RCALL __LOADLOCR2
	RJMP _0x2020002
; 0001 037E abort:
_0x200B8:
; 0001 037F #ifndef FS_DISABLE_CHECK
; 0001 0380   fs_file.opened = OPENED_NONE;
	RCALL SUBOPT_0x5
; 0001 0381 #endif
; 0001 0382   return 1;
	RCALL SUBOPT_0x4F
	RJMP _0x2020002
; 0001 0383 }
;
;/**************************************************************************
;*  Прочитать из файла несколько байт в buf                                *
;*                                                                         *
;*  Аргументы:                                                             *
;*    ptr      - буфер для чтения, может быть buf                          *
;*    len      - кол-во байт, которые необходимо прочитать                 *
;*    readed   - указатель, для сохранения кол-ва реально прочитанных байт *
;**************************************************************************/
;
;BYTE fs_read(BYTE* ptr, WORD len, WORD* readed) {
; 0001 038E BYTE fs_read(BYTE* ptr, WORD len, WORD* readed) {
; 0001 038F   /* Ограничиваем кол-во байт для чтения */
; 0001 0390   if(len > fs_file.size - fs_file.ptr) len = (WORD)(fs_file.size - fs_file.ptr);
;	*ptr -> Y+4
;	len -> Y+2
;	*readed -> Y+0
; 0001 0391   *readed = len;
; 0001 0392 
; 0001 0393   /* Проверка на ошибки происходит там */
; 0001 0394   return fs_read0(ptr, len);
; 0001 0395 }
;
;/**************************************************************************
;*  Сохранить длину файла и превый кластер в опистаель                     *
;*  Вызывается из fs_lseek, fs_write_start, fs_write_end, fs_write_eof     *
;**************************************************************************/
;
;static char fs_saveFileLength() {
; 0001 039C static char fs_saveFileLength() {
_fs_saveFileLength_G001:
; 0001 039D   BYTE* entry;
; 0001 039E 
; 0001 039F   if(fs_file.changed == 0) return 0;
	RCALL __SAVELOCR2
;	*entry -> R16,R17
	__GETB1MN _fs_file,32
	CPI  R30,0
	BRNE _0x200C2
	LDI  R30,LOW(0)
	RJMP _0x2020016
; 0001 03A0   fs_file.changed = 0;
_0x200C2:
	LDI  R30,LOW(0)
	__PUTB1MN _fs_file,32
; 0001 03A1 
; 0001 03A2   /* Изменение описателя файла */
; 0001 03A3   if(sd_readBuf(fs_file.entry_sector)) return 1;
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x8
	BREQ _0x200C3
	RJMP _0x2020017
; 0001 03A4 
; 0001 03A5   entry = buf + (fs_file.entry_index % 16) * 32;
_0x200C3:
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x79
; 0001 03A6   LD_DWORD(entry + DIR_FileSize) = fs_file.size;
	RCALL SUBOPT_0x76
	__PUTD1RNS 16,28
; 0001 03A7   fs_setEntryCluster(entry, fs_file.entry_start_cluster);
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x6A
; 0001 03A8 
; 0001 03A9   return sd_writeBuf(fs_file.entry_sector);
	RCALL SUBOPT_0x3C
	RCALL __PUTPARD1
	RCALL _sd_writeBuf_G001
	RJMP _0x2020016
; 0001 03AA }
;
;/**************************************************************************
;*  Установить смещение чтения/записи файла                                *
;**************************************************************************/
;
;#define LSEEK_STEP 32768
;
;BYTE fs_lseek(DWORD off, BYTE mode) {
; 0001 03B2 BYTE fs_lseek(DWORD off, BYTE mode) {
_fs_lseek:
; 0001 03B3   DWORD l;
; 0001 03B4 
; 0001 03B5   /* Режим */
; 0001 03B6   if(mode==1) off += fs_file.ptr; else
	SBIW R28,4
;	off -> Y+5
;	mode -> Y+4
;	l -> Y+0
	LDD  R26,Y+4
	CPI  R26,LOW(0x1)
	BRNE _0x200C4
	RCALL SUBOPT_0x77
	RJMP _0x2010C
_0x200C4:
; 0001 03B7   if(mode==2) off += fs_file.size;
	LDD  R26,Y+4
	CPI  R26,LOW(0x2)
	BRNE _0x200C6
	RCALL SUBOPT_0x76
_0x2010C:
	__GETD2S 5
	RCALL __ADDD12
	RCALL SUBOPT_0x7A
; 0001 03B8 
; 0001 03B9   /* Можно заменить на fs_file.ptr = 0 для уменьшения кода*/
; 0001 03BA   if(off >= fs_file.ptr) off -= fs_file.ptr; else fs_file.ptr = 0;
_0x200C6:
	RCALL SUBOPT_0x77
	RCALL SUBOPT_0x7B
	RCALL __CPD21
	BRLO _0x200C7
	RCALL SUBOPT_0x77
	RCALL SUBOPT_0x7B
	RCALL __SUBD21
	__PUTD2S 5
	RJMP _0x200C8
_0x200C7:
	RCALL SUBOPT_0x5C
	RCALL SUBOPT_0x75
; 0001 03BB 
; 0001 03BC   do { /* Выполняем один цикл даже для off=0, так как внутри происходит проверка на ошибки */
_0x200C8:
_0x200CA:
; 0001 03BD     l = off;
	RCALL SUBOPT_0x7C
	RCALL SUBOPT_0x11
; 0001 03BE     if(l > LSEEK_STEP) l = LSEEK_STEP;
	RCALL SUBOPT_0x18
	__CPD2N 0x8001
	BRLO _0x200CC
	__GETD1N 0x8000
	RCALL SUBOPT_0x11
; 0001 03BF     if(fs_read0(0, (WORD)l)) return 1;
_0x200CC:
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x72
	RCALL SUBOPT_0x2
	RCALL _fs_read0
	CPI  R30,0
	BREQ _0x200CD
	LDI  R30,LOW(1)
	RJMP _0x202000A
; 0001 03C0     off -= l;
_0x200CD:
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x7C
	RCALL __SUBD12
	RCALL SUBOPT_0x7A
; 0001 03C1   } while(off);
	RCALL SUBOPT_0x7C
	RCALL __CPD10
	BRNE _0x200CA
; 0001 03C2 
; 0001 03C3   /* Размер файла мог изменится */
; 0001 03C4   fs_saveFileLength();
	RCALL _fs_saveFileLength_G001
; 0001 03C5 
; 0001 03C6   /* Результат */
; 0001 03C7   fs_tmp = fs_file.ptr;
	RCALL SUBOPT_0x77
	RCALL SUBOPT_0x2F
; 0001 03C8 
; 0001 03C9   return 0;
	LDI  R30,LOW(0)
	RJMP _0x202000A
; 0001 03CA }
;
;/**************************************************************************
;*  Записать в файл (шаг 1)                                                *
;***************************************************************************/
;
;BYTE fs_write_start() {
; 0001 03D0 BYTE fs_write_start() {
_fs_write_start:
; 0001 03D1   WORD len;
; 0001 03D2 
; 0001 03D3   /* Проверка ошибок программиста */
; 0001 03D4 #ifndef FS_DISABLE_CHECK
; 0001 03D5   if(fs_file.opened != OPENED_FILE) { lastError = ERR_NOT_OPENED; goto abort; }
	RCALL __SAVELOCR2
;	len -> R16,R17
	RCALL SUBOPT_0x64
	BREQ _0x200CE
	RCALL SUBOPT_0x71
	RJMP _0x200CF
; 0001 03D6   if(fs_wtotal == 0) { lastError = ERR_NO_DATA; goto abort; }
_0x200CE:
	RCALL SUBOPT_0x7D
	SBIW R30,0
	BRNE _0x200D0
	LDI  R30,LOW(9)
	RCALL SUBOPT_0xB
	RJMP _0x200CF
; 0001 03D7 #endif
; 0001 03D8 
; 0001 03D9   /* Сколько можно еще дописать в этот сектор? */
; 0001 03DA   len = 512 - (WORD)fs_file.ptr % 512;
_0x200D0:
	RCALL SUBOPT_0x6F
	RCALL SUBOPT_0x73
; 0001 03DB 
; 0001 03DC   /* Ограничиваем остатком данных в файле */
; 0001 03DD   if(len > fs_wtotal) len = (WORD)fs_wtotal;
	RCALL SUBOPT_0x7D
	CP   R30,R16
	CPC  R31,R17
	BRSH _0x200D1
	__GETWRMN 16,17,0,_fs_wtotal
; 0001 03DE 
; 0001 03DF   /* Вычисление fs_file.sector, выделение кластеров */
; 0001 03E0   if(fs_nextRWSector()) goto abort; /* Должно вылетать только по ошибкам ERR_NO_FREE_SPACE, ERR_DISK_ERR */
_0x200D1:
	RCALL _fs_nextRWSector_G001
	CPI  R30,0
	BRNE _0x200CF
; 0001 03E1 
; 0001 03E2   /* Корректируем длину файла */
; 0001 03E3   if(fs_file.size < fs_file.ptr + len) {
	RCALL SUBOPT_0x74
	MOVW R30,R16
	RCALL SUBOPT_0x13
	__GETD2MN _fs_file,20
	RCALL __CPD21
	BRSH _0x200D3
; 0001 03E4     fs_file.size = fs_file.ptr + len;
	RCALL SUBOPT_0x74
	MOVW R30,R16
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x78
; 0001 03E5     fs_file.changed = 1;
; 0001 03E6   }
; 0001 03E7 
; 0001 03E8   /* Читаем данные сектора, если не весь сектор будет заполнен */
; 0001 03E9   if(len != 512) {
_0x200D3:
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CP   R30,R16
	CPC  R31,R17
	BREQ _0x200D4
; 0001 03EA     if(sd_readBuf(fs_file.sector)) goto abort;
	RCALL SUBOPT_0x62
	RCALL SUBOPT_0x8
	BRNE _0x200CF
; 0001 03EB   }
; 0001 03EC 
; 0001 03ED   fs_file_wlen = len;
_0x200D4:
	__PUTWMRN _fs_tmp,0,16,17
; 0001 03EE   fs_file_woff = (WORD)fs_file.ptr % 512;
	RCALL SUBOPT_0x6F
	__PUTW1MN _fs_tmp,2
; 0001 03EF   return 0;
	LDI  R30,LOW(0)
	RJMP _0x2020016
; 0001 03F0 abort:
_0x200CF:
; 0001 03F1   /* Скорее всего это ошибка ERR_NO_FREE_SPACE */
; 0001 03F2   /* Если размер файла был изменен, то надо бы сохранить изменения в описатель файла. */
; 0001 03F3   fs_saveFileLength();
	RCALL _fs_saveFileLength_G001
; 0001 03F4   /* Закрываем файл */
; 0001 03F5 #ifndef FS_DISABLE_CHECK
; 0001 03F6   fs_file.opened = OPENED_NONE;
	RCALL SUBOPT_0x5
; 0001 03F7 #endif
; 0001 03F8   return 1;
_0x2020017:
	LDI  R30,LOW(1)
_0x2020016:
	RCALL __LOADLOCR2P
	RET
; 0001 03F9 }
;
;/**************************************************************************
;*  Записать в файл (шаг 2)                                                *
;***************************************************************************/
;
;BYTE fs_write_end() {
; 0001 03FF BYTE fs_write_end() {
_fs_write_end:
; 0001 0400 #ifndef FS_DISABLE_CHECK
; 0001 0401   if(fs_file.opened != OPENED_FILE) { lastError = ERR_NOT_OPENED; goto abort; }
	RCALL SUBOPT_0x64
	BREQ _0x200D6
	RCALL SUBOPT_0x71
	RJMP _0x200D7
; 0001 0402 #endif
; 0001 0403 
; 0001 0404   /* Записываем изменения на диск */
; 0001 0405   if(sd_writeBuf(fs_file.sector)) goto abort;
_0x200D6:
	RCALL SUBOPT_0x62
	RCALL SUBOPT_0x69
	BRNE _0x200D7
; 0001 0406 
; 0001 0407   /* В случае ошибки файл может содержать больше кластеров, чем требуется по его размеру. */
; 0001 0408   /* Но это не плохо, данные не повреждены. А эта ошибка проявится лишь в уменьшении */
; 0001 0409   /* места на диске. */
; 0001 040A 
; 0001 040B   /* Счетчики */
; 0001 040C   fs_file.ptr += fs_file_wlen;
	RCALL SUBOPT_0x74
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x75
; 0001 040D   fs_wtotal   -= fs_file_wlen;
	LDS  R26,_fs_tmp
	LDS  R27,_fs_tmp+1
	RCALL SUBOPT_0x7D
	SUB  R30,R26
	SBC  R31,R27
	STS  _fs_wtotal,R30
	STS  _fs_wtotal+1,R31
; 0001 040E 
; 0001 040F   /* Если запись закончена, сохраняем размера файла и первый кластер */
; 0001 0410   if(fs_wtotal == 0) {
	RCALL SUBOPT_0x7D
	SBIW R30,0
	BRNE _0x200D9
; 0001 0411     if(fs_saveFileLength()) goto abort;
	RCALL _fs_saveFileLength_G001
	CPI  R30,0
	BRNE _0x200D7
; 0001 0412   }
; 0001 0413 
; 0001 0414   /* Ок */
; 0001 0415   return 0;
_0x200D9:
	RJMP _0x2020011
; 0001 0416 abort:
_0x200D7:
; 0001 0417 #ifndef FS_DISABLE_CHECK
; 0001 0418     fs_file.opened = OPENED_NONE;
	RCALL SUBOPT_0x5
; 0001 0419 #endif
; 0001 041A   return 1;
	RJMP _0x2020014
; 0001 041B }
;
;/**************************************************************************
;*  Освободить цепочку кластеров начиная с fs_tmp                          *
;**************************************************************************/
;
;static BYTE fs_freeChain() {
; 0001 0421 static BYTE fs_freeChain() {
_fs_freeChain_G001:
; 0001 0422   DWORD c;
; 0001 0423   while(1) {
	SBIW R28,4
;	c -> Y+0
_0x200DB:
; 0001 0424     if(fs_tmp < 2 || fs_tmp >= fs_n_fatent) return 0;
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x2A
	BRLO _0x200DF
	RCALL SUBOPT_0x2B
	BRLO _0x200DE
_0x200DF:
	LDI  R30,LOW(0)
	RJMP _0x2020004
; 0001 0425     /* Освободить кластер fs_tmp и записть в fs_tmp следующий за ним кластер */
; 0001 0426     c = fs_tmp, fs_tmp = FREE_CLUSTER;
_0x200DE:
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x2C
; 0001 0427     if(fs_setNextCluster(c)) break; /* fs_tmp будет содержать следующий кластер, так как записывается FREE_CLUSTER */
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x59
	CPI  R30,0
	BREQ _0x200DB
; 0001 0428   }
; 0001 0429   return 1;
	LDI  R30,LOW(1)
	RJMP _0x2020004
; 0001 042A }
;
;/**************************************************************************
;*  Переместить файл/папку                                                 *
;**************************************************************************/
;
;BYTE fs_move0() {
; 0001 0430 BYTE fs_move0() {
_fs_move0:
; 0001 0431   BYTE* entry;
; 0001 0432   BYTE tmp[21];
; 0001 0433   WORD old_index;
; 0001 0434   DWORD old_sector, old_start_cluster;
; 0001 0435 
; 0001 0436 #ifndef FS_DISABLE_CHECK
; 0001 0437   if(fs_file.opened == OPENED_NONE) { lastError = ERR_NOT_OPENED; goto abort; }
	SBIW R28,29
	RCALL __SAVELOCR4
;	*entry -> R16,R17
;	tmp -> Y+12
;	old_index -> R18,R19
;	old_sector -> Y+8
;	old_start_cluster -> Y+4
	LDS  R30,_fs_file
	CPI  R30,0
	BRNE _0x200E2
	RCALL SUBOPT_0x71
	RJMP _0x200E3
; 0001 0438 #endif
; 0001 0439 
; 0001 043A   /* Запоминаем старый описатель */
; 0001 043B   old_index         = fs_file.entry_index;
_0x200E2:
	__GETWRMN 18,19,_fs_file,2
; 0001 043C   old_sector        = fs_file.entry_sector;
	RCALL SUBOPT_0x3C
	__PUTD1S 8
; 0001 043D   old_start_cluster = fs_file.entry_start_cluster;
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0xD
; 0001 043E 
; 0001 043F   /* Создаем новый файл. В папку он превратится позже. 0x80 - это предотвращаем рекурсию. */
; 0001 0440   if(fs_open0(OPENED_FILE | 0x80)) goto abort;
	LDI  R30,LOW(129)
	ST   -Y,R30
	RCALL SUBOPT_0x6D
	BRNE _0x200E3
; 0001 0441 
; 0001 0442   /* Предотвращаем ошибки программиста */
; 0001 0443 #ifndef FS_DISABLE_CHECK
; 0001 0444   fs_file.opened = OPENED_NONE;
	RCALL SUBOPT_0x5
; 0001 0445 #ifndef FS_DISABLE_SWAP
; 0001 0446   fs_secondFile.opened = OPENED_NONE;
	RCALL SUBOPT_0x6
; 0001 0447 #endif
; 0001 0448 #endif
; 0001 0449   /* fs_file.sector содежит первый кластер папки, в которой находится созданный файл. */
; 0001 044A 
; 0001 044B   /* Удаление старого файла/папки и перенос всех свойств */
; 0001 044C   if(sd_readBuf(old_sector)) goto abort;
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x8
	BRNE _0x200E3
; 0001 044D   entry = buf + (old_index % 16) * 32;
	MOVW R30,R18
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x79
; 0001 044E   memcpy(tmp, entry+11, 21);
	MOVW R30,R28
	ADIW R30,12
	RCALL SUBOPT_0x2
	MOVW R30,R16
	ADIW R30,11
	RCALL SUBOPT_0x7E
; 0001 044F   entry[0] = 0xE5;
	MOVW R26,R16
	LDI  R30,LOW(229)
	ST   X,R30
; 0001 0450   if(sd_writeBuf(old_sector)) goto abort;
	RCALL SUBOPT_0x20
	BRNE _0x200E3
; 0001 0451 
; 0001 0452   /* Копируем все свойства новому файлу, тем самым превращая его в папку */
; 0001 0453   if(sd_readBuf(fs_file.entry_sector)) goto abort;
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x8
	BRNE _0x200E3
; 0001 0454   entry = buf + (fs_file.entry_index % 16) * 32;
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x79
; 0001 0455   memcpy(entry+11, tmp, 21);
	MOVW R30,R16
	ADIW R30,11
	RCALL SUBOPT_0x2
	MOVW R30,R28
	ADIW R30,14
	RCALL SUBOPT_0x7E
; 0001 0456   if(sd_writeBuf(fs_file.entry_sector)) goto abort;
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x69
	BRNE _0x200E3
; 0001 0457 
; 0001 0458   /* В папке надо еще скорретировать описатель .. */
; 0001 0459   if(entry[DIR_Attr] & AM_DIR) {
	MOVW R30,R16
	LDD  R30,Z+11
	ANDI R30,LOW(0x10)
	BREQ _0x200E9
; 0001 045A     fs_tmp = old_start_cluster; /* Первый кластер нашей папки */
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x2F
; 0001 045B     fs_clust2sect();
	RCALL _fs_clust2sect_G001
; 0001 045C     if(sd_readBuf(fs_tmp)) goto abort;
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x8
	BRNE _0x200E3
; 0001 045D     fs_setEntryCluster(buf+32, fs_parent_dir_cluster); /* Первый кластер папки предка.*/
	RCALL SUBOPT_0x6C
	RCALL SUBOPT_0x62
	RCALL SUBOPT_0x6A
; 0001 045E     if(sd_writeBuf(fs_tmp)) goto abort;
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x69
	BRNE _0x200E3
; 0001 045F   }
; 0001 0460 
; 0001 0461   return 0;
_0x200E9:
	LDI  R30,LOW(0)
	RJMP _0x2020015
; 0001 0462 abort:
_0x200E3:
; 0001 0463   return 1;
	LDI  R30,LOW(1)
_0x2020015:
	RCALL __LOADLOCR4
	ADIW R28,33
	RET
; 0001 0464 }
;
;BYTE fs_move(const char* from, const char* to) {
; 0001 0466 BYTE fs_move(const char* from, const char* to) {
; 0001 0467   strcpy((char*)buf, from);
;	*from -> Y+2
;	*to -> Y+0
; 0001 0468   if(fs_openany()) return 1;
; 0001 0469   strcpy((char*)buf, to);
; 0001 046A   return fs_move0();
; 0001 046B }
;
;/**************************************************************************
;*  Удалить файл или пустую папку                                          *
;*  Имя файла должно содержаться в buf и не превышать FS_MAXFILE симолов   *
;*  включая терминатор                                                     *
;**************************************************************************/
;
;BYTE fs_delete() {
; 0001 0473 BYTE fs_delete() {
_fs_delete:
; 0001 0474   DWORD entrySector;
; 0001 0475   BYTE* entry;
; 0001 0476 
; 0001 0477   /* Там будет проверен fs_type == FS_ERROR */
; 0001 0478   if(fs_openany()) goto abort;
	SBIW R28,4
	RCALL __SAVELOCR2
;	entrySector -> Y+2
;	*entry -> R16,R17
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x6D
	BRNE _0x200EE
; 0001 0479 
; 0001 047A   /* Предотвращаем ошибки программиста */
; 0001 047B   fs_file.opened = OPENED_NONE;
	RCALL SUBOPT_0x5
; 0001 047C #ifndef FS_DISABLE_SWAP
; 0001 047D   fs_secondFile.opened = OPENED_NONE;
	RCALL SUBOPT_0x6
; 0001 047E #endif
; 0001 047F 
; 0001 0480   /* Корневую папку удалять нельзя */
; 0001 0481   if(FS_DIRENTRY[0] == 0) { lastError = ERR_NO_PATH; goto abort; }
	RCALL SUBOPT_0x3E
	BRNE _0x200EF
	LDI  R30,LOW(4)
	RCALL SUBOPT_0xB
	RJMP _0x200EE
; 0001 0482 
; 0001 0483   /* Сохраняем интерформацию о найденном файле, так как fs_readdir ниже их прибьет */
; 0001 0484   entrySector = fs_file.entry_sector;
_0x200EF:
	RCALL SUBOPT_0x3C
	RCALL SUBOPT_0x50
; 0001 0485   entry = buf + (fs_file.entry_index % 16) * 32;
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x79
; 0001 0486 
; 0001 0487   /* В папке не должно быть файлов */
; 0001 0488   if(FS_DIRENTRY[DIR_Attr] & AM_DIR) {
	RCALL SUBOPT_0x40
	ANDI R30,LOW(0x10)
	BREQ _0x200F0
; 0001 0489     /* Перематывем папку на начало */
; 0001 048A     fs_file.entry_able = 0;
	RCALL SUBOPT_0x34
; 0001 048B     /* Ищем первый файл или папку */
; 0001 048C     /* fs_file.entry_start_cluster сохряняется (содержит первый кластер файла или папки) */
; 0001 048D     if(fs_readdir_nocheck()) goto abort;
	RCALL _fs_readdir_nocheck
	CPI  R30,0
	BRNE _0x200EE
; 0001 048E     /* Если нашли, то ошибка */
; 0001 048F     if(fs_file.entry_able) { lastError = ERR_DIR_NOT_EMPTY; goto abort; }
	RCALL SUBOPT_0x30
	BREQ _0x200F2
	LDI  R30,LOW(7)
	RCALL SUBOPT_0xB
	RJMP _0x200EE
; 0001 0490   }
_0x200F2:
; 0001 0491 
; 0001 0492   /* Удаляем описатель */
; 0001 0493   if(sd_readBuf(entrySector)) goto abort;
_0x200F0:
	RCALL SUBOPT_0x52
	RCALL SUBOPT_0x8
	BRNE _0x200EE
; 0001 0494   entry[0] = 0xE5;
	MOVW R26,R16
	LDI  R30,LOW(229)
	ST   X,R30
; 0001 0495   if(sd_writeBuf(entrySector)) goto abort;
	RCALL SUBOPT_0x52
	RCALL SUBOPT_0x69
	BRNE _0x200EE
; 0001 0496 
; 0001 0497   /* Освобождаем цепочку кластеров */
; 0001 0498   fs_tmp = fs_file.entry_start_cluster;
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x2F
; 0001 0499   return fs_freeChain();
	RCALL _fs_freeChain_G001
	RCALL __LOADLOCR2
	RJMP _0x2020002
; 0001 049A abort:
_0x200EE:
; 0001 049B   return 1;
	RCALL SUBOPT_0x4F
	RJMP _0x2020002
; 0001 049C }
;
;/**************************************************************************
;*  Установить конец файла                                                 *
;**************************************************************************/
;
;BYTE fs_write_eof() {
; 0001 04A2 BYTE fs_write_eof() {
_fs_write_eof:
; 0001 04A3   /* Проверка ошибок программиста */
; 0001 04A4 #ifndef FS_DISABLE_CHECK
; 0001 04A5   if(fs_file.opened != OPENED_FILE) { lastError = ERR_NOT_OPENED; goto abort; }
	RCALL SUBOPT_0x64
	BREQ _0x200F5
	RCALL SUBOPT_0x71
	RJMP _0x200F6
; 0001 04A6 #endif
; 0001 04A7 
; 0001 04A8   /* Корректируем либо FAT, либо описатель файла. */
; 0001 04A9   if(fs_file.ptr == 0) {
_0x200F5:
	RCALL SUBOPT_0x6E
	BRNE _0x200F7
; 0001 04AA     /* Удалем все кластеры файла */
; 0001 04AB     fs_tmp = fs_file.entry_start_cluster;
	RCALL SUBOPT_0x39
	RCALL SUBOPT_0x2F
; 0001 04AC     fs_file.entry_start_cluster = 0;
	RCALL SUBOPT_0x5C
	RCALL SUBOPT_0x5B
; 0001 04AD   } else {
	RJMP _0x200F8
_0x200F7:
; 0001 04AE     /* Этот кластер файла последний. */
; 0001 04AF     fs_tmp = LAST_CLUSTER;
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x2F
; 0001 04B0     if(fs_setNextCluster(fs_file.cluster)) goto abort; /* fs_tmp будет содержать следующий кластер, так как записывается LAST_CLUSTER */
	RCALL SUBOPT_0x70
	RCALL SUBOPT_0x59
	CPI  R30,0
	BRNE _0x200F6
; 0001 04B1   }
_0x200F8:
; 0001 04B2 
; 0001 04B3   /* Удалем все кластеры файла после этого. (они содержатся в fs_tmp); */
; 0001 04B4   if(fs_freeChain()) goto abort;
	RCALL _fs_freeChain_G001
	CPI  R30,0
	BRNE _0x200F6
; 0001 04B5 
; 0001 04B6   /* Сохраняем длну и первый кластер */
; 0001 04B7   fs_file.size    = fs_file.ptr;
	RCALL SUBOPT_0x77
	RCALL SUBOPT_0x78
; 0001 04B8   fs_file.changed = 1;
; 0001 04B9   if(!fs_saveFileLength()) return 0;
	RCALL _fs_saveFileLength_G001
	CPI  R30,0
	BRNE _0x200FB
	RJMP _0x2020011
; 0001 04BA 
; 0001 04BB abort:
_0x200FB:
_0x200F6:
; 0001 04BC #ifndef FS_DISABLE_CHECK
; 0001 04BD   fs_file.opened = OPENED_NONE;
	RCALL SUBOPT_0x5
; 0001 04BE #endif
; 0001 04BF   return 1;
	RJMP _0x2020014
; 0001 04C0 }
;
;/**************************************************************************
;*  Записать в файл                                                        *
;**************************************************************************/
;
;BYTE fs_write(CONST BYTE* ptr, WORD len) {
; 0001 04C6 BYTE fs_write( BYTE* ptr, WORD len) {
; 0001 04C7   /* Проверка на ошибки происходит в вызываемых функциях */
; 0001 04C8 
; 0001 04C9   /* Конец файла */
; 0001 04CA   if(len == 0) return fs_write_eof();
;	*ptr -> Y+2
;	len -> Y+0
; 0001 04CB 
; 0001 04CC   fs_wtotal = len;
; 0001 04CD   do {
; 0001 04CE     if(fs_write_start()) goto abort;
; 0001 04CF     memcpy(fs_file_wbuf, ptr, fs_file_wlen);
; 0001 04D0     ptr += fs_file_wlen;
; 0001 04D1     if(fs_write_end()) goto abort;
; 0001 04D2   } while(fs_wtotal);
; 0001 04D3 
; 0001 04D4   return 0;
; 0001 04D5 abort:
; 0001 04D6   return 1;
; 0001 04D7 }
;
;/**************************************************************************
;*  Переключить файлы                                                      *
;**************************************************************************/
;
;#ifndef FS_DISABLE_SWAP
;void fs_swap() {
; 0001 04DE void fs_swap() {
_fs_swap:
; 0001 04DF   /* Это занимает меньше ПЗУ, чем три функции memcpy */
; 0001 04E0   BYTE t, *a = (BYTE*)&fs_file, *b = (BYTE*)&fs_secondFile, n = sizeof(File);
; 0001 04E1   do {
	RCALL __SAVELOCR6
;	t -> R17
;	*a -> R18,R19
;	*b -> R20,R21
;	n -> R16
	__POINTWRM 18,19,_fs_file
	__POINTWRM 20,21,_fs_secondFile
	LDI  R16,33
_0x20104:
; 0001 04E2     t=*a, *a=*b, *b=t; ++a; ++b;
	MOVW R26,R18
	LD   R17,X
	MOVW R26,R20
	LD   R30,X
	MOVW R26,R18
	ST   X,R30
	MOV  R30,R17
	MOVW R26,R20
	ST   X,R30
	__ADDWRN 18,19,1
	__ADDWRN 20,21,1
; 0001 04E3   } while(--n);
	SUBI R16,LOW(1)
	CPI  R16,0
	BRNE _0x20104
; 0001 04E4 }
	RCALL __LOADLOCR6
	RJMP _0x2020002
;#endif
;
;/**************************************************************************
;*  Расчет свободного места                                                *
;*                                                                         *
;*  Результат в переменной fs_tmp в мегабайтах                             *
;*  Функция закрывает файл                                                 *
;**************************************************************************/
;
;#ifndef FS_DISABLE_GETFREESPACE
;BYTE fs_getfree() {
; 0001 04EF BYTE fs_getfree() {
_fs_getfree:
; 0001 04F0   /* Мы испортим переменную fs_file.sector, поэтому закрываем файл */
; 0001 04F1   fs_file.opened = OPENED_NONE;
	RCALL SUBOPT_0x5
; 0001 04F2 
; 0001 04F3   /* Кол-во свободных кластеров будет в fs_file.sector */
; 0001 04F4   fs_file.sector = 0;
	RCALL SUBOPT_0x5C
	RCALL SUBOPT_0x5A
; 0001 04F5   if(fs_allocCluster(1)) return 1;
	RCALL SUBOPT_0x6B
	RCALL SUBOPT_0x58
	BRNE _0x2020014
; 0001 04F6 
; 0001 04F7   /* Пересчет в мегабайты */
; 0001 04F8   fs_tmp = ((fs_file.sector >> 10) + 1) / 2 * fs_csize;
	RCALL SUBOPT_0x60
	RCALL SUBOPT_0x7F
	RCALL __MULD12U
	RJMP _0x2020010
; 0001 04F9 
; 0001 04FA   return 0;
; 0001 04FB }
;#endif
;
;/**************************************************************************
;*  Размер накопителя в мегабайтах                                         *
;**************************************************************************/
;
;BYTE fs_gettotal() {
; 0001 0502 BYTE fs_gettotal() {
_fs_gettotal:
; 0001 0503   /* Проверка ошибок программиста */
; 0001 0504 #ifndef FS_DISABLE_CHECK
; 0001 0505   if(fs_type == FS_ERROR) { lastError = ERR_NO_FILESYSTEM; return 1; }
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0x20107
	LDI  R30,LOW(1)
	RJMP _0x2020013
; 0001 0506 #endif
; 0001 0507 
; 0001 0508   fs_tmp = ((fs_n_fatent >> 10) + 1) / 2 * fs_csize;
_0x20107:
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x7F
	RCALL __MULD12U
	RJMP _0x2020010
; 0001 0509   return 0;
; 0001 050A }
;
;/**************************************************************************
;*  Размер файла                                                           *
;**************************************************************************/
;
;BYTE fs_getfilesize() {
; 0001 0510 BYTE fs_getfilesize() {
_fs_getfilesize:
; 0001 0511 #ifndef FS_DISABLE_CHECK
; 0001 0512   if(fs_file.opened != OPENED_FILE) {
	RCALL SUBOPT_0x64
	BRNE _0x2020012
; 0001 0513     lastError = ERR_NOT_OPENED;
; 0001 0514     return 1;
; 0001 0515   }
; 0001 0516 #endif
; 0001 0517   fs_tmp = fs_file.size;
	RCALL SUBOPT_0x76
	RJMP _0x2020010
; 0001 0518   return 0;
; 0001 0519 }
;
;/**************************************************************************
;*  Указатель чтения записи файла                                          *
;**************************************************************************/
;
;BYTE fs_tell() {
; 0001 051F BYTE fs_tell() {
_fs_tell:
; 0001 0520 #ifndef FS_DISABLE_CHECK
; 0001 0521   if(fs_file.opened != OPENED_FILE) {
	RCALL SUBOPT_0x64
	BREQ _0x20109
; 0001 0522     lastError = ERR_NOT_OPENED;
_0x2020012:
	LDI  R30,LOW(3)
_0x2020013:
	STS  _lastError,R30
; 0001 0523     return 1;
_0x2020014:
	LDI  R30,LOW(1)
	RET
; 0001 0524   }
; 0001 0525 #endif
; 0001 0526   fs_tmp = fs_file.ptr;
_0x20109:
	RCALL SUBOPT_0x77
_0x2020010:
	STS  _fs_tmp,R30
	STS  _fs_tmp+1,R31
	STS  _fs_tmp+2,R22
	STS  _fs_tmp+3,R23
; 0001 0527   return 0;
_0x2020011:
	LDI  R30,LOW(0)
	RET
; 0001 0528 }
;/*
;It is an open source software to implement SD routines to
;small embedded systems. This is a free software and is opened for education,
;research and commercial developments under license policy of following trems.
;
;(C) 2013 vinxru (aleksey.f.morozov@gmail.com)
;
;It is a free software and there is NO WARRANTY.
;No restriction on use. You can use, modify and redistribute it for
;personal, non-profit or commercial use UNDER YOUR RESPONSIBILITY.
;Redistributions of source code must retain the above copyright notice.
;
;Version 0.99 5-05-2013
;*/
;
;#include "common.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include "sd.h"
;#include "fs.h"
;
;BYTE sd_sdhc; /* Используется SDHC карта */
;
;/**************************************************************************
;*  Протокол SPI для ATMega8                                               *
;*  Может отличаться для разных МК.                                        *
;**************************************************************************/
;
;/* Куда подключена линия CS карты */
;#define SD_CS_ENABLE    PORTB &= ~0x04;
;#define SD_CS_DISABLE   PORTB |= 0x04;
;
;/* Совместимость с разными версиями CodeVisionAVR */
;#ifndef SPI2X
;#define SPI2X 0
;#endif
;
;#define SPI_INIT      { SPCR = 0x52; SPSR = 0x00; }
;#define SPI_HIGHSPEED { SPCR = 0x50; SPSR |= (1<<SPI2X); delay_ms(1); }
;
;static void spi_transmit(BYTE data) {
; 0002 0028 static void spi_transmit(BYTE data) {

	.CSEG
_spi_transmit_G002:
; 0002 0029   SPDR = data;
;	data -> Y+0
	LD   R30,Y
	OUT  0xF,R30
; 0002 002A   while((SPSR & 0x80) == 0);
_0x40003:
	SBIS 0xE,7
	RJMP _0x40003
; 0002 002B }
_0x202000F:
	ADIW R28,1
	RET
;
;static BYTE spi_receive() {
; 0002 002D static BYTE spi_receive() {
_spi_receive_G002:
; 0002 002E   SPDR = 0xFF;
	LDI  R30,LOW(255)
	OUT  0xF,R30
; 0002 002F   while((SPSR & 0x80) == 0);
_0x40006:
	SBIS 0xE,7
	RJMP _0x40006
; 0002 0030   return SPDR;
	IN   R30,0xF
	RET
; 0002 0031 }
;
;/**************************************************************************
;*  Отправка команды                                                       *
;**************************************************************************/
;
;/* Используемые каманды SD карты */
;
;#define GO_IDLE_STATE      (0x40 | 0 )
;#define SEND_IF_COND       (0x40 | 8 )
;#define READ_SINGLE_BLOCK  (0x40 | 17)
;#define WRITE_SINGLE_BLOCK (0x40 | 24)
;#define SD_SEND_OP_COND    (0x40 | 41)
;#define APP_CMD            (0x40 | 55)
;#define READ_OCR           (0x40 | 58)
;
;static BYTE sd_sendCommand(BYTE cmd, DWORD arg) {
; 0002 0041 static BYTE sd_sendCommand(BYTE cmd, DWORD arg) {
_sd_sendCommand_G002:
; 0002 0042   BYTE response, retry;
; 0002 0043 
; 0002 0044   /* Размещение этого кода тут -4 команды, хотя вроде лишине проверки */
; 0002 0045   if(sd_sdhc == 0 && (cmd==READ_SINGLE_BLOCK || cmd==WRITE_SINGLE_BLOCK))
	RCALL __SAVELOCR2
;	cmd -> Y+6
;	arg -> Y+2
;	response -> R17
;	retry -> R16
	LDI  R30,LOW(0)
	CP   R30,R9
	BRNE _0x4000A
	LDD  R26,Y+6
	CPI  R26,LOW(0x51)
	BREQ _0x4000B
	CPI  R26,LOW(0x58)
	BRNE _0x4000A
_0x4000B:
	RJMP _0x4000D
_0x4000A:
	RJMP _0x40009
_0x4000D:
; 0002 0046     arg <<= 9;
	__GETD2S 2
	LDI  R30,LOW(9)
	RCALL __LSLD12
	RCALL SUBOPT_0x50
; 0002 0047 
; 0002 0048   /* Выбираем карту */
; 0002 0049   SD_CS_ENABLE
_0x40009:
	CBI  0x18,2
; 0002 004A 
; 0002 004B   /* Заголовок команды */
; 0002 004C   spi_transmit(cmd);
	LDD  R30,Y+6
	RCALL SUBOPT_0x80
; 0002 004D   spi_transmit(((BYTE*)&arg)[3]);
	LDD  R30,Y+5
	RCALL SUBOPT_0x80
; 0002 004E   spi_transmit(((BYTE*)&arg)[2]);
	LDD  R30,Y+4
	RCALL SUBOPT_0x80
; 0002 004F   spi_transmit(((BYTE*)&arg)[1]);
	LDD  R30,Y+3
	RCALL SUBOPT_0x80
; 0002 0050   spi_transmit(((BYTE*)&arg)[0]);
	LDD  R30,Y+2
	RCALL SUBOPT_0x80
; 0002 0051 
; 0002 0052   /* Пару каоманд требуют CRC. Остальные же команды игнорируют его, поэтому упрощаем код */
; 0002 0053   spi_transmit(cmd == SEND_IF_COND ? 0x87 : 0x95);
	LDD  R26,Y+6
	CPI  R26,LOW(0x48)
	BRNE _0x4000E
	LDI  R30,LOW(135)
	RJMP _0x4000F
_0x4000E:
	LDI  R30,LOW(149)
_0x4000F:
	RCALL SUBOPT_0x80
; 0002 0054 
; 0002 0055   /* Ждем подтвреждение (256 тактов) */
; 0002 0056   retry = 0;
	LDI  R16,LOW(0)
; 0002 0057   while((response = spi_receive()) == 0xFF)
_0x40011:
	RCALL _spi_receive_G002
	MOV  R17,R30
	CPI  R30,LOW(0xFF)
	BRNE _0x40013
; 0002 0058     if(++retry == 0) break;
	SUBI R16,-LOW(1)
	CPI  R16,0
	BRNE _0x40011
; 0002 0059 
; 0002 005A   /* Результат команды READ_OCR обрабатываем тут, так как в конце этой функции мы снимем CS и пропускаем 1 байт */
; 0002 005B   if(response == 0 && cmd == READ_OCR) {
_0x40013:
	CPI  R17,0
	BRNE _0x40016
	LDD  R26,Y+6
	CPI  R26,LOW(0x7A)
	BREQ _0x40017
_0x40016:
	RJMP _0x40015
_0x40017:
; 0002 005C     /* 32 бита из которых нас интересует один бит */
; 0002 005D     sd_sdhc = spi_receive() & 0x40;
	RCALL _spi_receive_G002
	ANDI R30,LOW(0x40)
	MOV  R9,R30
; 0002 005E     spi_receive();
	RCALL _spi_receive_G002
; 0002 005F     spi_receive();
	RCALL _spi_receive_G002
; 0002 0060     spi_receive();
	RCALL _spi_receive_G002
; 0002 0061   }
; 0002 0062 
; 0002 0063   /* отпускаем CS и пауза в 1 байт*/
; 0002 0064   SD_CS_DISABLE
_0x40015:
	SBI  0x18,2
; 0002 0065   spi_receive();
	RCALL _spi_receive_G002
; 0002 0066 
; 0002 0067   return response;
	MOV  R30,R17
	RCALL __LOADLOCR2
	ADIW R28,7
	RET
; 0002 0068 }
;
;/**************************************************************************
;*  Проверка готовности/наличия карты                                      *
;**************************************************************************/
;
;BYTE sd_check() {
; 0002 006E BYTE sd_check() {
_sd_check:
; 0002 006F   BYTE i = 0;
; 0002 0070   do {
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
_0x40019:
; 0002 0071     sd_sendCommand(APP_CMD, 0);
	LDI  R30,LOW(119)
	RCALL SUBOPT_0x81
; 0002 0072     if(sd_sendCommand(SD_SEND_OP_COND, 0x40000000) == 0) return 0;
	LDI  R30,LOW(105)
	ST   -Y,R30
	__GETD1N 0x40000000
	RCALL SUBOPT_0x82
	BRNE _0x4001B
	LDI  R30,LOW(0)
	RJMP _0x2020005
; 0002 0073   } while(--i);
_0x4001B:
	SUBI R17,LOW(1)
	CPI  R17,0
	BRNE _0x40019
; 0002 0074   return 1;
	LDI  R30,LOW(1)
	RJMP _0x2020005
; 0002 0075 }
;
;/**************************************************************************
;*  Инициализация карты (эта функция вызывается функцией sd_init)          *
;**************************************************************************/
;
;static BYTE sd_init_int() {
; 0002 007B static BYTE sd_init_int() {
_sd_init_int_G002:
; 0002 007C   BYTE i;
; 0002 007D 
; 0002 007E   /* Сбрасываем SDHC флаг */
; 0002 007F   sd_sdhc = 0;
	ST   -Y,R17
;	i -> R17
	CLR  R9
; 0002 0080 
; 0002 0081   /* Минимум 80 пустых тактов */
; 0002 0082   for(i=10; i; --i)
	LDI  R17,LOW(10)
_0x4001D:
	CPI  R17,0
	BREQ _0x4001E
; 0002 0083     spi_receive();
	RCALL _spi_receive_G002
	SUBI R17,LOW(1)
	RJMP _0x4001D
_0x4001E:
; 0002 0086 if(sd_sendCommand((0x40 | 0 ), 0) != 1) goto abort;
	LDI  R30,LOW(64)
	RCALL SUBOPT_0x81
	CPI  R30,LOW(0x1)
	BRNE _0x40020
; 0002 0087 
; 0002 0088   /* CMD8 Узнаем версию карты */
; 0002 0089   i = 0;
	LDI  R17,LOW(0)
; 0002 008A   if(sd_sendCommand(SEND_IF_COND, 0x000001AA))
	LDI  R30,LOW(72)
	ST   -Y,R30
	__GETD1N 0x1AA
	RCALL SUBOPT_0x82
	BREQ _0x40021
; 0002 008B     i = 1;
	LDI  R17,LOW(1)
; 0002 008C 
; 0002 008D   /* CMD41 Ожидание окончания инициализации */
; 0002 008E   if(sd_check()) goto abort;
_0x40021:
	RCALL _sd_check
	CPI  R30,0
	BRNE _0x40020
; 0002 008F 
; 0002 0090   /* Только для второй версии карты */
; 0002 0091   if(i) {
	CPI  R17,0
	BREQ _0x40023
; 0002 0092     /* CMD58 определение SDHC карты. Ответ обрабатывается в функции sd_sendCommand */
; 0002 0093     if(sd_sendCommand(READ_OCR, 0) != 0) goto abort;
	LDI  R30,LOW(122)
	RCALL SUBOPT_0x81
	CPI  R30,0
	BRNE _0x40020
; 0002 0094   }
; 0002 0095 
; 0002 0096   return 0;
_0x40023:
	LDI  R30,LOW(0)
	RJMP _0x2020005
; 0002 0097 abort:
_0x40020:
; 0002 0098   return 1;
	LDI  R30,LOW(1)
	RJMP _0x2020005
; 0002 0099 }
;
;/**************************************************************************
;*  Инициализация карты                                                    *
;**************************************************************************/
;
;BYTE sd_init() {
; 0002 009F BYTE sd_init() {
_sd_init:
; 0002 00A0   BYTE tries;
; 0002 00A1 
; 0002 00A2   /* Освобождаем CS на всякий случай */
; 0002 00A3   SD_CS_DISABLE
	ST   -Y,R17
;	tries -> R17
	SBI  0x18,2
; 0002 00A4 
; 0002 00A5   /* Включаем SPI */
; 0002 00A6   SPI_INIT
	LDI  R30,LOW(82)
	OUT  0xD,R30
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0002 00A7 
; 0002 00A8   /* Делаем несколько попыток инициализации */
; 0002 00A9   tries = 10;
	LDI  R17,LOW(10)
; 0002 00AA   while(sd_init_int())
_0x40025:
	RCALL _sd_init_int_G002
	CPI  R30,0
	BREQ _0x40027
; 0002 00AB     if(--tries == 0) {
	SUBI R17,LOW(1)
	CPI  R17,0
	BRNE _0x40028
; 0002 00AC       lastError = ERR_DISK_ERR;
	RCALL SUBOPT_0x83
; 0002 00AD       return 1;
	RJMP _0x2020005
; 0002 00AE     }
; 0002 00AF 
; 0002 00B0   /* Вклчюаем максимальную скорость */
; 0002 00B1   SPI_HIGHSPEED
_0x40028:
	RJMP _0x40025
_0x40027:
	LDI  R30,LOW(80)
	OUT  0xD,R30
	SBI  0xE,0
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL SUBOPT_0x84
; 0002 00B2 
; 0002 00B3   return 0;
	LDI  R30,LOW(0)
	RJMP _0x2020005
; 0002 00B4 }
;
;/**************************************************************************
;*  Ожидание определенного байта на шине                                   *
;**************************************************************************/
;
;static BYTE sd_waitBus(BYTE byte) {
; 0002 00BA static BYTE sd_waitBus(BYTE byte) {
_sd_waitBus_G002:
; 0002 00BB   WORD retry = 0;
; 0002 00BC   do {
	RCALL __SAVELOCR2
;	byte -> Y+2
;	retry -> R16,R17
	__GETWRN 16,17,0
_0x4002A:
; 0002 00BD     if(spi_receive() == byte) return 0;
	RCALL _spi_receive_G002
	MOV  R26,R30
	LDD  R30,Y+2
	CP   R30,R26
	BRNE _0x4002C
	LDI  R30,LOW(0)
	RCALL __LOADLOCR2
	RJMP _0x202000B
; 0002 00BE   } while(++retry);
_0x4002C:
	MOVW R30,R16
	ADIW R30,1
	MOVW R16,R30
	BRNE _0x4002A
; 0002 00BF   return 1;
	RCALL SUBOPT_0x4F
	RJMP _0x202000B
; 0002 00C0 }
;
;/**************************************************************************
;*  Чтение произвольного участка сектора                                   *
;**************************************************************************/
;
;BYTE sd_read(BYTE* buffer, DWORD sector, WORD offsetInSector, WORD length) {
; 0002 00C6 BYTE sd_read(BYTE* buffer, DWORD sector, WORD offsetInSector, WORD length) {
_sd_read:
; 0002 00C7   BYTE b;
; 0002 00C8   WORD i;
; 0002 00C9 
; 0002 00CA   /* Посылаем команду */
; 0002 00CB   if(sd_sendCommand(READ_SINGLE_BLOCK, sector)) goto abort;
	RCALL __SAVELOCR4
;	*buffer -> Y+12
;	sector -> Y+8
;	offsetInSector -> Y+6
;	length -> Y+4
;	b -> R17
;	i -> R18,R19
	LDI  R30,LOW(81)
	ST   -Y,R30
	__GETD1S 9
	RCALL SUBOPT_0x82
	BRNE _0x4002E
; 0002 00CC 
; 0002 00CD   /* Сразу же возращаем CS, что бы принять ответ команды */
; 0002 00CE   SD_CS_ENABLE
	CBI  0x18,2
; 0002 00CF 
; 0002 00D0   /* Ждем стартовый байт */
; 0002 00D1   if(sd_waitBus(0xFE)) goto abort;
	LDI  R30,LOW(254)
	ST   -Y,R30
	RCALL _sd_waitBus_G002
	CPI  R30,0
	BRNE _0x4002E
; 0002 00D2 
; 0002 00D3   /* Принимаем 512 байт */
; 0002 00D4   for(i=512; i; --i) {
	__GETWRN 18,19,512
_0x40031:
	MOV  R0,R18
	OR   R0,R19
	BREQ _0x40032
; 0002 00D5     b = spi_receive();
	RCALL _spi_receive_G002
	MOV  R17,R30
; 0002 00D6     if(offsetInSector) { offsetInSector--; continue; }
	RCALL SUBOPT_0x85
	SBIW R30,0
	BREQ _0x40033
	RCALL SUBOPT_0x85
	SBIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x40030
; 0002 00D7     if(length == 0) continue;
_0x40033:
	RCALL SUBOPT_0x67
	SBIW R30,0
	BREQ _0x40030
; 0002 00D8     length--;
	RCALL SUBOPT_0x67
	SBIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0002 00D9     *buffer++ = b;
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ADIW R30,1
	STD  Y+12,R30
	STD  Y+12+1,R31
	SBIW R30,1
	ST   Z,R17
; 0002 00DA   }
_0x40030:
	__SUBWRN 18,19,1
	RJMP _0x40031
_0x40032:
; 0002 00DB 
; 0002 00DC   /* CRC игнорируем */
; 0002 00DD   spi_receive();
	RCALL _spi_receive_G002
; 0002 00DE   spi_receive();
	RCALL _spi_receive_G002
; 0002 00DF 
; 0002 00E0   /* отпускаем CS и пауза в 1 байт*/
; 0002 00E1   SD_CS_DISABLE
	SBI  0x18,2
; 0002 00E2   spi_receive();
	RCALL _spi_receive_G002
; 0002 00E3 
; 0002 00E4   /* Ок */
; 0002 00E5   return 0;
	LDI  R30,LOW(0)
	RJMP _0x202000D
; 0002 00E6 
; 0002 00E7   /* Ошибка и отпускаем CS.*/
; 0002 00E8 abort:
_0x4002E:
; 0002 00E9   SD_CS_DISABLE
	SBI  0x18,2
; 0002 00EA   lastError = ERR_DISK_ERR;
	RCALL SUBOPT_0x83
; 0002 00EB   return 1;
_0x202000D:
	RCALL __LOADLOCR4
_0x202000E:
	ADIW R28,14
	RET
; 0002 00EC }
;
;/**************************************************************************
;*  Запись сектора (512 байт)                                              *
;**************************************************************************/
;
;BYTE sd_write512(BYTE* buffer, DWORD sector) {
; 0002 00F2 BYTE sd_write512(BYTE* buffer, DWORD sector) {
_sd_write512:
; 0002 00F3   WORD n;
; 0002 00F4 
; 0002 00F5   /* Посылаем команду */
; 0002 00F6   if(sd_sendCommand(WRITE_SINGLE_BLOCK, sector)) goto abort;
	RCALL __SAVELOCR2
;	*buffer -> Y+6
;	sector -> Y+2
;	n -> R16,R17
	LDI  R30,LOW(88)
	ST   -Y,R30
	__GETD1S 3
	RCALL SUBOPT_0x82
	BRNE _0x40036
; 0002 00F7 
; 0002 00F8   /* Сразу же возращаем CS, что бы отправить блок данных */
; 0002 00F9   SD_CS_ENABLE
	CBI  0x18,2
; 0002 00FA 
; 0002 00FB   /* Посылаем стартовый байт */
; 0002 00FC   spi_transmit(0xFE);
	LDI  R30,LOW(254)
	RCALL SUBOPT_0x80
; 0002 00FD 
; 0002 00FE   /* Данные */
; 0002 00FF   for(n=512; n; --n)
	__GETWRN 16,17,512
_0x40038:
	RCALL SUBOPT_0x61
	BREQ _0x40039
; 0002 0100     spi_transmit(*buffer++);
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
	RCALL SUBOPT_0x80
	__SUBWRN 16,17,1
	RJMP _0x40038
_0x40039:
; 0002 0103 spi_transmit(0xFF);
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x80
; 0002 0104   spi_transmit(0xFF);
	LDI  R30,LOW(255)
	RCALL SUBOPT_0x80
; 0002 0105 
; 0002 0106   /* Ответ МК */
; 0002 0107   if((spi_receive() & 0x1F) != 0x05) goto abort;
	RCALL _spi_receive_G002
	ANDI R30,LOW(0x1F)
	CPI  R30,LOW(0x5)
	BRNE _0x40036
; 0002 0108 
; 0002 0109   /* Ждем окончания записи, т.е. пока не освободится шина */
; 0002 010A   if(sd_waitBus(0xFF)) goto abort;
	LDI  R30,LOW(255)
	ST   -Y,R30
	RCALL _sd_waitBus_G002
	CPI  R30,0
	BRNE _0x40036
; 0002 010B 
; 0002 010C   /* отпускаем CS и пауза в 1 байт*/
; 0002 010D   SD_CS_DISABLE
	SBI  0x18,2
; 0002 010E   spi_receive();
	RCALL _spi_receive_G002
; 0002 010F 
; 0002 0110   /* Ок */
; 0002 0111   return 0;
	LDI  R30,LOW(0)
	RJMP _0x202000C
; 0002 0112 
; 0002 0113   /* Ошибка.*/
; 0002 0114 abort:
_0x40036:
; 0002 0115   SD_CS_DISABLE
	SBI  0x18,2
; 0002 0116   lastError = ERR_DISK_ERR;
	RCALL SUBOPT_0x83
; 0002 0117   return 1;
_0x202000C:
	RCALL __LOADLOCR2
	ADIW R28,8
	RET
; 0002 0118 }
;// SD Controller for Computer "Radio 86RK" / "Apogee BK01"
;// (c) 10-05-2014 vinxru (aleksey.f.morozov@gmail.com)
;
;//#include <stdafx.h>
;
;#define F_CPU 8000000UL        //freq 8 MHz
;
;#include "common.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <string.h>
;#include "sd.h"
;#include "fs.h"
;#include "proto.h"
;
;#ifndef X86_DEBUG
;#include <delay.h>
;#endif
;
;#define O_OPEN   0
;#define O_CREATE 1
;#define O_MKDIR  2
;#define O_DELETE 100
;#define O_SWAP   101
;
;#define ERR_START       0x40
;#define ERR_WAIT        0x41
;#define ERR_OK_DISK         0x42
;#define ERR_OK_CMD          0x43
;#define ERR_OK_READ         0x44
;#define ERR_OK_ENTRY        0x45
;#define ERR_OK_WRITE        0x46
;#define ERR_OK_RKS          0x47
;#define ERR_READ_BLOCK      0x4F
;
;BYTE buf[512];
;BYTE rom[128];
;
;/*******************************************************************************
;* Для удобства                                                                 *
;*******************************************************************************/
;
;void recvBin(BYTE* d, WORD l) {
; 0003 0029 void recvBin(BYTE* d, WORD l) {

	.CSEG
_recvBin:
; 0003 002A   for(; l; --l) {
;	*d -> Y+2
;	l -> Y+0
_0x60004:
	RCALL SUBOPT_0x53
	SBIW R30,0
	BREQ _0x60005
; 0003 002B     *d++ = wrecv();
	RCALL SUBOPT_0x72
	ADIW R30,1
	STD  Y+2,R30
	STD  Y+2+1,R31
	SBIW R30,1
	PUSH R31
	PUSH R30
	RCALL _wrecv
	POP  R26
	POP  R27
	ST   X,R30
; 0003 002C   }
	RCALL SUBOPT_0x86
	RJMP _0x60004
_0x60005:
; 0003 002D }
	RJMP _0x2020004
;
;void recvString() {
; 0003 002F void recvString() {
_recvString:
; 0003 0030   BYTE c;
; 0003 0031   BYTE* p = buf;
; 0003 0032   do {
	RCALL __SAVELOCR4
;	c -> R17
;	*p -> R18,R19
	__POINTWRM 18,19,_buf
_0x60007:
; 0003 0033     c = wrecv();
	RCALL SUBOPT_0x87
; 0003 0034     if(p != buf + FS_MAXFILE) *p++ = c; else lastError = ERR_RECV_STRING;
	__POINTW1MN _buf,469
	CP   R30,R18
	CPC  R31,R19
	BREQ _0x60009
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	MOV  R30,R17
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x6000A
_0x60009:
	LDI  R30,LOW(11)
	RCALL SUBOPT_0xB
; 0003 0035   } while(c);
_0x6000A:
	CPI  R17,0
	BRNE _0x60007
; 0003 0036 }
	RCALL __LOADLOCR4
	RJMP _0x2020004
;
;void sendBin(BYTE* p, WORD l) {
; 0003 0038 void sendBin(BYTE* p, WORD l) {
_sendBin:
; 0003 0039   for(; l; l--)
;	*p -> Y+2
;	l -> Y+0
_0x6000C:
	RCALL SUBOPT_0x53
	SBIW R30,0
	BREQ _0x6000D
; 0003 003A     send(*p++);
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LD   R30,X+
	STD  Y+2,R26
	STD  Y+2+1,R27
	RCALL SUBOPT_0x88
	RCALL SUBOPT_0x86
	RJMP _0x6000C
_0x6000D:
; 0003 003B }
	RJMP _0x2020004
;
;void sendBinf(flash BYTE* d, BYTE l) {
; 0003 003D void sendBinf(flash BYTE* d, BYTE l) {
_sendBinf:
; 0003 003E   for(; l; --l)
;	*d -> Y+1
;	l -> Y+0
_0x6000F:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x60010
; 0003 003F     send(*d++);
	RCALL SUBOPT_0x65
	LPM  R30,Z
	RCALL SUBOPT_0x88
	LD   R30,Y
	SUBI R30,LOW(1)
	ST   Y,R30
	RJMP _0x6000F
_0x60010:
; 0003 0040 }
_0x202000B:
	ADIW R28,3
	RET
;
;/*******************************************************************************
;* Отправка всех блоков файла                                                   *
;*******************************************************************************/
;
;WORD readLength;
;
;void readInt(char rks) {
; 0003 0048 void readInt(char rks) {
_readInt:
; 0003 0049   WORD readedLength, lengthFromFile;
; 0003 004A   BYTE tmp;
; 0003 004B   BYTE* wptr;
; 0003 004C 
; 0003 004D   while(readLength) {
	SBIW R28,2
	RCALL __SAVELOCR6
;	rks -> Y+8
;	readedLength -> R16,R17
;	lengthFromFile -> R18,R19
;	tmp -> R21
;	*wptr -> Y+6
_0x60011:
	MOV  R0,R10
	OR   R0,R11
	BRNE PC+2
	RJMP _0x60013
; 0003 004E     // Расчет длины блока (выравниваем чтение на сектор)
; 0003 004F     if(fs_tell()) return;
	RCALL _fs_tell
	CPI  R30,0
	BREQ _0x60014
	RJMP _0x2020009
; 0003 0050     readedLength = 512 - (fs_tmp % 512);
_0x60014:
	RCALL SUBOPT_0x25
	__ANDD1N 0x1FF
	__GETD2N 0x200
	RCALL __SWAPD12
	RCALL __SUBD12
	MOVW R16,R30
; 0003 0051     if(readedLength > readLength) readedLength = readLength;
	__CPWRR 10,11,16,17
	BRSH _0x60015
	MOVW R16,R10
; 0003 0052 
; 0003 0053     // Уменьшаем счетчик
; 0003 0054     readLength -= readedLength;
_0x60015:
	__SUBWRR 10,11,16,17
; 0003 0055 
; 0003 0056     // Читаем блок
; 0003 0057     if(fs_read0(buf, readedLength)) return;
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x5D
	RCALL _fs_read0
	CPI  R30,0
	BREQ _0x60016
	RJMP _0x2020009
; 0003 0058 
; 0003 0059     // Заголовок RKS файла
; 0003 005A     wptr = buf;
_0x60016:
	RCALL SUBOPT_0x47
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0003 005B     if(rks) { // Если rks=1, перед вызовом надо проверить, что бы readLength>4 и fs_file.ptr=0, иначе может быть злостный сбой
	RCALL SUBOPT_0x49
	BREQ _0x60017
; 0003 005C       rks = 0;
	LDI  R30,LOW(0)
	STD  Y+8,R30
; 0003 005D 
; 0003 005E       // У апогея числа перепутаны
; 0003 005F       tmp=buf[0], buf[0]=buf[1]; buf[1]=tmp;
	LDS  R21,_buf
	__GETB1MN _buf,1
	STS  _buf,R30
	__PUTBMRN _buf,1,21
; 0003 0060       tmp=buf[2], buf[2]=buf[3]; buf[3]=tmp;
	__GETBRMN 21,_buf,2
	__GETB1MN _buf,3
	__PUTB1MN _buf,2
	__PUTBMRN _buf,3,21
; 0003 0061 
; 0003 0062       // Посылаем адрес загрузки
; 0003 0063       send(ERR_OK_RKS);
	LDI  R30,LOW(71)
	RCALL SUBOPT_0x88
; 0003 0064       sendBin(buf, 2);
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x89
; 0003 0065       send(ERR_WAIT);
	RCALL SUBOPT_0x8A
; 0003 0066 
; 0003 0067       // Корректируем указатели
; 0003 0068       wptr += 4;
	RCALL SUBOPT_0x85
	ADIW R30,4
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0003 0069       readedLength -= 4;
	__SUBWRN 16,17,4
; 0003 006A 
; 0003 006B       // Длина из файла
; 0003 006C       lengthFromFile = *(WORD*)(buf+2) - *(WORD*)(buf) + 1;
	__GETW1MN _buf,2
	LDS  R26,_buf
	LDS  R27,_buf+1
	SUB  R30,R26
	SBC  R31,R27
	ADIW R30,1
	MOVW R18,R30
; 0003 006D 
; 0003 006E       // Корректируем длину
; 0003 006F       if(readedLength > lengthFromFile) {
	__CPWRR 18,19,16,17
	BRSH _0x60018
; 0003 0070         readedLength = lengthFromFile;
	MOVW R16,R18
; 0003 0071       } else {
	RJMP _0x60019
_0x60018:
; 0003 0072         lengthFromFile -= readedLength;
	__SUBWRR 18,19,16,17
; 0003 0073         if(readLength > lengthFromFile) lengthFromFile = readedLength;
	__CPWRR 18,19,10,11
	BRSH _0x6001A
	MOVW R18,R16
; 0003 0074       }
_0x6001A:
_0x60019:
; 0003 0075     }
; 0003 0076 
; 0003 0077     // Отправляем блок
; 0003 0078     send(ERR_READ_BLOCK);
_0x60017:
	LDI  R30,LOW(79)
	RCALL SUBOPT_0x88
; 0003 0079     sendBin((BYTE*)&readedLength, 2);
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	RCALL SUBOPT_0x2
	PUSH R17
	PUSH R16
	RCALL SUBOPT_0x89
	POP  R16
	POP  R17
; 0003 007A     sendBin(wptr, readedLength);
	RCALL SUBOPT_0x85
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x5D
	RCALL _sendBin
; 0003 007B     send(ERR_WAIT);
	RCALL SUBOPT_0x8A
; 0003 007C   }
	RJMP _0x60011
_0x60013:
; 0003 007D 
; 0003 007E   // Если все ОК
; 0003 007F   if(!lastError) lastError = ERR_OK_READ;
	RCALL SUBOPT_0x8B
	BRNE _0x6001B
	LDI  R30,LOW(68)
	RCALL SUBOPT_0xB
; 0003 0080 }
_0x6001B:
_0x2020009:
	RCALL __LOADLOCR6
_0x202000A:
	ADIW R28,9
	RET
;
;/*******************************************************************************
;* Версия команд контроллера                                                    *
;*******************************************************************************/
;
;void cmd_ver() {
; 0003 0086 void cmd_ver() {
_cmd_ver:
; 0003 0087   sendStart(1);
	RCALL SUBOPT_0x6B
	RCALL _sendStart
; 0003 0088 
; 0003 0089   // Версия + Производитель
; 0003 008A   sendBinf("V1.0 10-05-2014 ", 16);
	__POINTW1FN _0x60000,0
	RCALL SUBOPT_0x2
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _sendBinf
; 0003 008B               //0123456789ABCDEF
; 0003 008C }
	RET
;
;/*******************************************************************************
;* BOOT / EXEC                                                                  *
;*******************************************************************************/
;
;void cmd_boot_exec() {
; 0003 0092 void cmd_boot_exec() {
_cmd_boot_exec:
; 0003 0093   // Файл по умолчанию
; 0003 0094   if(buf[0]==0) strcpyf(buf, "boot/sdbios.rk");
	LDS  R30,_buf
	CPI  R30,0
	BRNE _0x6001C
	RCALL SUBOPT_0x54
	__POINTW1FN _0x60000,17
	RCALL SUBOPT_0x2
	RCALL _strcpyf
; 0003 0095 
; 0003 0096   // Открываем файл
; 0003 0097   if(fs_open()) return;
_0x6001C:
	RCALL _fs_open
	CPI  R30,0
	BREQ _0x6001D
	RET
; 0003 0098 
; 0003 0099   // Максимальный размер файла
; 0003 009A   readLength = 0xFFFF;
_0x6001D:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R10,R30
; 0003 009B   if(fs_getfilesize()) return;
	RCALL SUBOPT_0x8C
	BREQ _0x6001E
	RET
; 0003 009C   if(readLength > fs_tmp) readLength = (WORD)fs_tmp;
_0x6001E:
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x8D
	BRSH _0x6001F
	__GETWRMN 10,11,0,_fs_tmp
; 0003 009D 
; 0003 009E   // Файлы RK должны быть длиной >4 байт. Мы заносим в readLength = 0 и программа
; 0003 009F   // получает ERR_OK. Но так как она ждем ERR_OK_RKS, это будет ошибкой
; 0003 00A0   if(readLength < 4) readLength = 0;
_0x6001F:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R10,R30
	CPC  R11,R31
	BRSH _0x60020
	CLR  R10
	CLR  R11
; 0003 00A1 
; 0003 00A2   readInt(/*rks*/1);
_0x60020:
	RCALL SUBOPT_0x6B
	RCALL _readInt
; 0003 00A3 }
	RET
;
;void cmd_boot() {
; 0003 00A5 void cmd_boot() {
_cmd_boot:
; 0003 00A6   sendStart(ERR_WAIT);
	RCALL SUBOPT_0x8E
; 0003 00A7   buf[0] = 0;
	LDI  R30,LOW(0)
	STS  _buf,R30
; 0003 00A8   cmd_boot_exec();
	RJMP _0x2020008
; 0003 00A9 }
;
;void cmd_exec() {
; 0003 00AB void cmd_exec() {
_cmd_exec:
; 0003 00AC   // Прием имени файла
; 0003 00AD   recvString();
	RCALL SUBOPT_0x8F
; 0003 00AE 
; 0003 00AF   // Режим передачи и подтверждение
; 0003 00B0   sendStart(ERR_WAIT);
; 0003 00B1   if(lastError) return; // Переполнение строки
	RCALL SUBOPT_0x8B
	BREQ _0x60021
	RET
; 0003 00B2 
; 0003 00B3   cmd_boot_exec();
_0x60021:
_0x2020008:
	RCALL _cmd_boot_exec
; 0003 00B4 }
	RET
;
;/*******************************************************************************
;* Начать/продолжить посик файлов в папке                                       *
;*******************************************************************************/
;
;typedef struct {
;    char    fname[11];    // File name
;    BYTE    fattrib;    // Attribute
;    DWORD   fsize;        // File size
;    union {
;      struct {
;        WORD    ftime;        // Last modified time
;        WORD    fdate;        // Last modified date
;      };
;      DWORD ftimedate;
;    };
;} FILINFO2;
;
;void cmd_find() {
; 0003 00C7 void cmd_find() {
_cmd_find:
; 0003 00C8   WORD n;
; 0003 00C9   FILINFO2 info;
; 0003 00CA 
; 0003 00CB   // Принимаем путь
; 0003 00CC   recvString();
	SBIW R28,20
	RCALL __SAVELOCR2
;	n -> R16,R17
;	info -> Y+2
	RCALL _recvString
; 0003 00CD 
; 0003 00CE   // Принимаем макс кол-во элементов
; 0003 00CF   recvBin((BYTE*)&n, 2);
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	RCALL SUBOPT_0x2
	PUSH R17
	PUSH R16
	RCALL SUBOPT_0x90
	POP  R16
	POP  R17
; 0003 00D0 
; 0003 00D1   // Режим передачи и подтверждение
; 0003 00D2   sendStart(ERR_WAIT);
	RCALL SUBOPT_0x8E
; 0003 00D3   if(lastError) return;
	RCALL SUBOPT_0x8B
	BRNE _0x2020007
; 0003 00D4 
; 0003 00D5   // Открываем папку
; 0003 00D6   if(buf[0] != ':') {
	LDS  R26,_buf
	CPI  R26,LOW(0x3A)
	BREQ _0x60023
; 0003 00D7     if(fs_opendir()) return;
	RCALL _fs_opendir
	CPI  R30,0
	BRNE _0x2020007
; 0003 00D8   }
; 0003 00D9 
; 0003 00DA   for(; n; --n) {
_0x60023:
_0x60026:
	RCALL SUBOPT_0x61
	BREQ _0x60027
; 0003 00DB     /* Читаем очереной описатель */
; 0003 00DC     if(fs_readdir()) return;
	RCALL _fs_readdir
	CPI  R30,0
	BRNE _0x2020007
; 0003 00DD 
; 0003 00DE     /* Конец */
; 0003 00DF     if(FS_DIRENTRY[0] == 0) {
	RCALL SUBOPT_0x3E
	BRNE _0x60029
; 0003 00E0       lastError = ERR_OK_CMD;
	LDI  R30,LOW(67)
	RJMP _0x2020006
; 0003 00E1       return;
; 0003 00E2     }
; 0003 00E3 
; 0003 00E4     /* Сжимаем ответ для компьютера */
; 0003 00E5     memcpy(info.fname, FS_DIRENTRY+DIR_Name, 12);
_0x60029:
	MOVW R30,R28
	ADIW R30,2
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3B
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	RCALL SUBOPT_0x2
	RCALL _memcpy
; 0003 00E6     memcpy(&info.fsize, FS_DIRENTRY+DIR_FileSize, 4);
	MOVW R30,R28
	ADIW R30,14
	RCALL SUBOPT_0x2
	__POINTW1MN _buf,508
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x2
	RCALL _memcpy
; 0003 00E7     memcpy(&info.ftimedate, FS_DIRENTRY+DIR_WrtTime, 4);
	MOVW R30,R28
	ADIW R30,18
	RCALL SUBOPT_0x2
	__POINTW1MN _buf,502
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x2
	RCALL _memcpy
; 0003 00E8     //memcpy(memcpy(memcpy(info.fname, FS_DIRENTRY+DIR_Name, 12, FS_DIRENTRY+DIR_FileSize, 4), FS_DIRENTRY+DIR_WrtTime, 4);
; 0003 00E9 
; 0003 00EA     /* Отправляем */
; 0003 00EB     send(ERR_OK_ENTRY);
	LDI  R30,LOW(69)
	RCALL SUBOPT_0x88
; 0003 00EC     sendBin((BYTE*)&info, sizeof(info));
	MOVW R30,R28
	ADIW R30,2
	RCALL SUBOPT_0x2
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x2
	RCALL _sendBin
; 0003 00ED     send(ERR_WAIT);
	RCALL SUBOPT_0x8A
; 0003 00EE   }
	__SUBWRN 16,17,1
	RJMP _0x60026
_0x60027:
; 0003 00EF 
; 0003 00F0   /* Ограничение по размеру */
; 0003 00F1   lastError = ERR_MAX_FILES; /*! Надо опеределать, что бы не было ложных ошибок */
	LDI  R30,LOW(10)
_0x2020006:
	STS  _lastError,R30
; 0003 00F2 }
_0x2020007:
	RCALL __LOADLOCR2
	ADIW R28,22
	RET
;
;/*******************************************************************************
;* Открыть/создать файл/папку                                                   *
;*******************************************************************************/
;
;void cmd_open() {
; 0003 00F8 void cmd_open() {
_cmd_open:
; 0003 00F9   BYTE mode;
; 0003 00FA 
; 0003 00FB   /* Принимаем режим */
; 0003 00FC   mode = wrecv();
	ST   -Y,R17
;	mode -> R17
	RCALL SUBOPT_0x87
; 0003 00FD 
; 0003 00FE   // Принимаем имя файла
; 0003 00FF   recvString();
	RCALL SUBOPT_0x8F
; 0003 0100 
; 0003 0101   // Режим передачи и подтверждение
; 0003 0102   sendStart(ERR_WAIT);
; 0003 0103 
; 0003 0104   // Открываем/создаем файл/папку
; 0003 0105   if(mode == O_SWAP) {
	CPI  R17,101
	BRNE _0x6002A
; 0003 0106     fs_swap();
	RCALL _fs_swap
; 0003 0107   } else
	RJMP _0x6002B
_0x6002A:
; 0003 0108   if(mode == O_DELETE) {
	CPI  R17,100
	BRNE _0x6002C
; 0003 0109     fs_delete();
	RCALL _fs_delete
; 0003 010A   } else
	RJMP _0x6002D
_0x6002C:
; 0003 010B   if(mode == O_OPEN) {
	CPI  R17,0
	BRNE _0x6002E
; 0003 010C     fs_open();
	RCALL _fs_open
; 0003 010D   } else
	RJMP _0x6002F
_0x6002E:
; 0003 010E   if(mode < 3) {
	CPI  R17,3
	BRSH _0x60030
; 0003 010F     fs_open0(mode);
	ST   -Y,R17
	RCALL _fs_open0
; 0003 0110   } else {
	RJMP _0x60031
_0x60030:
; 0003 0111     lastError = ERR_INVALID_COMMAND;
	LDI  R30,LOW(12)
	RCALL SUBOPT_0xB
; 0003 0112   }
_0x60031:
_0x6002F:
_0x6002D:
_0x6002B:
; 0003 0113 
; 0003 0114   // Ок
; 0003 0115   if(!lastError) lastError = ERR_OK_CMD;
	RCALL SUBOPT_0x8B
	BRNE _0x60032
	LDI  R30,LOW(67)
	RCALL SUBOPT_0xB
; 0003 0116 }
_0x60032:
_0x2020005:
	LD   R17,Y+
	RET
;
;/*******************************************************************************
;* Переместить файл/папку                                                       *
;*******************************************************************************/
;
;void cmd_move() {
; 0003 011C void cmd_move() {
_cmd_move:
; 0003 011D   recvString();
	RCALL SUBOPT_0x8F
; 0003 011E   sendStart(ERR_WAIT);
; 0003 011F   fs_openany();
	RCALL SUBOPT_0x55
	RCALL _fs_open0
; 0003 0120   sendStart(ERR_OK_WRITE);
	LDI  R30,LOW(70)
	ST   -Y,R30
	RCALL _sendStart
; 0003 0121   recvStart();
	RCALL _recvStart
; 0003 0122   recvString();
	RCALL SUBOPT_0x8F
; 0003 0123   sendStart(ERR_WAIT);
; 0003 0124   if(!lastError) fs_move0();
	RCALL SUBOPT_0x8B
	BRNE _0x60033
	RCALL _fs_move0
; 0003 0125   if(!lastError) lastError = ERR_OK_CMD;
_0x60033:
	RCALL SUBOPT_0x8B
	BRNE _0x60034
	LDI  R30,LOW(67)
	RCALL SUBOPT_0xB
; 0003 0126 }
_0x60034:
	RET
;
;/*******************************************************************************
;* Установить/прочитать указатель чтения                                        *
;*******************************************************************************/
;
;void cmd_lseek() {
; 0003 012C void cmd_lseek() {
_cmd_lseek:
; 0003 012D   BYTE mode;
; 0003 012E   DWORD off;
; 0003 012F 
; 0003 0130   // Принимаем режим и смещение
; 0003 0131   mode = wrecv();
	SBIW R28,4
	ST   -Y,R17
;	mode -> R17
;	off -> Y+1
	RCALL SUBOPT_0x87
; 0003 0132   recvBin((BYTE*)&off, 4);
	MOVW R30,R28
	ADIW R30,1
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x2
	RCALL _recvBin
; 0003 0133 
; 0003 0134   // Режим передачи и подтверждение
; 0003 0135   sendStart(ERR_WAIT);
	RCALL SUBOPT_0x8E
; 0003 0136 
; 0003 0137   // Размер файла
; 0003 0138   if(mode==100) {
	CPI  R17,100
	BRNE _0x60035
; 0003 0139     if(fs_getfilesize()) return;
	RCALL SUBOPT_0x8C
	BREQ _0x60036
	LDD  R17,Y+0
	RJMP _0x2020001
; 0003 013A   }
_0x60036:
; 0003 013B 
; 0003 013C   // Размер диска
; 0003 013D   else if(mode==101) {
	RJMP _0x60037
_0x60035:
	CPI  R17,101
	BRNE _0x60038
; 0003 013E     if(fs_gettotal()) return;
	RCALL _fs_gettotal
	CPI  R30,0
	BREQ _0x60039
	LDD  R17,Y+0
	RJMP _0x2020001
; 0003 013F   }
_0x60039:
; 0003 0140 
; 0003 0141   // Свободное место на диске
; 0003 0142   else if(mode==102) {
	RJMP _0x6003A
_0x60038:
	CPI  R17,102
	BRNE _0x6003B
; 0003 0143     if(fs_getfree()) return;
	RCALL _fs_getfree
	CPI  R30,0
	BREQ _0x6003C
	LDD  R17,Y+0
	RJMP _0x2020001
; 0003 0144   }
_0x6003C:
; 0003 0145 
; 0003 0146   else {
	RJMP _0x6003D
_0x6003B:
; 0003 0147     /* Устаналиваем смещение. fs_tmp сохраняется */
; 0003 0148     if(fs_lseek(off, mode)) return;
	__GETD1S 1
	RCALL __PUTPARD1
	ST   -Y,R17
	RCALL _fs_lseek
	CPI  R30,0
	BREQ _0x6003E
	LDD  R17,Y+0
	RJMP _0x2020001
; 0003 0149   }
_0x6003E:
_0x6003D:
_0x6003A:
_0x60037:
; 0003 014A 
; 0003 014B   // Передаем результат
; 0003 014C   send(ERR_OK_CMD);
	LDI  R30,LOW(67)
	RCALL SUBOPT_0x88
; 0003 014D   sendBin((BYTE*)&fs_tmp, 4);
	LDI  R30,LOW(_fs_tmp)
	LDI  R31,HIGH(_fs_tmp)
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x2
	RCALL _sendBin
; 0003 014E   lastError = 0; // На всякий случай, результат уже передан
	LDI  R30,LOW(0)
	RCALL SUBOPT_0xB
; 0003 014F }
	LDD  R17,Y+0
	RJMP _0x2020001
;
;/*******************************************************************************
;* Прочитать из файла                                                           *
;*******************************************************************************/
;
;void cmd_read() {
; 0003 0155 void cmd_read() {
_cmd_read:
; 0003 0156   DWORD s;
; 0003 0157 
; 0003 0158   // Длина
; 0003 0159   recvBin((BYTE*)&readLength, 2);
	SBIW R28,4
;	s -> Y+0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x90
; 0003 015A 
; 0003 015B   // Режим передачи и подтверждение
; 0003 015C   sendStart(ERR_WAIT);
	RCALL SUBOPT_0x8E
; 0003 015D 
; 0003 015E   // Ограничиваем длину длиной файла
; 0003 015F   if(fs_getfilesize()) return;
	RCALL SUBOPT_0x8C
	BRNE _0x2020004
; 0003 0160   s = fs_tmp;
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x11
; 0003 0161   if(fs_tell()) return;
	RCALL _fs_tell
	CPI  R30,0
	BRNE _0x2020004
; 0003 0162   s -= fs_tmp;
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x10
	RCALL __SUBD12
	RCALL SUBOPT_0x11
; 0003 0163 
; 0003 0164   if(readLength > s)
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x8D
	BRSH _0x60041
; 0003 0165     readLength = (WORD)s;
	__GETWRS 10,11,0
; 0003 0166 
; 0003 0167   // Отправляем все блоки файла
; 0003 0168   readInt(/*rks*/0);
_0x60041:
	RCALL SUBOPT_0x55
	RCALL _readInt
; 0003 0169 }
_0x2020004:
	ADIW R28,4
	RET
;
;/*******************************************************************************
;* Записать данные в файл                                                       *
;*******************************************************************************/
;
;void cmd_write() {
; 0003 016F void cmd_write() {
_cmd_write:
; 0003 0170   // Аргументы
; 0003 0171   recvBin((BYTE*)&fs_wtotal, 2);
	LDI  R30,LOW(_fs_wtotal)
	LDI  R31,HIGH(_fs_wtotal)
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x90
; 0003 0172 
; 0003 0173   // Ответ
; 0003 0174   sendStart(ERR_WAIT);
	RCALL SUBOPT_0x8E
; 0003 0175 
; 0003 0176   // Конец файла
; 0003 0177   if(fs_wtotal==0) {
	RCALL SUBOPT_0x7D
	SBIW R30,0
	BRNE _0x60042
; 0003 0178     fs_write_eof();
	RCALL _fs_write_eof
; 0003 0179     lastError = ERR_OK_CMD;
	RJMP _0x2020003
; 0003 017A     return;
; 0003 017B   }
; 0003 017C 
; 0003 017D   // Запись данных
; 0003 017E   do {
_0x60042:
_0x60044:
; 0003 017F     if(fs_write_start()) return;
	RCALL _fs_write_start
	CPI  R30,0
	BREQ _0x60046
	RET
; 0003 0180 
; 0003 0181     // Принимаем от компьюетра блок данных
; 0003 0182     send(ERR_OK_WRITE);
_0x60046:
	LDI  R30,LOW(70)
	RCALL SUBOPT_0x88
; 0003 0183     sendBin((BYTE*)&fs_file_wlen, 2);
	LDI  R30,LOW(_fs_tmp)
	LDI  R31,HIGH(_fs_tmp)
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x89
; 0003 0184     recvStart();
	RCALL _recvStart
; 0003 0185     recvBin(fs_file_wbuf, fs_file_wlen);
	__GETW1MN _fs_tmp,2
	RCALL SUBOPT_0x57
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x2
	RCALL _recvBin
; 0003 0186     sendStart(ERR_WAIT);
	RCALL SUBOPT_0x8E
; 0003 0187 
; 0003 0188     if(fs_write_end()) return;
	RCALL _fs_write_end
	CPI  R30,0
	BREQ _0x60047
	RET
; 0003 0189   } while(fs_wtotal);
_0x60047:
	RCALL SUBOPT_0x7D
	SBIW R30,0
	BRNE _0x60044
; 0003 018A 
; 0003 018B   lastError = ERR_OK_CMD;
_0x2020003:
	LDI  R30,LOW(67)
	RCALL SUBOPT_0xB
; 0003 018C }
	RET
;
;/*******************************************************************************
;* Главная процедура                                                            *
;*******************************************************************************/
;
;void error() {
; 0003 0192 void error() {
_error:
; 0003 0193   for(;;) {
_0x60049:
; 0003 0194     PORTB.0 = 1;
	SBI  0x18,0
; 0003 0195     delay_ms(100);
	RCALL SUBOPT_0x91
; 0003 0196     PORTB.0 = 0;
	CBI  0x18,0
; 0003 0197     delay_ms(100);
	RCALL SUBOPT_0x91
; 0003 0198   }
	RJMP _0x60049
; 0003 0199 }
;
;void main() {
; 0003 019B void main() {
_main:
; 0003 019C   BYTE c, d;
; 0003 019D 
; 0003 019E   DATA_OUT            // Шина данных (DDRD)
;	c -> R17
;	d -> R16
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0003 019F   DDRC  = 0b00000000; // Шина адреса
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0003 01A0   DDRB  = 0b00101101; // Шина адреса, карта и светодиод
	LDI  R30,LOW(45)
	OUT  0x17,R30
; 0003 01A1   PORTB = 0b00010001; // Подтягивающий резистор на MISO и светодиод
	LDI  R30,LOW(17)
	OUT  0x18,R30
; 0003 01A2 
; 0003 01A3   // Пауза, пока не стабилизируется питание
; 0003 01A4   delay_ms(100);
	RCALL SUBOPT_0x91
; 0003 01A5 
; 0003 01A6   // Запуск файловой системы
; 0003 01A7   if(fs_init()) error();
	RCALL _fs_init
	CPI  R30,0
	BREQ _0x6004F
	RCALL _error
; 0003 01A8   strcpyf(buf, "boot/boot.rk");
_0x6004F:
	RCALL SUBOPT_0x54
	__POINTW1FN _0x60000,32
	RCALL SUBOPT_0x2
	RCALL _strcpyf
; 0003 01A9   if(fs_open()) error();
	RCALL _fs_open
	CPI  R30,0
	BREQ _0x60050
	RCALL _error
; 0003 01AA   if(fs_getfilesize()) error();
_0x60050:
	RCALL SUBOPT_0x8C
	BREQ _0x60051
	RCALL _error
; 0003 01AB   if(fs_tmp < 7) error();
_0x60051:
	RCALL SUBOPT_0x29
	__CPD2N 0x7
	BRSH _0x60052
	RCALL _error
; 0003 01AC   if(fs_tmp > 128) error();
_0x60052:
	RCALL SUBOPT_0x29
	__CPD2N 0x81
	BRLO _0x60053
	RCALL _error
; 0003 01AD   if(fs_read0(rom, (WORD)fs_tmp)) error();
_0x60053:
	LDI  R30,LOW(_rom)
	LDI  R31,HIGH(_rom)
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x2
	RCALL _fs_read0
	CPI  R30,0
	BREQ _0x60054
	RCALL _error
; 0003 01AE 
; 0003 01AF   // Гасим светодиод
; 0003 01B0   PORTB.0 = 0;
_0x60054:
	CBI  0x18,0
; 0003 01B1 
; 0003 01B2   while(1) {
_0x60057:
; 0003 01B3     // Эмуляция ПЗУ
; 0003 01B4 #asm
; 0003 01B5 .EQU PIND  = $10
.EQU PIND  = $10
; 0003 01B6 .EQU DDRD  = $11
.EQU DDRD  = $11
; 0003 01B7 .EQU PORTD = $12
.EQU PORTD = $12
; 0003 01B8 .EQU PINC  = $13
.EQU PINC  = $13
; 0003 01B9 .EQU DDRC  = $14
.EQU DDRC  = $14
; 0003 01BA .EQU PORTC = $15
.EQU PORTC = $15
; 0003 01BB .EQU PINB  = $16
.EQU PINB  = $16
; 0003 01BC .EQU DDRB  = $17
.EQU DDRB  = $17
; 0003 01BD .EQU PORTB = $18
.EQU PORTB = $18
; 0003 01BE .EQU ROM   = 1
.EQU ROM   = 1
; 0003 01BF 

; 0003 01C0 .macro GET_ADDR
.macro GET_ADDR
; 0003 01C1         IN   R30, PINC         ; Младшие 6 бит
        IN   R30, PINC         ; Младшие 6 бит
; 0003 01C2         ANDI R30, 0x3F
        ANDI R30, 0x3F
; 0003 01C3         IN   R26, PINB         ; Старший бит
        IN   R26, PINB         ; Старший бит
; 0003 01C4         ANDI R26, 0x40
        ANDI R26, 0x40
; 0003 01C5         OR   R30, R26
        OR   R30, R26
; 0003 01C6 .endmacro
.endmacro
; 0003 01C7 

; 0003 01C8 .macro ROM_EMU
.macro ROM_EMU
; 0003 01C9         LD   R30, Z
        LD   R30, Z
; 0003 01CA         OUT  PORTD, R30
        OUT  PORTD, R30
; 0003 01CB .endmacro
.endmacro
; 0003 01CC 

; 0003 01CD         ; Устаналвиается один раз для ROM_EMU
        ; Устаналвиается один раз для ROM_EMU
; 0003 01CE         PUSH R26
        PUSH R26
; 0003 01CF         PUSH R30
        PUSH R30
; 0003 01D0         PUSH R31
        PUSH R31
; 0003 01D1         LDI  R31, ROM
        LDI  R31, ROM
; 0003 01D2 

; 0003 01D3         ; Получаем адрес
        ; Получаем адрес
; 0003 01D4         GET_ADDR
        GET_ADDR
; 0003 01D5 

; 0003 01D6         ; Эмулируем ПЗУ
        ; Эмулируем ПЗУ
; 0003 01D7 LOOP0:  ROM_EMU
LOOP0:  ROM_EMU
; 0003 01D8 

; 0003 01D9         ; Получаем адрес и если это не 0x44, то переходим в начало
        ; Получаем адрес и если это не 0x44, то переходим в начало
; 0003 01DA         GET_ADDR
        GET_ADDR
; 0003 01DB         CPI  R30, 0x44
        CPI  R30, 0x44
; 0003 01DC         BRNE LOOP0
        BRNE LOOP0
; 0003 01DD 

; 0003 01DE         ; Эмулируем ПЗУ (0x44-ый адрес)
        ; Эмулируем ПЗУ (0x44-ый адрес)
; 0003 01DF         ROM_EMU
        ROM_EMU
; 0003 01E0 

; 0003 01E1         ; Получаем адрес и если это все еще 0x44, то ждем.
        ; Получаем адрес и если это все еще 0x44, то ждем.
; 0003 01E2         ; Если это не 0x40, то переходим в начало
        ; Если это не 0x40, то переходим в начало
; 0003 01E3 LOOP1:  GET_ADDR
LOOP1:  GET_ADDR
; 0003 01E4         CPI  R30, 0x44
        CPI  R30, 0x44
; 0003 01E5         BREQ LOOP1
        BREQ LOOP1
; 0003 01E6         CPI  R30, 0x40
        CPI  R30, 0x40
; 0003 01E7         BRNE LOOP0
        BRNE LOOP0
; 0003 01E8 

; 0003 01E9         ; Эмулируем ПЗУ (0x40-ый адрес)
        ; Эмулируем ПЗУ (0x40-ый адрес)
; 0003 01EA         ROM_EMU
        ROM_EMU
; 0003 01EB 

; 0003 01EC         ; Получаем адрес и если это все еще 0x40, то ждем.
        ; Получаем адрес и если это все еще 0x40, то ждем.
; 0003 01ED         ; Если это не 0, то переходим в начало
        ; Если это не 0, то переходим в начало
; 0003 01EE LOOP2:  GET_ADDR
LOOP2:  GET_ADDR
; 0003 01EF         CPI  R30, 0x40
        CPI  R30, 0x40
; 0003 01F0         BREQ LOOP2
        BREQ LOOP2
; 0003 01F1         CPI  R30, 0
        CPI  R30, 0
; 0003 01F2         BRNE LOOP0
        BRNE LOOP0
; 0003 01F3 

; 0003 01F4         POP R31
        POP R31
; 0003 01F5         POP R30
        POP R30
; 0003 01F6         POP R26
        POP R26
; 0003 01F7 #endasm
; 0003 01F8 
; 0003 01F9     // Зажигаем светодиод
; 0003 01FA     PORTB.0 = 1;
	SBI  0x18,0
; 0003 01FB 
; 0003 01FC     // Проверяем наличие карты
; 0003 01FD     sendStart(ERR_START);
	LDI  R30,LOW(64)
	ST   -Y,R30
	RCALL _sendStart
; 0003 01FE     send(ERR_WAIT);
	RCALL SUBOPT_0x8A
; 0003 01FF     if(fs_check()) {
	RCALL _fs_check
	CPI  R30,0
	BREQ _0x6005C
; 0003 0200       send(ERR_DISK_ERR);
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x88
; 0003 0201     } else {
	RJMP _0x6005D
_0x6005C:
; 0003 0202       send(ERR_OK_DISK);
	LDI  R30,LOW(66)
	RCALL SUBOPT_0x88
; 0003 0203       recvStart();
	RCALL _recvStart
; 0003 0204       c = wrecv();
	RCALL SUBOPT_0x87
; 0003 0205 
; 0003 0206       // Сбрасываем ошибку
; 0003 0207       lastError = 0;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0xB
; 0003 0208 
; 0003 0209       // Принимаем аргументы
; 0003 020A       switch(c) {
	RCALL SUBOPT_0x45
; 0003 020B         case 0:  cmd_boot();         break;
	SBIW R30,0
	BRNE _0x60061
	RCALL _cmd_boot
	RJMP _0x60060
; 0003 020C         case 1:  cmd_ver();          break;
_0x60061:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x60062
	RCALL _cmd_ver
	RJMP _0x60060
; 0003 020D         case 2:  cmd_exec();         break;
_0x60062:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x60063
	RCALL _cmd_exec
	RJMP _0x60060
; 0003 020E         case 3:  cmd_find();         break;
_0x60063:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x60064
	RCALL _cmd_find
	RJMP _0x60060
; 0003 020F         case 4:  cmd_open();         break;
_0x60064:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x60065
	RCALL _cmd_open
	RJMP _0x60060
; 0003 0210         case 5:  cmd_lseek();        break;
_0x60065:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x60066
	RCALL _cmd_lseek
	RJMP _0x60060
; 0003 0211         case 6:  cmd_read();         break;
_0x60066:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x60067
	RCALL _cmd_read
	RJMP _0x60060
; 0003 0212         case 7:  cmd_write();        break;
_0x60067:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x60068
	RCALL _cmd_write
	RJMP _0x60060
; 0003 0213         case 8:  cmd_move();         break;
_0x60068:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x6006A
	RCALL _cmd_move
	RJMP _0x60060
; 0003 0214         default: lastError = ERR_INVALID_COMMAND;
_0x6006A:
	LDI  R30,LOW(12)
	RCALL SUBOPT_0xB
; 0003 0215       }
_0x60060:
; 0003 0216 
; 0003 0217       // Вывод ошибки
; 0003 0218       if(lastError) sendStart(lastError);
	RCALL SUBOPT_0x8B
	BREQ _0x6006B
	LDS  R30,_lastError
	ST   -Y,R30
	RCALL _sendStart
; 0003 0219     }
_0x6006B:
_0x6005D:
; 0003 021A 
; 0003 021B     // Порт рабоатет на выход
; 0003 021C     wait();
	RCALL _wait
; 0003 021D     DATA_OUT
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0003 021E 
; 0003 021F     // Гасим светодиод
; 0003 0220     PORTB.0 = 0;
	CBI  0x18,0
; 0003 0221   }
	RJMP _0x60057
; 0003 0222 }
_0x6006E:
	RJMP _0x6006E

	.CSEG
_memcmp:
    clr  r22
    clr  r23
    ld   r24,y+
    ld   r25,y+
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
memcmp0:
    adiw r24,0
    breq memcmp1
    sbiw r24,1
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    breq memcmp0
memcmp1:
    sub  r22,r23
    brcc memcmp2
    ldi  r30,-1
    ret
memcmp2:
    ldi  r30,0
    breq memcmp3
    inc  r30
memcmp3:
    ret
_memcpy:
    ldd  r25,y+1
    ld   r24,y
    adiw r24,0
    breq memcpy1
    ldd  r27,y+5
    ldd  r26,y+4
    ldd  r31,y+3
    ldd  r30,y+2
memcpy0:
    ld   r22,z+
    st   x+,r22
    sbiw r24,1
    brne memcpy0
memcpy1:
    ldd  r31,y+5
    ldd  r30,y+4
_0x2020002:
	ADIW R28,6
	RET
_memset:
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x2020001:
	ADIW R28,5
	RET
_strcpyf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret

	.DSEG
_rom:
	.BYTE 0x80
_buf:
	.BYTE 0x200
_fs_tmp:
	.BYTE 0x4
_lastError:
	.BYTE 0x1
_fs_wtotal:
	.BYTE 0x2
_fs_fatbase:
	.BYTE 0x4
_fs_fatbase2:
	.BYTE 0x4
_fs_n_fatent:
	.BYTE 0x4
_fs_dirbase:
	.BYTE 0x4
_fs_database:
	.BYTE 0x4
_fs_fatoptim:
	.BYTE 0x4
_fs_file:
	.BYTE 0x21
_fs_secondFile:
	.BYTE 0x21

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(_buf)
	LDI  R31,HIGH(_buf)
	ST   -Y,R31
	ST   -Y,R30
	__GETD1S 2
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 83 TIMES, CODE SIZE REDUCTION:80 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	RCALL SUBOPT_0x2
	RJMP _sd_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x4:
	STS  _fs_fatoptim,R30
	STS  _fs_fatoptim+1,R31
	STS  _fs_fatoptim+2,R22
	STS  _fs_fatoptim+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	STS  _fs_file,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	STS  _fs_secondFile,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x7:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x8:
	RCALL __PUTPARD1
	RCALL _sd_readBuf_G001
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	__PUTD1S 8
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xB:
	STS  _lastError,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xC:
	CLR  R22
	CLR  R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xD:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xE:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	RCALL SUBOPT_0xC
	RCALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x10:
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x11:
	RCALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	__GETW1MN _buf,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	RCALL SUBOPT_0xC
	RCALL __ADDD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x14:
	RCALL SUBOPT_0xE
	LDS  R26,_fs_fatbase
	LDS  R27,_fs_fatbase+1
	LDS  R24,_fs_fatbase+2
	LDS  R25,_fs_fatbase+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x15:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x17:
	RCALL __CWD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x18:
	RCALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	MOV  R30,R4
	RCALL SUBOPT_0x15
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1B:
	LDS  R26,_fs_n_fatent
	LDS  R27,_fs_n_fatent+1
	LDS  R24,_fs_n_fatent+2
	LDS  R25,_fs_n_fatent+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1C:
	STS  _fs_dirbase,R30
	STS  _fs_dirbase+1,R31
	STS  _fs_dirbase+2,R22
	STS  _fs_dirbase+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1D:
	__SUBD1N -1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	__GETD1MN _buf,508
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	__GETD2N 0xFFFFFFFF
	RCALL __PUTDZ20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	RCALL SUBOPT_0x7
	RCALL __PUTPARD1
	RCALL _sd_writeBuf_G001
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(_fs_tmp)
	LDI  R31,HIGH(_fs_tmp)
	RCALL SUBOPT_0x2
	LDS  R26,_fs_tmp
	LDS  R27,_fs_tmp+1
	LDS  R24,_fs_tmp+2
	LDS  R25,_fs_tmp+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x22:
	__GETD1N 0x100
	RCALL __DIVD21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x23:
	LDS  R26,_fs_fatbase
	LDS  R27,_fs_fatbase+1
	LDS  R24,_fs_fatbase+2
	LDS  R25,_fs_fatbase+3
	RCALL __ADDD12
	RCALL __PUTPARD1
	LDS  R26,_fs_tmp
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:166 WORDS
SUBOPT_0x25:
	LDS  R30,_fs_tmp
	LDS  R31,_fs_tmp+1
	LDS  R22,_fs_tmp+2
	LDS  R23,_fs_tmp+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x26:
	__GETD1N 0x80
	RCALL __DIVD21U
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	CLR  R27
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	RCALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x28:
	RCALL SUBOPT_0x2
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:82 WORDS
SUBOPT_0x29:
	LDS  R26,_fs_tmp
	LDS  R27,_fs_tmp+1
	LDS  R24,_fs_tmp+2
	LDS  R25,_fs_tmp+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2A:
	__CPD2N 0x2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x2B:
	LDS  R30,_fs_n_fatent
	LDS  R31,_fs_n_fatent+1
	LDS  R22,_fs_n_fatent+2
	LDS  R23,_fs_n_fatent+3
	RCALL SUBOPT_0x29
	RCALL __CPD21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(0)
	STS  _fs_tmp,R30
	STS  _fs_tmp+1,R30
	STS  _fs_tmp+2,R30
	STS  _fs_tmp+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	RCALL SUBOPT_0x19
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2E:
	LDS  R26,_fs_database
	LDS  R27,_fs_database+1
	LDS  R24,_fs_database+2
	LDS  R25,_fs_database+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:82 WORDS
SUBOPT_0x2F:
	STS  _fs_tmp,R30
	STS  _fs_tmp+1,R31
	STS  _fs_tmp+2,R22
	STS  _fs_tmp+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x30:
	__GETB1MN _fs_file,1
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	__GETW2MN _fs_file,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x32:
	__GETD2MN _fs_file,4
	RCALL __CPD02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x33:
	RCALL SUBOPT_0x1
	__PUTW1MN _fs_file,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x34:
	LDI  R30,LOW(0)
	__PUTB1MN _fs_file,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x35:
	__GETW1MN _fs_file,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x36:
	RCALL __GETD1P_INC
	RCALL SUBOPT_0x1D
	RCALL __PUTDP1_DEC
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x37:
	__GETD1MN _fs_file,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x38:
	RCALL SUBOPT_0x25
	__PUTD1MN _fs_file,4
	RCALL _fs_clust2sect_G001
	RCALL SUBOPT_0x25
	__PUTD1MN _fs_file,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:54 WORDS
SUBOPT_0x39:
	__GETD1MN _fs_file,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3A:
	LDS  R30,_fs_dirbase
	LDS  R31,_fs_dirbase+1
	LDS  R22,_fs_dirbase+2
	LDS  R23,_fs_dirbase+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3B:
	__POINTW1MN _buf,480
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:68 WORDS
SUBOPT_0x3C:
	__GETD1MN _fs_file,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3D:
	ANDI R30,LOW(0xF)
	ANDI R31,HIGH(0xF)
	LSL  R30
	RCALL __LSLW4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3E:
	__GETB1MN _buf,480
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	__GETB2MN _buf,480
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	__GETB1MN _buf,491
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x41:
	LDS  R26,_fs_file
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x42:
	RCALL __ADDD12
	RCALL __PUTPARD1
	RJMP _sd_writeBuf_G001

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x43:
	LDS  R26,_fs_fatbase
	LDS  R27,_fs_fatbase+1
	LDS  R24,_fs_fatbase+2
	LDS  R25,_fs_fatbase+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x44:
	LDS  R30,_fs_fatoptim
	LDS  R31,_fs_fatoptim+1
	LDS  R22,_fs_fatoptim+2
	LDS  R23,_fs_fatoptim+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	MOV  R30,R17
	RJMP SUBOPT_0x15

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x46:
	LDI  R26,LOW(_buf)
	LDI  R27,HIGH(_buf)
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x47:
	LDI  R30,LOW(_buf)
	LDI  R31,HIGH(_buf)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x49:
	LDD  R30,Y+8
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4A:
	__POINTW2MN _fs_file,28
	RJMP SUBOPT_0x36

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4B:
	__GETD1N 0xFFFFFFF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4C:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4D:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4F:
	LDI  R30,LOW(1)
	RCALL __LOADLOCR2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x50:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x51:
	LDS  R30,_fs_tmp
	LDS  R31,_fs_tmp+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x52:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x53:
	LD   R30,Y
	LDD  R31,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x54:
	RCALL SUBOPT_0x47
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x55:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x56:
	RCALL SUBOPT_0x2
	RJMP _memset

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x57:
	SUBI R30,LOW(-_buf)
	SBCI R31,HIGH(-_buf)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x58:
	RCALL _fs_allocCluster_G001
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x59:
	RCALL __PUTPARD1
	RJMP _fs_setNextCluster_G001

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x5A:
	__PUTD1MN _fs_file,28
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x5B:
	__PUTD1MN _fs_file,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x5C:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5D:
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5E:
	__POINTW1MN _buf,469
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5F:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x60:
	__GETD2MN _fs_file,28
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x61:
	MOV  R0,R16
	OR   R0,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x62:
	__GETD1MN _fs_file,28
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x63:
	__PUTD1MN _fs_file,20
	RCALL SUBOPT_0x5C
	__PUTD1MN _fs_file,16
	LDI  R30,LOW(1)
	STS  _fs_file,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x64:
	RCALL SUBOPT_0x41
	CPI  R26,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x65:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x66:
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x5F
	RJMP SUBOPT_0x56

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x67:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x68:
	RCALL SUBOPT_0x5F
	RCALL SUBOPT_0x2
	RCALL _memcpy
	LDD  R30,Y+17
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x69:
	RCALL __PUTPARD1
	RCALL _sd_writeBuf_G001
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6A:
	RCALL __PUTPARD1
	RJMP _fs_setEntryCluster_G001

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6B:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6C:
	__POINTW1MN _buf,32
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6D:
	RCALL _fs_open0
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x6E:
	__GETD1MN _fs_file,16
	RCALL __CPD10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x6F:
	__GETW1MN _fs_file,16
	ANDI R31,HIGH(0x1FF)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x70:
	__GETD1MN _fs_file,24
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x71:
	LDI  R30,LOW(3)
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x72:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x73:
	LDI  R26,LOW(512)
	LDI  R27,HIGH(512)
	SUB  R26,R30
	SBC  R27,R31
	MOVW R16,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x74:
	__GETD2MN _fs_file,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x75:
	__PUTD1MN _fs_file,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x76:
	__GETD1MN _fs_file,20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:40 WORDS
SUBOPT_0x77:
	__GETD1MN _fs_file,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x78:
	__PUTD1MN _fs_file,20
	LDI  R30,LOW(1)
	__PUTB1MN _fs_file,32
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x79:
	RCALL SUBOPT_0x57
	MOVW R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7A:
	__PUTD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7B:
	__GETD2S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7C:
	__GETD1S 5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7D:
	LDS  R30,_fs_wtotal
	LDS  R31,_fs_wtotal+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7E:
	RCALL SUBOPT_0x2
	LDI  R30,LOW(21)
	LDI  R31,HIGH(21)
	RCALL SUBOPT_0x2
	RJMP _memcpy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7F:
	LDI  R30,LOW(10)
	RCALL __LSRD12
	__ADDD1N 1
	RCALL __LSRD1
	RJMP SUBOPT_0x2D

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x80:
	ST   -Y,R30
	RJMP _spi_transmit_G002

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x81:
	ST   -Y,R30
	RCALL SUBOPT_0x5C
	RCALL __PUTPARD1
	RJMP _sd_sendCommand_G002

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x82:
	RCALL __PUTPARD1
	RCALL _sd_sendCommand_G002
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x83:
	LDI  R30,LOW(2)
	RCALL SUBOPT_0xB
	LDI  R30,LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x84:
	RCALL SUBOPT_0x2
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x85:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x86:
	RCALL SUBOPT_0x53
	SBIW R30,1
	ST   Y,R30
	STD  Y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x87:
	RCALL _wrecv
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x88:
	ST   -Y,R30
	RJMP _send

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x89:
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x2
	RJMP _sendBin

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8A:
	LDI  R30,LOW(65)
	RJMP SUBOPT_0x88

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x8B:
	LDS  R30,_lastError
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8C:
	RCALL _fs_getfilesize
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8D:
	MOVW R26,R10
	CLR  R24
	CLR  R25
	RCALL __CPD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x8E:
	LDI  R30,LOW(65)
	ST   -Y,R30
	RJMP _sendStart

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8F:
	RCALL _recvString
	RJMP SUBOPT_0x8E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x90:
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x2
	RJMP _recvBin

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x91:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP SUBOPT_0x84


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ADDD21:
	ADD  R26,R30
	ADC  R27,R31
	ADC  R24,R22
	ADC  R25,R23
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__SUBD21:
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	RET

__ORD12:
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__LSRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSRD12R
__LSRD12L:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRD12L
__LSRD12R:
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__LSRD1:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	RET

__LSRD16:
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	RET

__LSLD16:
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTDZ20:
	ST   Z,R26
	STD  Z+1,R27
	STD  Z+2,R24
	STD  Z+3,R25
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
