/*
 * Copyright (c) 2009 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

/*
 * helloworld.c: simple test application
 */

#include <stdio.h>
#include <math.h>
#include "platform.h"
#include "xparameters.h"
#include "xuartlite_l.h"
//#include "xgpio.h"
//#include "xil_io.h"
#include "mb_interface.h"

#define LEDS_BASEADDR XPAR_LEDS_8BITS_BASEADDR
#define SW_BASEADDR XPAR_DIP_SWITCHES_8BITS_BASEADDR
#define BTN_BASEADDR XPAR_PUSH_BUTTONS_4BITS_BASEADDR

void print(char *str);

int ctox(char c)
{
	unsigned num;

	switch (c) {
	case '0':
		num = 0;
		break;
	case '1':
		num = 1;
		break;
	case '2':
		num = 2;
		break;
	case '3':
		num = 3;
		break;
	case '4':
		num = 4;
		break;
	case '5':
		num = 5;
		break;
	case '6':
		num = 6;
		break;
	case '7':
		num = 7;
		break;
	case '8':
		num = 8;
		break;
	case '9':
		num = 9;
		break;
	case 'a':
	case 'A':
		num = 10;
		break;
	case 'b':
	case 'B':
		num = 11;
		break;
	case 'c':
	case 'C':
		num = 12;
		break;
	case 'd':
	case 'D':
		num = 13;
		break;
	case 'e':
	case 'E':
		num = 14;
		break;
	case 'f':
	case 'F':
		num = 15;
		break;
	}

	return num;
}

int main()
{
    init_platform();

    xil_printf("%s\n\r", "Welcome to Brutus cracker system!");

    while (1) {
    	xil_printf("%s\n\r", "Enter hash: ");
		char recv = XUartLite_RecvByte(STDIN_BASEADDRESS); // read first char


		/* Read password hash */
		char buff[32];
		int idx_buff = 0;
		while (recv != '\r') {
			buff[idx_buff++] = recv;
			recv = XUartLite_RecvByte(STDIN_BASEADDRESS);
		}

		unsigned int i_buff[4] = {0};
		unsigned num = 0;

		for (int i = 0; i < 4; i++) {
			for (int j = 0; j < 8; j++) {
				num = ctox(buff[j + i*8]);
				i_buff[i] += (pow(16, 7-j) * num);
			}
			//xil_printf("%x\n\r", i_buff[i]);
		}

		//xil_printf("%u\n\r", i_buff[0]);


		putfsl(i_buff[0], 0);
		putfsl(i_buff[1], 0);
		putfsl(i_buff[2], 0);
		putfsl(i_buff[3], 0);
		xil_printf("Cracking...\n\r");

		unsigned int resp;
		char *str = &resp; // c-magic

		getfsl(resp, 0);
		unsigned i;
		xil_printf("password: ");
		for (i = 0; i < 4; i++) {
			xil_printf("%c", *(str+i));
		}
		getfsl(resp, 0);
		for (i = 0; i < 4; i++) {
			xil_printf("%c", *(str+i));
		}
		xil_printf("\n\r");
    }
    cleanup_platform();

    return 0;
}
