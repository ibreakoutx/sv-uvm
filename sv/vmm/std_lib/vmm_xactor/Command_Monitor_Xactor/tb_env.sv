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
   apb_monitor       mon;

   int stop_after = 10;

   virtual function void build();
      super.build();
      this.mon = new("0", 0, tb_top.apb0);
   endfunction: build

   virtual task start();
      super.start();
      this.mon.start_xactor();
      this.mon.out_chan.flow();

      fork
         forever begin
            apb_rw tr;
            this.mon.out_chan.get(tr);
            tr.display("Observed: ");
         end

         forever begin
            apb_rw tr;
            this.mon.notify.wait_for(apb_monitor::OBSERVED);
            this.stop_after--;
            if (this.stop_after <= 0) -> this.end_test;
            $cast(tr, this.mon.notify.status(apb_monitor::OBSERVED));
            tr.display("Notified: ");
         end
      join_none
   endtask: start

   virtual task wait_for_end();
      super.wait_for_end();
      @ (this.end_test);
   endtask: wait_for_end

endclass: tb_env

`endif
