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


module master_ip(output bit   [ 7:0] apb_addr,
                 output bit          apb_sel,
                 output bit          apb_enable,
                 output bit          apb_write,
                 input  bit   [15:0] apb_rdata,
                 output logic [15:0] apb_wdata,
                 input  bit          clk,
                 input  bit          rst);


always
begin
   bit [15:0] written[$];

   apb_sel <= #1 1'b0;
   apb_enable <= #1 1'b0;

   // Continuously perform random R&W cycles
   // Separated by 3 clock cycles
   repeat (3) @ (posedge clk);

   randcase
     written.size(): // READ cycle
       begin
          apb_addr  <= #1 written.pop_front();
          apb_sel   <= #1 1'b1;
          apb_write <= 1'b0;
          @ (posedge clk);
          apb_enable <= #1 1'b1;
          @ (posedge clk);
          $write("Read 'h%h from 'h%h\n", apb_rdata, apb_addr);
       end

     1: // WRITE cycle
       begin
          apb_addr  <= #1 $random;
          apb_wdata <= #1 $random;
          apb_sel   <= #1 1'b1;
          apb_write <= 1'b1;
          @ (posedge clk);
          apb_enable <= #1 1'b1;
          @ (posedge clk);
          $write("Wrote 'h%h at 'h%h\n", apb_wdata, apb_addr);
          written.push_back(apb_addr);
       end
   endcase
end

endmodule: master_ip
