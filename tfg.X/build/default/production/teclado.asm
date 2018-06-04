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
	global	_LerTeclas
	global	_DebounceTeclas
	global	_InicializaTeclado

;--------------------------------------------------------
;	Equates to used internal registers
;--------------------------------------------------------
STATUS	equ	0xfd8
WREG	equ	0xfe8
FSR1L	equ	0xfe1
FSR2L	equ	0xfd9
INDF0	equ	0xfef
POSTDEC1	equ	0xfe5
PREINC1	equ	0xfe4


	idata
_valor	db	0x00
_DebounceTeclas_valorNovo_1_7	db	0x00
_DebounceTeclas_valorAntigo_1_7	db	0x00


; Internal registers
.registers	udata_ovr	0x0000
r0x00	res	1
r0x01	res	1
r0x02	res	1
r0x03	res	1
r0x04	res	1
r0x05	res	1
r0x06	res	1
r0x07	res	1
r0x08	res	1
r0x09	res	1

udata_teclado_0	udata
_DebounceTeclas_tempo_1_7	res	1

;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
; I code from now on!
; ; Starting pCode block
S_teclado__InicializaTeclado	code
_InicializaTeclado:
;	.line	65; teclado.c	void InicializaTeclado(void) {
	MOVFF	FSR2L, POSTDEC1
	MOVFF	FSR1L, FSR2L
	MOVFF	r0x00, POSTDEC1
;	.line	66; teclado.c	TRISB = 0xF0; //quatro entradas e quatro saidas
	LFSR	0x00, 0xf93
	MOVLW	0xf0
	MOVWF	INDF0
;	.line	67; teclado.c	BitClr(INTCON2, 7); //liga pull up
	LFSR	0x00, 0xff1
	MOVFF	INDF0, r0x00
	BCF	r0x00, 7
	LFSR	0x00, 0xff1
	MOVFF	r0x00, INDF0
;	.line	68; teclado.c	ADCON1 = 0b00001110; //apenas AN0 é analogico, a referencia é baseada na fonte
	LFSR	0x00, 0xfc1
	MOVLW	0x0e
	MOVWF	INDF0
	MOVFF	PREINC1, r0x00
	MOVFF	PREINC1, FSR2L
	RETURN	

; ; Starting pCode block
S_teclado__DebounceTeclas	code
_DebounceTeclas:
;	.line	29; teclado.c	void DebounceTeclas(void) {
	MOVFF	FSR2L, POSTDEC1
	MOVFF	FSR1L, FSR2L
	MOVFF	r0x00, POSTDEC1
	MOVFF	r0x01, POSTDEC1
	MOVFF	r0x02, POSTDEC1
	MOVFF	r0x03, POSTDEC1
	MOVFF	r0x04, POSTDEC1
	MOVFF	r0x05, POSTDEC1
	MOVFF	r0x06, POSTDEC1
	MOVFF	r0x07, POSTDEC1
	MOVFF	r0x08, POSTDEC1
	MOVFF	r0x09, POSTDEC1
;	.line	35; teclado.c	for (i = 0; i < 4; i++) {
	CLRF	r0x00
	CLRF	r0x01
	CLRF	r0x02
_00126_DS_:
;	.line	38; teclado.c	PORTB |= 0x0F;
	LFSR	0x00, 0xf81
	MOVFF	INDF0, r0x03
	MOVLW	0x0f
	IORWF	r0x03, F
	LFSR	0x00, 0xf81
	MOVFF	r0x03, INDF0
;	.line	39; teclado.c	BitClr(PORTB, (i)); //liga a coluna correspondente
	LFSR	0x00, 0xf81
	MOVFF	INDF0, r0x03
	MOVLW	0x01
	MOVWF	r0x04
	MOVF	r0x00, W
	BZ	_00161_DS_
	NEGF	WREG
	BCF	STATUS, 0
_00162_DS_:
	RLCF	r0x04, F
	ADDLW	0x01
	BNC	_00162_DS_
_00161_DS_:
	COMF	r0x04, F
	MOVF	r0x04, W
	ANDWF	r0x03, F
	LFSR	0x00, 0xf81
	MOVFF	r0x03, INDF0
;	.line	41; teclado.c	for (j = 0; j < 100; j++);
	MOVLW	0x64
	MOVWF	r0x03
_00123_DS_:
	DECFSZ	r0x03, F
	BRA	_00123_DS_
;	.line	44; teclado.c	for (j = 0; j < 2; j++) {
	CLRF	r0x03
_00124_DS_:
;	.line	45; teclado.c	if (!BitTst(PORTB, j + 4)) {
	LFSR	0x00, 0xf81
	MOVFF	INDF0, r0x04
	MOVFF	r0x03, r0x05
	CLRF	r0x06
	MOVLW	0x04
	ADDWF	r0x05, F
	BTFSC	STATUS, 0
	INCF	r0x06, F
	MOVLW	0x01
	MOVWF	r0x07
	MOVLW	0x00
	MOVWF	r0x08
	MOVF	r0x05, W
	BZ	_00164_DS_
	BN	_00167_DS_
	NEGF	WREG
	BCF	STATUS, 0
_00165_DS_:
	RLCF	r0x07, F
	RLCF	r0x08, F
	ADDLW	0x01
	BNC	_00165_DS_
	BRA	_00164_DS_
_00167_DS_:
	BCF	STATUS, 0
_00166_DS_:
	BTFSC	r0x08, 7
	BSF	STATUS, 0
	RRCF	r0x08, F
	RRCF	r0x07, F
	ADDLW	0x01
	BNC	_00166_DS_
_00164_DS_:
	CLRF	r0x09
	MOVF	r0x04, W
	ANDWF	r0x07, F
	MOVF	r0x09, W
	ANDWF	r0x08, F
	MOVF	r0x07, W
	IORWF	r0x08, W
	BNZ	_00112_DS_
;	.line	46; teclado.c	BitSet(valorNovo, (i * 2) + j);
	MOVF	r0x03, W
	ADDWF	r0x02, W
	MOVWF	r0x04
	MOVLW	0x01
	MOVWF	r0x05
	MOVF	r0x04, W
	BZ	_00168_DS_
	NEGF	WREG
	BCF	STATUS, 0
_00169_DS_:
	RLCF	r0x05, F
	ADDLW	0x01
	BNC	_00169_DS_
_00168_DS_:
	MOVF	r0x05, W
	BANKSEL	_DebounceTeclas_valorNovo_1_7
	IORWF	_DebounceTeclas_valorNovo_1_7, F, B
	BRA	_00125_DS_
_00112_DS_:
;	.line	48; teclado.c	BitClr(valorNovo, (i * 2) + j);
	MOVF	r0x03, W
	ADDWF	r0x01, W
	MOVWF	r0x04
	MOVLW	0x01
	MOVWF	r0x05
	MOVF	r0x04, W
	BZ	_00171_DS_
	NEGF	WREG
	BCF	STATUS, 0
_00172_DS_:
	RLCF	r0x05, F
	ADDLW	0x01
	BNC	_00172_DS_
_00171_DS_:
	COMF	r0x05, W
	MOVWF	r0x04
	MOVF	r0x04, W
	BANKSEL	_DebounceTeclas_valorNovo_1_7
	ANDWF	_DebounceTeclas_valorNovo_1_7, F, B
_00125_DS_:
;	.line	44; teclado.c	for (j = 0; j < 2; j++) {
	INCF	r0x03, F
	MOVLW	0x02
	SUBWF	r0x03, W
	BTFSS	STATUS, 0
	BRA	_00124_DS_
;	.line	35; teclado.c	for (i = 0; i < 4; i++) {
	INCF	r0x01, F
	INCF	r0x01, F
	INCF	r0x02, F
	INCF	r0x02, F
	INCF	r0x00, F
	MOVLW	0x04
	SUBWF	r0x00, W
	BTFSS	STATUS, 0
	BRA	_00126_DS_
	BANKSEL	_DebounceTeclas_valorAntigo_1_7
;	.line	54; teclado.c	if (valorAntigo == valorNovo) {
	MOVF	_DebounceTeclas_valorAntigo_1_7, W, B
	BANKSEL	_DebounceTeclas_valorNovo_1_7
	XORWF	_DebounceTeclas_valorNovo_1_7, W, B
	BNZ	_00117_DS_
_00177_DS_:
	BANKSEL	_DebounceTeclas_tempo_1_7
;	.line	55; teclado.c	tempo--;
	DECF	_DebounceTeclas_tempo_1_7, F, B
	BRA	_00118_DS_
_00117_DS_:
;	.line	57; teclado.c	tempo = 10;
	MOVLW	0x0a
	BANKSEL	_DebounceTeclas_tempo_1_7
	MOVWF	_DebounceTeclas_tempo_1_7, B
;	.line	58; teclado.c	valorAntigo = valorNovo;
	MOVFF	_DebounceTeclas_valorNovo_1_7, _DebounceTeclas_valorAntigo_1_7
_00118_DS_:
	BANKSEL	_DebounceTeclas_tempo_1_7
;	.line	60; teclado.c	if (tempo == 0) {
	MOVF	_DebounceTeclas_tempo_1_7, W, B
	BNZ	_00128_DS_
;	.line	61; teclado.c	valor = valorAntigo;
	MOVFF	_DebounceTeclas_valorAntigo_1_7, _valor
_00128_DS_:
	MOVFF	PREINC1, r0x09
	MOVFF	PREINC1, r0x08
	MOVFF	PREINC1, r0x07
	MOVFF	PREINC1, r0x06
	MOVFF	PREINC1, r0x05
	MOVFF	PREINC1, r0x04
	MOVFF	PREINC1, r0x03
	MOVFF	PREINC1, r0x02
	MOVFF	PREINC1, r0x01
	MOVFF	PREINC1, r0x00
	MOVFF	PREINC1, FSR2L
	RETURN	

; ; Starting pCode block
S_teclado__LerTeclas	code
_LerTeclas:
;	.line	25; teclado.c	unsigned char LerTeclas(void) {
	MOVFF	FSR2L, POSTDEC1
	MOVFF	FSR1L, FSR2L
	BANKSEL	_valor
;	.line	26; teclado.c	return valor;
	MOVF	_valor, W, B
	MOVFF	PREINC1, FSR2L
	RETURN	



; Statistics:
; code size:	  454 (0x01c6) bytes ( 0.35%)
;           	  227 (0x00e3) words
; udata size:	    1 (0x0001) bytes ( 0.08%)
; access size:	   10 (0x000a) bytes


	end
