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


`include "master_ip.sv"
`include "slave_ip.sv"

module tb_top;
   bit clk = 0;

   apb_if apb0(clk);

   master_ip dut_mst(.apb_addr   (apb0.paddr[7:0]  ),
                     .apb_sel    (apb0.psel        ),
                     .apb_enable (apb0.penable     ),
                     .apb_write  (apb0.pwrite      ),
                     .apb_rdata  (apb0.prdata[15:0]),
                     .apb_wdata  (apb0.pwdata[15:0]),
                     .clk        (clk));

   always #10 clk = ~clk;
endmodule: tb_top
