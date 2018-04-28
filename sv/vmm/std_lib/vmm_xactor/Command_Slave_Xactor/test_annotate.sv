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

program annotate_test;


class annotated_apb_rw extends apb_rw;
   string note;

   virtual function vmm_data allocate();
      annotated_apb_rw tr = new;
      return tr;
   endfunction

   virtual function vmm_data copy(vmm_data to = null);
      annotated_apb_rw tr;

      if (to == null) tr = new;
      else if (!$cast(tr, to)) begin
         `vmm_fatal(log, "Cannot copy to a non-annotated_apb_rw instance");
         return null;
      end

      super.copy(tr);
      tr.note = this.note;

      return tr;
   endfunction

   virtual function string psdisplay(string prefix = "");
      psdisplay = {super.psdisplay(prefix), " (", this.note, ")"};
   endfunction
endclass


class annotate_tr extends apb_slave_cbs;

   local int    seq = 0;
   local string format = "[-%0d-]";

   function new(string format = "");
      if (format != "") this.format = format;
   endfunction

   virtual function void pre_response(apb_slave xact,
                                      apb_rw    cycle);
      annotated_apb_rw tr;
      if (!$cast(tr, cycle)) begin
         `vmm_error(xact.log, "Transaction descriptor is not a annotated_apb_rw");
         return;
      end

      $sformat(tr.note, this.format, this.seq++);
   endfunction: pre_response
endclass


vmm_log log = new("Test", "Annotate");
tb_env env = new;
initial begin
   env.stop_after = 5;

   env.build();
   begin
      annotated_apb_rw tr = new;
      annotate_tr      cb = new;

      env.slv.tr_factory = tr;
      env.slv.append_callback(cb);
   end

   env.run();

   $finish();
end

endprogram
