/*
 * main.c
 *
 *  Created on: 6/06/2023
 *      Author: fshe388
 */

#include <stdio.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "alt_types.h"
#include "sys/alt_irq.h"

#define SEG0 0b11000000
#define SEG1 0b11111001
#define SEG2 0b10100100
#define SEG3 0b10110000
#define SEG4 0b10011001
#define SEG5 0b10010010
#define SEG6 0b10000010
#define SEG7 0b11111000
#define SEG8 0b10000000
#define SEG9 0b10010000
#define SEGA 0b10001000
#define SEGB 0b10000011
#define SEGC 0b11000110
#define SEGD 0b10100001
#define SEGE 0b10000110
#define SEGF 0b10001110
#define SEGBLANK 0b11111111;
#define SEGALLON 0b00000000;

typedef union Data {
	int data;
	char byte[4];
} Data;

char single_digit(int number){
	switch(number){
	case 0:
		return SEG0;
	case 1:
		return SEG1;
	case 2:
		return SEG2;
	case 3:
		return SEG3;
	case 4:
		return SEG4;
	case 5:
		return SEG5;
	case 6:
		return SEG6;
	case 7:
		return SEG7;
	case 8:
		return SEG8;
	case 9:
		return SEG9;
	case 0xa:
		return SEGA;
	case 0xb:
		return SEGB;
	case 0xc:
		return SEGC;
	case 0xd:
		return SEGD;
	case 0xe:
		return SEGE;
	case 0xf:
		return SEGF;
	default:
		return SEGBLANK;
	}
}

int main(void){
	// in
	char ccd = 0;
	char pcd = 0;
	int sw = 0;
	int key = 0;
	char recv_addr = 0;
	Data recv_data;
	recv_data.data = 0;

	// out
	char send_addr = 0;
	Data send_data;
	char hex[6] = {0};
	int ledr = 0;

	send_data.data = 0;

	// while loop
	while(1){
		// read ccd and pcd
		ccd = IORD_ALTERA_AVALON_PIO_DATA(CCD_BASE);
		pcd = IORD_ALTERA_AVALON_PIO_DATA(PCD_BASE);
		sw = IORD_ALTERA_AVALON_PIO_DATA(SW_BASE);
		key = IORD_ALTERA_AVALON_PIO_DATA(KEY_BASE);
		recv_addr = IORD_ALTERA_AVALON_PIO_DATA(RECV_ADDR_BASE);
		recv_data.data = IORD_ALTERA_AVALON_PIO_DATA(RECV_DATA_BASE);

		// do stuff
		if (recv_data.data != 0){
			for (int i = 0; i < 4; i++){
				hex[i] = single_digit((int) recv_data.byte[i]);
			}
		}


		hex[4] = single_digit((int) ccd);
		hex[5] = single_digit((int) pcd);

		// ledr = recv_data.data;

		// outputs
		IOWR_ALTERA_AVALON_PIO_DATA(HEX_0_BASE, hex[0]);
		IOWR_ALTERA_AVALON_PIO_DATA(HEX_1_BASE, hex[1]);
		IOWR_ALTERA_AVALON_PIO_DATA(HEX_2_BASE, hex[2]);
		IOWR_ALTERA_AVALON_PIO_DATA(HEX_3_BASE, hex[3]);
		IOWR_ALTERA_AVALON_PIO_DATA(HEX_4_BASE, hex[4]);
		IOWR_ALTERA_AVALON_PIO_DATA(HEX_5_BASE, hex[5]);
		// IOWR_ALTERA_AVALON_PIO_DATA(LEDR_BASE, ledr);
		IOWR_ALTERA_AVALON_PIO_DATA(SEND_ADDR_BASE, send_addr);
		IOWR_ALTERA_AVALON_PIO_DATA(SEND_DATA_BASE, send_data.data);
	}

	return 0;
}

