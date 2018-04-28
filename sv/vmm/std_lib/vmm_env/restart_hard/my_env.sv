/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


class my_env extends vmm_env ;

   my_xactor xactor1;
   my_xactor xactor2;
   function new() ;
     super.new();
   endfunction 

virtual function void gen_cfg() ;
      super.gen_cfg();
   endfunction

virtual function void build() ;
      super.build();

      xactor1 = new("1", 1);
      xactor2 = new("2", 2);
   endfunction

   virtual task cfg_dut() ;
      super.cfg_dut();
   endtask
			
virtual task start() ;
      super.start();

      xactor1.start_xactor();
      xactor2.start_xactor();
   endtask

virtual task wait_for_end() ;
      super.wait_for_end();

      #10;
   endtask

virtual task stop() ;
      super.stop();

      xactor1.stop_xactor();
      xactor2.stop_xactor();
   endtask

virtual task restart(bit reconfig = 0) ;
      super.restart(reconfig);

      if (reconfig) return;
      
      xactor1.reset_xactor();
      xactor2.reset_xactor();
   endtask

virtual task report() ;
      super.report();
   endtask

endclass
