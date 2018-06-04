#ifndef DRVRTC_H
    #define DRVRTC_H

    #include "basico.h"



    void ht1380write(unsigned char addr, unsigned char data);
    unsigned char ht1380read(unsigned char addr);

    unsigned char rtcGetSeconds(void);
    unsigned char rtcGetMinutes(void);
    unsigned char rtcGetHours(void);
    unsigned char rtcGetDate(void);
    unsigned char rtcGetMonth(void);
    unsigned char rtcGetYear(void);
    unsigned char rtcGetDay(void);

    //void rtcGetDateTime(void);

    void rtcPutSeconds(unsigned char seconds);
    void rtcPutMinutes(unsigned char minutes);
    void rtcPutHours(unsigned char hours);
    void rtcPutDate(unsigned char date);
    void rtcPutMonth(unsigned char month);
    void rtcPutDay(unsigned char day);
    void rtcPutYear(unsigned char year);

    void rtcSetDateTime(void);

    void rtcInit();

#endif
