;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 3.6.0 #9615 (MINGW32)
;--------------------------------------------------------
; PIC16 port for the Microchip 16-bit core micros
;--------------------------------------------------------
	list	p=18f4520
	radix	dec


;--------------------------------------------------------
; public variables in this module
;--------------------------------------------------------
	global	_EnviaComando
	global	_EnviaDados
	global	_InicializaLCD
	global	_Delay40us
	global	_Delay2ms

;--------------------------------------------------------
;	Equates to used internal registers
;--------------------------------------------------------
STATUS	equ	0xfd8
FSR1L	equ	0xfe1
FSR2L	equ	0xfd9
INDF0	equ	0xfef
POSTINC1	equ	0xfe6
POSTDEC1	equ	0xfe5
PREINC1	equ	0xfe4
PLUSW2	equ	0xfdb


; Internal registers
.registers	udata_ovr	0x0000
r0x00	res	1
r0x01	res	1

;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
; I code from now on!
; ; Starting pCode block
S_lcd__InicializaLCD	code
_InicializaLCD:
;	.line	75; lcd.c	void InicializaLCD(void)
	MOVFF	FSR2L, POSTDEC1
	MOVFF	FSR1L, FSR2L
	MOVFF	r0x00, POSTDEC1
;	.line	80; lcd.c	Delay2ms();
	CALL	_Delay2ms
;	.line	81; lcd.c	Delay2ms();
	CALL	_Delay2ms
;	.line	82; lcd.c	Delay2ms();
	CALL	_Delay2ms
;	.line	83; lcd.c	Delay2ms();
	CALL	_Delay2ms
;	.line	84; lcd.c	Delay2ms();
	CALL	_Delay2ms
;	.line	87; lcd.c	BitClr(TRISE,RS);	//RS
	LFSR	0x00, 0xf96
	MOVFF	INDF0, r0x00
	BCF	r0x00, 0
	LFSR	0x00, 0xf96
	MOVFF	r0x00, INDF0
;	.line	88; lcd.c	BitClr(TRISE,EN);	//EN
	LFSR	0x00, 0xf96
	MOVFF	INDF0, r0x00
	BCF	r0x00, 1
	LFSR	0x00, 0xf96
	MOVFF	r0x00, INDF0
;	.line	89; lcd.c	BitClr(TRISE,RW);	//RW
	LFSR	0x00, 0xf96
	MOVFF	INDF0, r0x00
	BCF	r0x00, 2
	LFSR	0x00, 0xf96
	MOVFF	r0x00, INDF0
;	.line	90; lcd.c	TRISD = 0x00;		//dados
	LFSR	0x00, 0xf95
	MOVLW	0x00
	MOVWF	INDF0
;	.line	91; lcd.c	ADCON1 = 0b00001110;	//apenas
	LFSR	0x00, 0xfc1
	MOVLW	0x0e
	MOVWF	INDF0
;	.line	94; lcd.c	EnviaComando(0x38);	//8bits, 2 linhas, 5x8
	MOVLW	0x38
	MOVWF	POSTDEC1
	CALL	_EnviaComando
	MOVF	POSTINC1, F
;	.line	95; lcd.c	EnviaComando(0x06);	//modo incremental
	MOVLW	0x06
	MOVWF	POSTDEC1
	CALL	_EnviaComando
	MOVF	POSTINC1, F
;	.line	96; lcd.c	EnviaComando(0x0C);	//display e cursor on, com blink
	MOVLW	0x0c
	MOVWF	POSTDEC1
	CALL	_EnviaComando
	MOVF	POSTINC1, F
;	.line	97; lcd.c	EnviaComando(0x03);	//zera tudo
	MOVLW	0x03
	MOVWF	POSTDEC1
	CALL	_EnviaComando
	MOVF	POSTINC1, F
;	.line	98; lcd.c	EnviaComando(0x01);	//limpar display
	MOVLW	0x01
	MOVWF	POSTDEC1
	CALL	_EnviaComando
	MOVF	POSTINC1, F
;	.line	99; lcd.c	EnviaComando(0x80);	//posição inicial
	MOVLW	0x80
	MOVWF	POSTDEC1
	CALL	_EnviaComando
	MOVF	POSTINC1, F
	MOVFF	PREINC1, r0x00
	MOVFF	PREINC1, FSR2L
	RETURN	

; ; Starting pCode block
S_lcd__EnviaDados	code
_EnviaDados:
;	.line	60; lcd.c	void EnviaDados(unsigned char valor)
	MOVFF	FSR2L, POSTDEC1
	MOVFF	FSR1L, FSR2L
	MOVFF	r0x00, POSTDEC1
	MOVFF	r0x01, POSTDEC1
	MOVLW	0x02
	MOVFF	PLUSW2, r0x00
;	.line	62; lcd.c	BitSet(PORTE,RS);	//dados
	LFSR	0x00, 0xf84
	MOVFF	INDF0, r0x01
	BSF	r0x01, 0
	LFSR	0x00, 0xf84
	MOVFF	r0x01, INDF0
;	.line	63; lcd.c	BitClr(PORTE,RW);	// habilita escrita
	LFSR	0x00, 0xf84
	MOVFF	INDF0, r0x01
	BCF	r0x01, 2
	LFSR	0x00, 0xf84
	MOVFF	r0x01, INDF0
;	.line	66; lcd.c	PORTD = valor;
	LFSR	0x00, 0xf83
	MOVFF	r0x00, INDF0
;	.line	67; lcd.c	BitSet(PORTE,EN);//habilita leitura
	LFSR	0x00, 0xf84
	MOVFF	INDF0, r0x00
	BSF	r0x00, 1
	LFSR	0x00, 0xf84
	MOVFF	r0x00, INDF0
;	.line	68; lcd.c	Delay40us();
	CALL	_Delay40us
;	.line	69; lcd.c	BitClr(PORTE,EN);//termina leitura
	LFSR	0x00, 0xf84
	MOVFF	INDF0, r0x00
	BCF	r0x00, 1
	LFSR	0x00, 0xf84
	MOVFF	r0x00, INDF0
;	.line	70; lcd.c	BitClr(PORTE,RS);	//deixa em nivel baixo
	LFSR	0x00, 0xf84
	MOVFF	INDF0, r0x00
	BCF	r0x00, 0
	LFSR	0x00, 0xf84
	MOVFF	r0x00, INDF0
;	.line	71; lcd.c	BitClr(PORTE,RW);	//deixa em nivel baixo
	LFSR	0x00, 0xf84
	MOVFF	INDF0, r0x00
	BCF	r0x00, 2
	LFSR	0x00, 0xf84
	MOVFF	r0x00, INDF0
;	.line	72; lcd.c	Delay40us();
	CALL	_Delay40us
	MOVFF	PREINC1, r0x01
	MOVFF	PREINC1, r0x00
	MOVFF	PREINC1, FSR2L
	RETURN	

; ; Starting pCode block
S_lcd__EnviaComando	code
_EnviaComando:
;	.line	46; lcd.c	void EnviaComando(unsigned char cmd)
	MOVFF	FSR2L, POSTDEC1
	MOVFF	FSR1L, FSR2L
	MOVFF	r0x00, POSTDEC1
	MOVFF	r0x01, POSTDEC1
	MOVLW	0x02
	MOVFF	PLUSW2, r0x00
;	.line	48; lcd.c	BitClr(PORTE,RS);	//comando
	LFSR	0x00, 0xf84
	MOVFF	INDF0, r0x01
	BCF	r0x01, 0
	LFSR	0x00, 0xf84
	MOVFF	r0x01, INDF0
;	.line	49; lcd.c	BitClr(PORTE,RW);	// habilita escrita
	LFSR	0x00, 0xf84
	MOVFF	INDF0, r0x01
	BCF	r0x01, 2
	LFSR	0x00, 0xf84
	MOVFF	r0x01, INDF0
;	.line	51; lcd.c	PORTD = cmd;
	LFSR	0x00, 0xf83
	MOVFF	r0x00, INDF0
;	.line	52; lcd.c	BitSet(PORTE,EN);//habilita leitura
	LFSR	0x00, 0xf84
	MOVFF	INDF0, r0x00
	BSF	r0x00, 1
	LFSR	0x00, 0xf84
	MOVFF	r0x00, INDF0
;	.line	53; lcd.c	Delay2ms();
	CALL	_Delay2ms
;	.line	54; lcd.c	BitClr(PORTE,EN);//termina leitura
	LFSR	0x00, 0xf84
	MOVFF	INDF0, r0x00
	BCF	r0x00, 1
	LFSR	0x00, 0xf84
	MOVFF	r0x00, INDF0
;	.line	55; lcd.c	BitClr(PORTE,RS);	//deixa em nivel baixo
	LFSR	0x00, 0xf84
	MOVFF	INDF0, r0x00
	BCF	r0x00, 0
	LFSR	0x00, 0xf84
	MOVFF	r0x00, INDF0
;	.line	56; lcd.c	BitClr(PORTE,RW);	//deixa em nivel baixo
	LFSR	0x00, 0xf84
	MOVFF	INDF0, r0x00
	BCF	r0x00, 2
	LFSR	0x00, 0xf84
	MOVFF	r0x00, INDF0
;	.line	57; lcd.c	Delay2ms();
	CALL	_Delay2ms
	MOVFF	PREINC1, r0x01
	MOVFF	PREINC1, r0x00
	MOVFF	PREINC1, FSR2L
	RETURN	

; ; Starting pCode block
S_lcd__Delay2ms	code
_Delay2ms:
;	.line	36; lcd.c	void Delay2ms(void)
	MOVFF	FSR2L, POSTDEC1
	MOVFF	FSR1L, FSR2L
	MOVFF	r0x00, POSTDEC1
	MOVFF	r0x01, POSTDEC1
;	.line	39; lcd.c	for(i=0; i < 200; i++)
	MOVLW	0xc8
	MOVWF	r0x00
_00117_DS_:
;	.line	41; lcd.c	Delay40us();
	CALL	_Delay40us
	DECF	r0x00, W
	MOVWF	r0x01
	MOVFF	r0x01, r0x00
;	.line	39; lcd.c	for(i=0; i < 200; i++)
	MOVF	r0x01, W
	BNZ	_00117_DS_
	MOVFF	PREINC1, r0x01
	MOVFF	PREINC1, r0x00
	MOVFF	PREINC1, FSR2L
	RETURN	

; ; Starting pCode block
S_lcd__Delay40us	code
_Delay40us:
;	.line	28; lcd.c	void Delay40us(void)
	MOVFF	FSR2L, POSTDEC1
	MOVFF	FSR1L, FSR2L
	MOVFF	r0x00, POSTDEC1
	MOVFF	r0x01, POSTDEC1
;	.line	33; lcd.c	for(i=0; i < 25; i++); //3 + 3 * 25 = 78
	MOVLW	0x19
	MOVWF	r0x00
_00108_DS_:
	DECF	r0x00, W
	MOVWF	r0x01
	MOVFF	r0x01, r0x00
	MOVF	r0x01, W
	BNZ	_00108_DS_
	MOVFF	PREINC1, r0x01
	MOVFF	PREINC1, r0x00
	MOVFF	PREINC1, FSR2L
	RETURN	



; Statistics:
; code size:	  588 (0x024c) bytes ( 0.45%)
;           	  294 (0x0126) words
; udata size:	    0 (0x0000) bytes ( 0.00%)
; access size:	    2 (0x0002) bytes


	end
