; nasm
	bits	16		;
	org	0000H		; 1FE0:0000H

	section	.text

INIT:
	CLI			; 割り込み無効
	XOR AX, AX		; スタックセグメント初期化
	MOV DS, AX		;
	MOV ES, AX		;
	MOV SS, AX		;
	MOV SP, 7FFH 		; 007FFH - 00400H = 1023 byte (スタック用)
	STI			; 割り込み有効

	CALL INIT_TVRAM		;

	MOV byte[CRT_X], AL	; 変数を0で初期化...?
	MOV byte[CRT_Y], AL	;
	
KERNEL:
;	MOV AX, 0A000H		; テキスト VRAM のセグメント A000H を ES に
;	MOV ES, AX		; 即値代入はできないみたい
;	MOV DX, 00H		; 00H 使い回し用
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



	MOV AH, 11H		; カーソル表示
	INT 18H			; CRT BIOS
	JMP LOOP

LOOP:
	HLT
	JMP LOOP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 座標CRT_X,CRT_Yに一文字表示(途中)
;;
;;	AL=文字コード
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
;; テキスト VRAM を BIOS コール使って NUL で初期化
INIT_TVRAM:
	PUSH AX
	PUSH DX
	MOV AH, 16H		; テキスト VRAM の初期化
	MOV DH, 0E1H		; 11100001B
	MOV DL, 00H		; NUL
	INT 18H
	POP DX
	POP AX
	RET

HELLO:	db "Hello, PC98!!$"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CRT_X:	db 0			; 必ず80以下
CRT_Y:	db 0			; 必ず25以下
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	times 1261568 - $ + $$	db	0

