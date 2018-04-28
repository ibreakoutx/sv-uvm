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


`ifndef TB_ENV__SV
`define TB_ENV__SV

`include "vmm.sv"

`include "apb.sv"

class tb_env extends vmm_env;
   apb_slave slv;
`ifdef RANDOM_RESPONSE
   apb_rw_channel resp_chan;
`endif

   int stop_after = 10;

   virtual function void build();
      super.build();
`ifdef RANDOM_RESPONSE
      this.resp_chan = new("APB Response", "0");
      this.slv = new("0", 0, tb_top.apb0, null, this.resp_chan);
`else
      this.slv = new("0", 0, tb_top.apb0);
`endif
   endfunction: build

   virtual task start();
      super.start();
      this.slv.start_xactor();

      fork
`ifdef RANDOM_RESPONSE
         forever begin
            apb_rw tr;
            this.resp_chan.peek(tr);
            if (tr.kind == apb_rw::READ) begin
               tr.kind.rand_mode(0);
               tr.addr.rand_mode(0);
               if (!tr.randomize()) begin
                  `vmm_error(log, "Unable to randomize APB response");
               end
            end
            this.resp_chan.get(tr);
         end
`endif

         forever begin
            apb_rw tr;
            this.slv.notify.wait_for(apb_slave::RESPONSE);
            this.stop_after--;
            if (this.stop_after <= 0) -> this.end_test;
            $cast(tr, this.slv.notify.status(apb_slave::RESPONSE));
            tr.display("Responded: ");
         end
      join_none
   endtask: start

   virtual task wait_for_end();
      super.wait_for_end();
      @ (this.end_test);
   endtask: wait_for_end

endclass: tb_env

`endif
