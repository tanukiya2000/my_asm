; nasm
	bits	16		;
	org	0000H		; 1FE0:0000H

	section	.text

INIT:
	CLI			; ���荞�ݖ���
	XOR AX, AX		; �X�^�b�N�Z�O�����g������
	MOV DS, AX		;
	MOV ES, AX		;
	MOV SS, AX		;
	MOV SP, 7FFH 		; 007FFH - 00400H = 1023 byte (�X�^�b�N�p)
	STI			; ���荞�ݗL��

	CALL INIT_TVRAM		;

	MOV byte[CRT_X], AL	; �ϐ���0�ŏ�����...?
	MOV byte[CRT_Y], AL	;
	
KERNEL:
;	MOV AX, 0A000H		; �e�L�X�g VRAM �̃Z�O�����g A000H �� ES ��
;	MOV ES, AX		; ���l����͂ł��Ȃ��݂���
;	MOV DX, 00H		; 00H �g���񂵗p
;	MOV BX, 00H		; Address

	MOV AL, "t"
	CALL PUT_C
	MOV AL, "a"
	CALL PUT_C
	MOV AL, "n"
	CALL PUT_C
	MOV AL, "u"
	CALL PUT_C
	MOV AL, "k"
	CALL PUT_C
	MOV AL, "i"
	CALL PUT_C
	MOV AL, "y"
	CALL PUT_C
	MOV AL, "a"
	CALL PUT_C

;	MOV AX, 'M'		; M
;	MOV [ES:BX], AX		;
;	INC BX 			;
;	MOV [ES:BX], DX		;
;	INC BX 			;



	MOV AH, 11H		; �J�[�\���\��
	INT 18H			; CRT BIOS
	JMP LOOP

LOOP:
	HLT
	JMP LOOP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ���WCRT_X,CRT_Y�Ɉꕶ���\��(�r��)
;;
;;	AL=�����R�[�h
PUT_C:
	PUSH AX
	PUSH BX
	PUSH ES
	
	MOV AH, 0
	
	MOV BX, 0A000H
	MOV ES, BX
	
	XOR BX, BX
	
	MOV BL, byte[CRT_X]
	
	MOV [ES:BX], AX
	INC BX
	MOV [ES:BX], byte 0
	INC BX
	MOV byte[CRT_X], BL
	
	POP ES
	POP BX
	POP AX
	RET


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; �e�L�X�g VRAM �� BIOS �R�[���g���� NUL �ŏ�����
INIT_TVRAM:
	PUSH AX
	PUSH DX
	MOV AH, 16H		; �e�L�X�g VRAM �̏�����
	MOV DH, 0E1H		; 11100001B
	MOV DL, 00H		; NUL
	INT 18H
	POP DX
	POP AX
	RET

HELLO:	db "Hello, PC98!!$"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CRT_X:	db 0			; �K��80�ȉ�
CRT_Y:	db 0			; �K��25�ȉ�
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	times 1261568 - $ + $$	db	0

