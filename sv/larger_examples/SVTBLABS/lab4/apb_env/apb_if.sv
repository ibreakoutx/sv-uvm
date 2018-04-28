/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

/***************************************************************************
 *
 * File:        $RCSfile: apb_if.sv,v $
 * Revision:    $Revision: 1.3 $  
 * Date:        $Date: 2003/07/15 15:18:31 $
 *
 *******************************************************************************
 *
 * Generic APB interface
 *
 *******************************************************************************
*/

`ifndef APB_IF_DEFINE
`define APB_IF_DEFINE

interface apb_if(input PClk);
  logic [APB_ADDR_WIDTH-1:0]  PAddr;
  logic PSel;
  logic [APB_DATA_WIDTH-1:0]  PWData;
  logic [APB_DATA_WIDTH-1:0]  PRData;
  logic PEnable;
  logic PWrite;
  logic Rst;

  clocking master_cb @(posedge PClk);
    default input #1 output #1;
    output  PAddr;
    output  PSel;
    output  PWData;
    input   PRData;
    output  PEnable;
    output  PWrite;
    output  Rst; 
  endclocking

  clocking monitor_cb @(posedge PClk);
    // default input #1skew output #0;
    input  PAddr;
    input  PSel;
    input  PWData;
    input  PRData;
    input  PEnable;
    input  PWrite;
    input  Rst; 
  endclocking

  modport Master(clocking master_cb);
  modport Monitor(clocking monitor_cb);

  modport Slave(input PAddr, PClk, PSel, PWData, PEnable, PWrite, Rst,
                output PRData);
  

endinterface

`endif    

