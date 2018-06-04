;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.6.0 #9615 (MINGW32)
;--------------------------------------------------------
; PIC16 port for the Microchip 16-bit core micros
;--------------------------------------------------------
	list	p=18f4520
	radix	dec
	CONFIG	MCLRE=ON
	CONFIG	OSC=HS
	CONFIG	WDT=OFF
	CONFIG	LVP=OFF
	CONFIG	DEBUG=OFF
	CONFIG	WDTPS=1


;--------------------------------------------------------
; public variables in this module
;--------------------------------------------------------
	global	_pulsos
	global	_tmp
	global	_i
	global	_Contador
	global	_main

;--------------------------------------------------------
; extern variables in this module
;--------------------------------------------------------
	extern	_EnviaComando
	extern	_EnviaDados
	extern	_InicializaLCD
	extern	__mulint
	extern	__divsint
	extern	__modsint

;--------------------------------------------------------
;	Equates to used internal registers
;--------------------------------------------------------
STATUS	equ	0xfd8
PCLATH	equ	0xffa
PCLATU	equ	0xffb
BSR	equ	0xfe0
FSR0L	equ	0xfe9
FSR0H	equ	0xfea
FSR1L	equ	0xfe1
FSR2L	equ	0xfd9
INDF0	equ	0xfef
POSTINC1	equ	0xfe6
POSTDEC1	equ	0xfe5
PREINC1	equ	0xfe4
PRODL	equ	0xff3
PRODH	equ	0xff4


; Internal registers
.registers	udata_ovr	0x0000
r0x00	res	1
r0x01	res	1

udata_main_0	udata
_tmp	res	2

udata_main_1	udata
_i	res	1

udata_main_2	udata
_pulsos	res	2

;--------------------------------------------------------
; interrupt vector
;--------------------------------------------------------

;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
; ; Starting pCode block for absolute section
; ;-----------------------------------------
S_main_ivec_0x1_Contador	code	0X000008
ivec_0x1_Contador:
	GOTO	_Contador

; I code from now on!
; ; Starting pCode block
S_main__main	code
_main:
;	.line	28; main.c	PR2 = 98; //valor para a interrupção do timer2 durar 10,03 ms
	LFSR	0x00, 0xfcb
	MOVLW	0x62
	MOVWF	INDF0
;	.line	29; main.c	BitSet(TRISA, 4); //seta o bit 4 como entrada
	LFSR	0x00, 0xf92
	MOVFF	INDF0, r0x00
	BSF	r0x00, 4
	LFSR	0x00, 0xf92
	MOVFF	r0x00, INDF0
;	.line	30; main.c	InicializaLCD();
	CALL	_InicializaLCD
;	.line	31; main.c	BitSet(T0CON, 6); //timer0 8 bits
	LFSR	0x00, 0xfd5
	MOVFF	INDF0, r0x00
	BSF	r0x00, 6
	LFSR	0x00, 0xfd5
	MOVFF	r0x00, INDF0
;	.line	32; main.c	BitSet(T0CON, 5); //habilita o clock externo
	LFSR	0x00, 0xfd5
	MOVFF	INDF0, r0x00
	BSF	r0x00, 5
	LFSR	0x00, 0xfd5
	MOVFF	r0x00, INDF0
;	.line	33; main.c	BitSet(T0CON, 4); //habilita a borda de subida
	LFSR	0x00, 0xfd5
	MOVFF	INDF0, r0x00
	BSF	r0x00, 4
	LFSR	0x00, 0xfd5
	MOVFF	r0x00, INDF0
;	.line	34; main.c	BitSet(T0CON, 3); //não usar prescaler
	LFSR	0x00, 0xfd5
	MOVFF	INDF0, r0x00
	BSF	r0x00, 3
	LFSR	0x00, 0xfd5
	MOVFF	r0x00, INDF0
;	.line	35; main.c	BitSet(T0CON, 7); //habilita o timer0
	LFSR	0x00, 0xfd5
	MOVFF	INDF0, r0x00
	BSF	r0x00, 7
	LFSR	0x00, 0xfd5
	MOVFF	r0x00, INDF0
;	.line	37; main.c	BitSet(T2CON, 6); //postscale 1:16
	LFSR	0x00, 0xfca
	MOVFF	INDF0, r0x00
	BSF	r0x00, 6
	LFSR	0x00, 0xfca
	MOVFF	r0x00, INDF0
;	.line	38; main.c	BitSet(T2CON, 5); //postscale 1:16
	LFSR	0x00, 0xfca
	MOVFF	INDF0, r0x00
	BSF	r0x00, 5
	LFSR	0x00, 0xfca
	MOVFF	r0x00, INDF0
;	.line	39; main.c	BitSet(T2CON, 4); //postscale 1:16
	LFSR	0x00, 0xfca
	MOVFF	INDF0, r0x00
	BSF	r0x00, 4
	LFSR	0x00, 0xfca
	MOVFF	r0x00, INDF0
;	.line	40; main.c	BitSet(T2CON, 3); //postscale 1:16
	LFSR	0x00, 0xfca
	MOVFF	INDF0, r0x00
	BSF	r0x00, 3
	LFSR	0x00, 0xfca
	MOVFF	r0x00, INDF0
;	.line	41; main.c	BitSet(T2CON, 1); //prescaler 16
	LFSR	0x00, 0xfca
	MOVFF	INDF0, r0x00
	BSF	r0x00, 1
	LFSR	0x00, 0xfca
	MOVFF	r0x00, INDF0
;	.line	42; main.c	BitSet(T2CON, 2); //habilita o timer2
	LFSR	0x00, 0xfca
	MOVFF	INDF0, r0x00
	BSF	r0x00, 2
	LFSR	0x00, 0xfca
	MOVFF	r0x00, INDF0
;	.line	43; main.c	BitSet(PIE1, 1); //habilita o interrrupt do timer2 (dura 10,03 ms)
	LFSR	0x00, 0xf9d
	MOVFF	INDF0, r0x00
	BSF	r0x00, 1
	LFSR	0x00, 0xf9d
	MOVFF	r0x00, INDF0
;	.line	45; main.c	BitSet(INTCON, 7); //habilita interrupt global
	LFSR	0x00, 0xff2
	MOVFF	INDF0, r0x00
	BSF	r0x00, 7
	LFSR	0x00, 0xff2
	MOVFF	r0x00, INDF0
;	.line	46; main.c	BitSet(INTCON, 6); //habilita interrupt perifericos
	LFSR	0x00, 0xff2
	MOVFF	INDF0, r0x00
	BSF	r0x00, 6
	LFSR	0x00, 0xff2
	MOVFF	r0x00, INDF0
_00126_DS_:
;	.line	50; main.c	EnviaComando(0x01); //limpar display
	MOVLW	0x01
	MOVWF	POSTDEC1
	CALL	_EnviaComando
	MOVF	POSTINC1, F
;	.line	51; main.c	EnviaDados('R');
	MOVLW	0x52
	MOVWF	POSTDEC1
	CALL	_EnviaDados
	MOVF	POSTINC1, F
;	.line	52; main.c	EnviaDados('P');
	MOVLW	0x50
	MOVWF	POSTDEC1
	CALL	_EnviaDados
	MOVF	POSTINC1, F
;	.line	53; main.c	EnviaDados('M');
	MOVLW	0x4d
	MOVWF	POSTDEC1
	CALL	_EnviaDados
	MOVF	POSTINC1, F
;	.line	54; main.c	EnviaDados(':');
	MOVLW	0x3a
	MOVWF	POSTDEC1
	CALL	_EnviaDados
	MOVF	POSTINC1, F
	BANKSEL	(_pulsos + 1)
;	.line	55; main.c	EnviaDados(((60*pulsos) / 1000) % 10 + 48);
	MOVF	(_pulsos + 1), W, B
	MOVWF	POSTDEC1
	BANKSEL	_pulsos
	MOVF	_pulsos, W, B
	MOVWF	POSTDEC1
	MOVLW	0x00
	MOVWF	POSTDEC1
	MOVLW	0x3c
	MOVWF	POSTDEC1
	CALL	__mulint
	MOVWF	r0x00
	MOVFF	PRODL, r0x01
	MOVLW	0x04
	ADDWF	FSR1L, F
	MOVLW	0x03
	MOVWF	POSTDEC1
	MOVLW	0xe8
	MOVWF	POSTDEC1
	MOVF	r0x01, W
	MOVWF	POSTDEC1
	MOVF	r0x00, W
	MOVWF	POSTDEC1
	CALL	__divsint
	MOVWF	r0x00
	MOVFF	PRODL, r0x01
	MOVLW	0x04
	ADDWF	FSR1L, F
	MOVLW	0x00
	MOVWF	POSTDEC1
	MOVLW	0x0a
	MOVWF	POSTDEC1
	MOVF	r0x01, W
	MOVWF	POSTDEC1
	MOVF	r0x00, W
	MOVWF	POSTDEC1
	CALL	__modsint
	MOVWF	r0x00
	MOVFF	PRODL, r0x01
	MOVLW	0x04
	ADDWF	FSR1L, F
	MOVLW	0x30
	ADDWF	r0x00, F
	MOVF	r0x00, W
	MOVWF	POSTDEC1
	CALL	_EnviaDados
	MOVF	POSTINC1, F
	BANKSEL	(_pulsos + 1)
;	.line	56; main.c	EnviaDados(((60*pulsos) / 100) % 10 + 48);
	MOVF	(_pulsos + 1), W, B
	MOVWF	POSTDEC1
	BANKSEL	_pulsos
	MOVF	_pulsos, W, B
	MOVWF	POSTDEC1
	MOVLW	0x00
	MOVWF	POSTDEC1
	MOVLW	0x3c
	MOVWF	POSTDEC1
	CALL	__mulint
	MOVWF	r0x00
	MOVFF	PRODL, r0x01
	MOVLW	0x04
	ADDWF	FSR1L, F
	MOVLW	0x00
	MOVWF	POSTDEC1
	MOVLW	0x64
	MOVWF	POSTDEC1
	MOVF	r0x01, W
	MOVWF	POSTDEC1
	MOVF	r0x00, W
	MOVWF	POSTDEC1
	CALL	__divsint
	MOVWF	r0x00
	MOVFF	PRODL, r0x01
	MOVLW	0x04
	ADDWF	FSR1L, F
	MOVLW	0x00
	MOVWF	POSTDEC1
	MOVLW	0x0a
	MOVWF	POSTDEC1
	MOVF	r0x01, W
	MOVWF	POSTDEC1
	MOVF	r0x00, W
	MOVWF	POSTDEC1
	CALL	__modsint
	MOVWF	r0x00
	MOVFF	PRODL, r0x01
	MOVLW	0x04
	ADDWF	FSR1L, F
	MOVLW	0x30
	ADDWF	r0x00, F
	MOVF	r0x00, W
	MOVWF	POSTDEC1
	CALL	_EnviaDados
	MOVF	POSTINC1, F
	BANKSEL	(_pulsos + 1)
;	.line	57; main.c	EnviaDados(((60*pulsos) / 10) % 10 + 48);
	MOVF	(_pulsos + 1), W, B
	MOVWF	POSTDEC1
	BANKSEL	_pulsos
	MOVF	_pulsos, W, B
	MOVWF	POSTDEC1
	MOVLW	0x00
	MOVWF	POSTDEC1
	MOVLW	0x3c
	MOVWF	POSTDEC1
	CALL	__mulint
	MOVWF	r0x00
	MOVFF	PRODL, r0x01
	MOVLW	0x04
	ADDWF	FSR1L, F
	MOVLW	0x00
	MOVWF	POSTDEC1
	MOVLW	0x0a
	MOVWF	POSTDEC1
	MOVF	r0x01, W
	MOVWF	POSTDEC1
	MOVF	r0x00, W
	MOVWF	POSTDEC1
	CALL	__divsint
	MOVWF	r0x00
	MOVFF	PRODL, r0x01
	MOVLW	0x04
	ADDWF	FSR1L, F
	MOVLW	0x00
	MOVWF	POSTDEC1
	MOVLW	0x0a
	MOVWF	POSTDEC1
	MOVF	r0x01, W
	MOVWF	POSTDEC1
	MOVF	r0x00, W
	MOVWF	POSTDEC1
	CALL	__modsint
	MOVWF	r0x00
	MOVFF	PRODL, r0x01
	MOVLW	0x04
	ADDWF	FSR1L, F
	MOVLW	0x30
	ADDWF	r0x00, F
	MOVF	r0x00, W
	MOVWF	POSTDEC1
	CALL	_EnviaDados
	MOVF	POSTINC1, F
	BANKSEL	(_pulsos + 1)
;	.line	58; main.c	EnviaDados(((60*pulsos) / 1) % 10 + 48);
	MOVF	(_pulsos + 1), W, B
	MOVWF	POSTDEC1
	BANKSEL	_pulsos
	MOVF	_pulsos, W, B
	MOVWF	POSTDEC1
	MOVLW	0x00
	MOVWF	POSTDEC1
	MOVLW	0x3c
	MOVWF	POSTDEC1
	CALL	__mulint
	MOVWF	r0x00
	MOVFF	PRODL, r0x01
	MOVLW	0x04
	ADDWF	FSR1L, F
	MOVLW	0x00
	MOVWF	POSTDEC1
	MOVLW	0x0a
	MOVWF	POSTDEC1
	MOVF	r0x01, W
	MOVWF	POSTDEC1
	MOVF	r0x00, W
	MOVWF	POSTDEC1
	CALL	__modsint
	MOVWF	r0x00
	MOVFF	PRODL, r0x01
	MOVLW	0x04
	ADDWF	FSR1L, F
	MOVLW	0x30
	ADDWF	r0x00, F
	MOVF	r0x00, W
	MOVWF	POSTDEC1
	CALL	_EnviaDados
	MOVF	POSTINC1, F
	BRA	_00126_DS_
	RETURN	

; ; Starting pCode block
S_main__Contador	code
_Contador:
;	.line	9; main.c	void Contador(void) __interrupt 1 {
	MOVFF	STATUS, POSTDEC1
	MOVFF	BSR, POSTDEC1
	MOVWF	POSTDEC1
	MOVFF	PRODL, POSTDEC1
	MOVFF	PRODH, POSTDEC1
	MOVFF	FSR0L, POSTDEC1
	MOVFF	FSR0H, POSTDEC1
	MOVFF	PCLATH, POSTDEC1
	MOVFF	PCLATU, POSTDEC1
	MOVFF	FSR2L, POSTDEC1
	MOVFF	FSR1L, FSR2L
	MOVFF	r0x00, POSTDEC1
	MOVFF	r0x01, POSTDEC1
;	.line	12; main.c	if (BitTst(PIR1, 1)) {
	LFSR	0x00, 0xf9e
	MOVFF	INDF0, r0x00
	BTFSS	r0x00, 1
	BRA	_00109_DS_
;	.line	14; main.c	tmp += TMR0L;
	LFSR	0x00, 0xfd6
	MOVFF	INDF0, r0x00
	CLRF	r0x01
	MOVF	r0x00, W
	BANKSEL	_tmp
	ADDWF	_tmp, F, B
	MOVF	r0x01, W
	BANKSEL	(_tmp + 1)
	ADDWFC	(_tmp + 1), F, B
;	.line	15; main.c	TMR0L = 0; //zerar o contador de pulsos
	LFSR	0x00, 0xfd6
	MOVLW	0x00
	MOVWF	INDF0
;	.line	16; main.c	BitClr(PIR1, 1); //limpar flag do timer  
	LFSR	0x00, 0xf9e
	MOVFF	INDF0, r0x00
	BCF	r0x00, 1
	LFSR	0x00, 0xf9e
	MOVFF	r0x00, INDF0
	BANKSEL	_i
;	.line	17; main.c	i++;
	INCF	_i, F, B
	BANKSEL	_i
;	.line	18; main.c	if (i == 100) {
	MOVF	_i, W, B
	XORLW	0x64
	BNZ	_00109_DS_
_00120_DS_:
	BANKSEL	_i
;	.line	19; main.c	i = 0;
	CLRF	_i, B
;	.line	20; main.c	pulsos = tmp;   //quantidade de pulsos a cada 1,003s
	MOVFF	_tmp, _pulsos
	MOVFF	(_tmp + 1), (_pulsos + 1)
	BANKSEL	_tmp
;	.line	21; main.c	tmp = 0;
	CLRF	_tmp, B
	BANKSEL	(_tmp + 1)
	CLRF	(_tmp + 1), B
_00109_DS_:
	MOVFF	PREINC1, r0x01
	MOVFF	PREINC1, r0x00
	MOVFF	PREINC1, FSR2L
	MOVFF	PREINC1, PCLATU
	MOVFF	PREINC1, PCLATH
	MOVFF	PREINC1, FSR0H
	MOVFF	PREINC1, FSR0L
	MOVFF	PREINC1, PRODH
	MOVFF	PREINC1, PRODL
	MOVF	PREINC1, W
	MOVFF	PREINC1, BSR
	MOVFF	PREINC1, STATUS
	RETFIE	



; Statistics:
; code size:	  930 (0x03a2) bytes ( 0.71%)
;           	  465 (0x01d1) words
; udata size:	    5 (0x0005) bytes ( 0.39%)
; access size:	    2 (0x0002) bytes


	end
