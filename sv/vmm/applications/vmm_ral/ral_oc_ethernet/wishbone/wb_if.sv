/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

//
// -------------------------------------------------------------
//    Copyright 2004-2008 Synopsys, Inc.
//    All Rights Reserved Worldwide
// 
//    Licensed under the Apache License, Version 2.0 (the
//    "License"); you may not use this file except in
//    compliance with the License.  You may obtain a copy of
//    the License at
// 
//        http://www.apache.org/licenses/LICENSE-2.0
// 
//    Unless required by applicable law or agreed to in
//    writing, software distributed under the License is
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//    CONDITIONS OF ANY KIND, either express or implied.  See
//    the License for the specific language governing
//    permissions and limitations under the License.
// -------------------------------------------------------------
// 


`ifndef WB_IF__SV
`define WB_IF__SV

//`include "vmm.sv"

interface wb_if;

   wire        clk;
   wire        rst;
   wire [63:0] wdat;
   wire [63:0] rdat;
   wire [15:0] wtgd;
   wire [15:0] rtgd;
   tri0        ack;
   wire [63:0] adr;
   wire        we;
   tri0        cyc;
   tri0        err;
   tri0        lock;
   tri0        rty;
   wire [ 7:0] sel;
   tri0        stb;
   wire [15:0] tga;
   wire [15:0] tgc;

   wire [ 2:0] cti;
   wire [ 1:0] bte;

   parameter setup_time = 1;
   parameter hold_time  = 1;

   clocking sysck @ (posedge clk);
      //default input setup_time output hold_time;
      output rst;
   endclocking

   modport syscon (output   clk,
                   clocking sysck);


   clocking mck @ (posedge clk);
      //default input setup_time output hold_time;
      input  rst, rdat, rtgd, ack, err, rty;
      output wdat, wtgd, adr, we, cyc, lock, sel, stb, tga, tgc, cti, bte;
   endclocking

   modport master (clocking mck);


   clocking sck @ (posedge clk);
      //default input setup_time output hold_time;
      input rst, wdat, wtgd;
   endclocking

   modport slave (clocking sck,
                  input  wdat, wtgd, adr, we, cyc, lock, sel, stb, tga, tgc, cti, bte,
                  output rdat, rtgd, ack, err, rty);


   clocking pck @ (posedge clk);
      //default input setup_time output hold_time;
      input  rst, rdat, rtgd, ack, err, rty, wdat, wtgd, adr, we, cyc,
             lock, sel, stb, tga, tgc, cti, bte;
   endclocking

   modport passive (clocking pck);

`ifdef SVA_CHECKERS
wb_slave_chk_if #(.wb_addr_width(64),
                  .wb_data_width(64))
wb_eth_slave_bus_mon
(
  // WISHBONE common
  .clk(clk),
  .reset_n(rst),

  // WISHBONE slave
  .ACK_O(ack),
  .ADR_I(adr),
  .CYC_I(cyc),
  .DAT_O(rdat),
  .DAT_I(wdat),
  .ERR_O(err),
  .RTY_O(rty),
  .SEL_I(sel),
  .STB_I(stb),
  .WE_I (we)
);

wb_master_chk_if #(.wb_addr_width(64),
                  .wb_data_width(64),
                  .wb_tag_width(5))
 wb_eth_master_bus_mon(
  // WISHBONE common
  .clk(clk),
  .reset_n(rst),

  // WISHBONE master
  .ACK_I(ack),
  .ADR_O(adr),
  .CYC_O(cyc),
  .DAT_I(rdat),
  .DAT_O(wdat),
  .ERR_I(err),
  .RTY_I(rty),
  .SEL_O(sel),
  .STB_O(stb),
  .WE_O (we),
  .TAG_O({cti, bte})
);
`endif


endinterface: wb_if

`ifdef SVA_CHECKERS
`include "master_chk.sv"
`include "slave_chk.sv"
`endif

`endif
