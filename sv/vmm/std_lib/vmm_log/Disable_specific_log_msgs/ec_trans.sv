/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

// `include "vmm.sv"

class ec_trans extends vmm_data;

   typedef enum {READ, WRITE} RW;
   rand RW rw;
   rand reg [31:0] addr;
   rand reg [7:0] data;
   static vmm_log log = new("","");
   function new();
	   super.new(log);
   endfunction
   task  display(string s = "");
      super.display();
      $display("%s -> addr=%h, rw=%s, data=%h \n", s, addr, rw, data);
   endtask 
   function vmm_data copy (vmm_data to = null);
      ec_trans t;
      // check if to is null
      if (to == null) begin
        // if to is null
         t = new();
      end 
      // if to is not null
      else begin
         // check if to is the same type of ec_trans
         if (!$cast(t,to)) begin
            // if to is the not the same type of ec_trans
	    `vmm_fatal(log, "ec_trans::copy failed to cast");
	 end
      end
         // if to is the the same type of ec_trans
      t.addr = this.addr;
      t.data = this.data;
      t.rw = this.rw;
      copy = t;
   endfunction  // function copy
endclass 
`vmm_channel(ec_trans)
