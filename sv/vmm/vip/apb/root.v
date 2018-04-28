/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`timescale 1ns/1ns

parameter APB_ADDR_WIDTH = 16;
typedef bit [APB_ADDR_WIDTH-1:0] apb_addr_t;
parameter APB_DATA_WIDTH = 32;
typedef bit [APB_DATA_WIDTH-1:0] apb_data_t;

typedef enum {READ, WRITE, IDLE} trans_e;

top top();
