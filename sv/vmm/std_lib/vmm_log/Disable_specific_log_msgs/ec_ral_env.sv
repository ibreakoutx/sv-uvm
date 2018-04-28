/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`include "ec_ral_bfm.sv"
`include "ral_ec.sv"

class ec_ral_env extends vmm_ral_env ;

   ec_ral_bfm ec_ral_bfm_0;
   ral_sys_ec ral_sys_ec_0;
   vmm_log log = new("log", "ec_ral_env");
   extern function new() ;
   extern task hw_reset() ;
   extern virtual task wait_for_end();
   extern virtual task start() ;
   extern virtual function  void build() ;
   extern virtual function  void gen_cfg() ;

endclass
   function ec_ral_env::new() ;
      ral_block_timer ral_block_ec_timer_0;
      super.new();
      ral_block_ec_timer_0 = new; 
      `vmm_debug(log, "set_model");
      ral.set_model(ral_block_ec_timer_0);
      ec_ral_bfm_0 = new(); // ec_top_mod.ec_intf_0);
  endfunction

   task ec_ral_env::hw_reset() ;
      $display(" ec_ral_env::hw_reset  \n");
      ec_port_0.cb.rst_ <= 1'b0;
      ec_port_0.cb.rd <= 1'b0;
      ec_port_0.cb.wr <= 1'b0;
      ec_port_0.cb.sot <= 1'b0;
      ec_port_0.cb.ale  <= 1'b0;
      ec_port_0.cb.data <= 32'hZ;
      ec_port_0.cb.addr <= 32'hZ;
      ##4 ec_port_0.cb.rst_ <= 1'b1;
   endtask// endtaskcb.

   task ec_ral_env::wait_for_end() ;
      super.wait_for_end();
      repeat(100) 
         @(ec_port_0.cb);
   endtask // endtask

   task ec_ral_env::start() ;
      super.start();
      `vmm_debug(log, "ec_ral_env::start start");
      `vmm_debug(log, "ec_ral_env::start end");
   endtask

   function void ec_ral_env::gen_cfg() ;
      super.gen_cfg() ;
   endfunction // function

   function void ec_ral_env::build() ;
      super.build();
      `vmm_debug(log, "ec_ral_env::build - start");
      `vmm_debug(log, "add_xactor - before ");
      super.ral.add_xactor(ec_ral_bfm_0); //crash
      `vmm_debug(log, "add_xactor - after ");
      ec_ral_bfm_0.start_xactor();
 
      `vmm_debug(log, "ec_ral_env::build - end");
   endfunction // function

