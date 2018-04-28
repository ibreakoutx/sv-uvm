/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


class new_data extends my_data ;
   constraint c {
      data < 8'h7F;
   }
endclass

class test_01 ;
   
   task run(my_env env) ;
         new_data nd = new;
      `vmm_note(env.log, "Running test 01...");
      env.pre_test();
         env.xactor1.data = nd;
      env.run();
   endtask
			
endclass
