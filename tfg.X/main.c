#include "basico.h"
#include "config.h"
#include "lcd.h"
#include "timer.h"

int pulsos, tmp;
char i;

void Contador(void) __interrupt 1 {


    if (BitTst(PIR1, 1)) {

        tmp += TMR0L;
        TMR0L = 0; //zerar o contador de pulsos
        BitClr(PIR1, 1); //limpar flag do timer  
        i++;
        if (i == 100) {
            i = 0;
            pulsos = tmp;   //quantidade de pulsos a cada 1,003s
            tmp = 0;
        }
    }
}

void main(void) {
    //TMR0L = 0;  //zerar o contador de pulsos
    PR2 = 98; //valor para a interrupção do timer2 durar 10,03 ms
    BitSet(TRISA, 4); //seta o bit 4 como entrada
    InicializaLCD();
    BitSet(T0CON, 6); //timer0 8 bits
    BitSet(T0CON, 5); //habilita o clock externo
    BitSet(T0CON, 4); //habilita a borda de subida
    BitSet(T0CON, 3); //não usar prescaler
    BitSet(T0CON, 7); //habilita o timer0

    BitSet(T2CON, 6); //postscale 1:16
    BitSet(T2CON, 5); //postscale 1:16
    BitSet(T2CON, 4); //postscale 1:16
    BitSet(T2CON, 3); //postscale 1:16
    BitSet(T2CON, 1); //prescaler 16
    BitSet(T2CON, 2); //habilita o timer2
    BitSet(PIE1, 1); //habilita o interrrupt do timer2 (dura 10,03 ms)

    BitSet(INTCON, 7); //habilita interrupt global
    BitSet(INTCON, 6); //habilita interrupt perifericos


    for (;;) {
        EnviaComando(0x01); //limpar display
        EnviaDados('R');
        EnviaDados('P');
        EnviaDados('M');
        EnviaDados(':');
        EnviaDados(((60*pulsos) / 1000) % 10 + 48);
        EnviaDados(((60*pulsos) / 100) % 10 + 48);
        EnviaDados(((60*pulsos) / 10) % 10 + 48);
        EnviaDados(((60*pulsos) / 1) % 10 + 48);
    }
}
