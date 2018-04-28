/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class ec_env extends vmm_env ;

   ec_bfm ec_bfm_0;
   virtual ec_intf ec_bind;

   function new(virtual ec_intf ec_bind_in) ;
      super.new();
      ec_bind =  ec_bind_in;
   endfunction

   virtual task reset_dut() ;
      super.reset_dut();
      $display(" ec_ral_env::hw_reset  \n");
      ec_bind.cb.rst_ <= 1'b0;
      ec_bind.cb.rd <= 1'b0;
      ec_bind.cb.wr <= 1'b0;
      ec_bind.cb.sot <= 1'b0;
      ec_bind.cb.ale  <= 1'b0;
      ec_bind.cb.data <= 32'hZ;
      ec_bind.cb.addr <= 32'hZ;
      ##4 ec_bind.cb.rst_ <= 1'b1;
   endtask// endtaskcb.

   virtual task start() ;
      super.start();
      $display(" ec_ral_env::start  \n");
      ec_bfm_0.start_xactor();
   endtask // endtask
   virtual task wait_for_end() ;
      super.wait_for_end();
      $display(" ec_ral_env::wait_for_end  \n");
      repeat(100) 
         @(ec_bind.cb);
   endtask // endtask

   virtual function void build() ;
      super.build();
      `vmm_debug(log, "ec_ral_env::build - start");
      ec_bfm_0 = new(ec_bind); // ec_top_mod.ec_intf_0);
      `vmm_debug(log, "ec_ral_env::build - end");
   endfunction // function

endclass // class
