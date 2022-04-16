;+---------------------------------------------------------------------------
; RAMFOS
; ����������� ����� ����� C827
; ������ ����� ���� �� ����������
;
; ��������� �������� BC,DE,HL
;
; 2013-11-01 ����������������� vinxru
;----------------------------------------------------------------------------

tapeWritePilot:	; ��������� BC, HL
		push	h
		push	b		

		; ������������ �����-���� BC. �������� ����� ����.
		; bc = (40 - v_tapePulseAL)*514
		lhld	v_tapePulseA
		mvi	a, 40
		sub	h
		add	a
		mov	b, a
		mov	c, a		

tapeWritePilot_0:
		 ; ��������� BC 
		 dcx	b

		 ; ��������, �������� ������ ��������� �� ��������
		 dad	h
		 mov	a, b

		 ; ������� �
		 call	tapePulseA		 

		 ; ��������� ���� BC �� �������
		 mov	a, b
		 ora	c
		jnz	tapeWritePilot_0

		; �������������� BC, HL
		pop	b
		pop	h
		ret