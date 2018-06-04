// -----------------------------------------------------------------------
//   Copyright (C) Rodrigo Almeida 2014
// -----------------------------------------------------------------------
//   Arquivo: teclado.c
//            Biblioteca de operação de um teclado matricial
//   Autor:   Rodrigo Maximiano Antunes de Almeida
//            rodrigomax at unifei.edu.br
//   Licensa: GNU GPL 2
// -----------------------------------------------------------------------
//   This program is free software; you can redistribute it and/or modify
//   it under the terms of the GNU General Public License as published by
//   the Free Software Foundation; version 2 of the License.
//
//   This program is distributed in the hope that it will be useful,
//   but WITHOUT ANY WARRANTY; without even the implied warranty of
//   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//   GNU General Public License for more details.
// -----------------------------------------------------------------------

#include "teclado.h"
#include "basico.h"

static unsigned char valor = 0x00;

unsigned char LerTeclas(void) {
    return valor;
}

void DebounceTeclas(void) {
    unsigned char i, j;
    static unsigned char tempo;
    static unsigned char valorNovo = 0x0000;
    static unsigned char valorAntigo = 0x0000;

    for (i = 0; i < 4; i++) {

        //desliga todas as colunas
        PORTB |= 0x0F;
        BitClr(PORTB, (i)); //liga a coluna correspondente
        //gasta tempo atoa, necessário para garantir que o pino atingiu o nivel alto
        for (j = 0; j < 100; j++);

        //realiza o teste para cada bit e atualiza a variável
        for (j = 0; j < 2; j++) {
            if (!BitTst(PORTB, j + 4)) {
                BitSet(valorNovo, (i * 2) + j);
            } else {
                BitClr(valorNovo, (i * 2) + j);
            }
        }

 
    }
    if (valorAntigo == valorNovo) {
        tempo--;
    } else {
        tempo = 10;
        valorAntigo = valorNovo;
    }
    if (tempo == 0) {
        valor = valorAntigo;
    }
}

void InicializaTeclado(void) {
    TRISB = 0xF0; //quatro entradas e quatro saidas
    BitClr(INTCON2, 7); //liga pull up
    ADCON1 = 0b00001110; //apenas AN0 é analogico, a referencia é baseada na fonte

#ifdef PIC18F4550
    SPPCFG = 0x00;          // SFR nao presente no PIC18F4520
#endif
}