/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

// `include "ec_intf.if.svi"
`include "ec_trans.sv"

class ec_bfm extends vmm_xactor;

   vmm_log log = new("ec_bfm", "log");
   ec_trans_channel ch_in;
    //virtual ec_intf   ec_port_0;


    //function new( virtual ec_intf   ec_port_in);
   function new();
       super.new("","");
        //ec_port_0 = ec_port_in;
       ch_in = new("",""); 
   endfunction
	 
   virtual function void start_xactor();
      super.start_xactor(); 
      `vmm_debug(log, "ec_bfm::start_xactor");
   endfunction
    
   virtual task main();
      
      ec_trans ec_trans_tmp;    

      super.main();
      `vmm_debug(log, "ec_bfm::main");
      while(1) begin
         ch_in.peek(ec_trans_tmp);
         case(ec_trans_tmp.rw)
            ec_trans::WRITE : begin
	       write(ec_trans_tmp);
	       ch_in.get(ec_trans_tmp); // pop the request
	    end
	    ec_trans::READ : begin
	       read(ec_trans_tmp);
	       ch_in.get(ec_trans_tmp); // pop the request
	    end
         endcase
      end
   endtask 

   virtual task write(ec_trans trans_in);
      `vmm_debug(log, $psprintf("ec_bfm::write start %d", $time()));
      @(ec_port_0.cb);
      ec_port_0.cb.sot <= 1'b1; 
      ##1 ec_port_0.cb.sot <= 1'b0; 
      ec_port_0.cb.addr <= trans_in.addr;
      ec_port_0.cb.data <= trans_in.data;
      ec_port_0.cb.ale <= 1'b1; // to learn - even with mp passed in, still refer to cb!
      ##1 ec_port_0.cb.ale <= 1'b0;
      ##3 ec_port_0.cb.wr <= 1'b1;
      ec_port_0.cb.rd <= 1'b0;
      ##3 ec_port_0.cb.wr <= 1'b0;
         ec_port_0.cb.data <= 64'hZ;
      `vmm_debug(log, $psprintf("ec_bfm::write end %d", $time()));
   endtask 

    virtual task read(ref ec_trans trans_in);
       `vmm_debug(log, $psprintf("ec_bfm::read start %d addr = %0h ", $time(), trans_in.addr));
       @(ec_port_0.cb);
       ec_port_0.cb.sot <= 1'b1; 
       ##1 ec_port_0.cb.sot <= 1'b0; 
       ec_port_0.cb.addr <= trans_in.addr;
       ec_port_0.cb.ale <= 1'b1; 
       ##1 ec_port_0.cb.ale <= 1'b0; 
       ##3 ec_port_0.cb.rd <= 1'b1;
       @(ec_port_0.cb);
       @(ec_port_0.cb);
       trans_in.data = 64'hXXZZ;
       ##3 ec_port_0.cb.rd <= 1'b0;
       trans_in.data = ec_port_0.cb.data;
       `vmm_debug(log, $psprintf("ec_bfm::read done addr=%h data=%h, time=%d", trans_in.addr, trans_in.data, $time()));
       trans_in.notify.indicate(vmm_data::ENDED);
   endtask

endclass
