// -----------------------------------------------------------------------
//   Copyright (C) Rodrigo Almeida 2010
// -----------------------------------------------------------------------
//   Arquivo: lcd.c
//            Biblioteca de manipulação do LCD
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


#include "lcd.h"
#include "basico.h"

#define RS 0
#define EN 1
#define RW 2

void Delay40us(void)
{
	//para um cristal de 8MHz cada instrução
	//gasta 0,5 us: 40/0,5 = 80 instruções
	unsigned char i;
	for(i=0; i < 25; i++); //3 + 3 * 25 = 78
}

void Delay2ms(void)
{
	unsigned char i;
	for(i=0; i < 200; i++)
	{
		Delay40us();
	}
}


void EnviaComando(unsigned char cmd)
{
	BitClr(PORTE,RS);	//comando
	BitClr(PORTE,RW);	// habilita escrita

	PORTD = cmd;
	BitSet(PORTE,EN);//habilita leitura
	Delay2ms();
	BitClr(PORTE,EN);//termina leitura
	BitClr(PORTE,RS);	//deixa em nivel baixo
	BitClr(PORTE,RW);	//deixa em nivel baixo
	Delay2ms();
}

void EnviaDados(unsigned char valor)
{
	BitSet(PORTE,RS);	//dados
	BitClr(PORTE,RW);	// habilita escrita


	PORTD = valor;
	BitSet(PORTE,EN);//habilita leitura
	Delay40us();
	BitClr(PORTE,EN);//termina leitura
	BitClr(PORTE,RS);	//deixa em nivel baixo
	BitClr(PORTE,RW);	//deixa em nivel baixo
	Delay40us();
}

void InicializaLCD(void)
{
// Inicializa o LCD

	// garante inicialização do LCD
	Delay2ms();
	Delay2ms();
	Delay2ms();
	Delay2ms();
	Delay2ms();

	// configurações de direção dos terminais
	BitClr(TRISE,RS);	//RS
	BitClr(TRISE,EN);	//EN
	BitClr(TRISE,RW);	//RW
	TRISD = 0x00;		//dados
	ADCON1 = 0b00001110;	//apenas

	//configura o display
	EnviaComando(0x38);	//8bits, 2 linhas, 5x8
	EnviaComando(0x06);	//modo incremental
	EnviaComando(0x0C);	//display e cursor on, com blink
	EnviaComando(0x03);	//zera tudo
	EnviaComando(0x01);	//limpar display
	EnviaComando(0x80);	//posição inicial
}
