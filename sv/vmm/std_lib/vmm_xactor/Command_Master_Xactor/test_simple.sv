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


`include "tb_env.sv"

program simple_test;

vmm_log log = new("Test", "Simple");
tb_env env = new;
initial begin
   apb_rw rd, wr;
   bit ok;

   env.start();

   wr = new;
   ok = wr.randomize() with {
      kind == WRITE;
   };
   if (!ok) begin
      `vmm_fatal(log, "Unable to randomize WRITE cycle");
   end
   env.mst.in_chan.put(wr);

   rd = new;
   ok = rd.randomize() with {
      kind == READ;
      addr == wr.addr;
   };
   if (!ok) begin
      `vmm_fatal(log, "Unable to randomize READ cycle");
   end
   env.mst.in_chan.put(rd);

   if (rd.data[15:0] !== wr.data[15:0]) begin
      `vmm_error(log, "Readback value != write value");
   end

   log.report();
   $finish();
end

endprogram
