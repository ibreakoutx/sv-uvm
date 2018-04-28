/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

program test_consensus_pgm;
`include "vmm.sv"
   
class testmanager extends vmm_xactor;
  event status_error_event;

   function new();
      super.new("tm", "0", 1);
   endfunction : new
   

   task main();
      super.main();
         wait_for_status();
   endtask : main
   
   task wait_for_status();
      forever begin
         @status_error_event;
         `vmm_note(log, "Unexpected Status Error");
      end
   endtask // wait_for_status
endclass : testmanager
   
class environment extends vmm_env;
   testmanager tm;

   virtual function void build();
     super.build();
     tm = new();  // no voter reference
   endfunction : build

   task start();
      super.start();
      this.tm.start_xactor();
      this.end_vote.register_xactor(tm);
      this.end_vote.psdisplay("CONSENSUS");
   endtask

   task wait_for_end();
      super.wait_for_end();
      `vmm_note (log, "Waiting for Consensus to be reached");
      end_vote.wait_for_consensus();
      `vmm_note (log, "Consensus reached");
   endtask
endclass // environment


   environment my_env;
   initial begin : test
      my_env = new();
      fork my_env.run();
      join_none
      
      #0;
      -> my_env.tm.status_error_event;
         #100;
   
   
   end : test
endprogram : test_consensus_pgm


