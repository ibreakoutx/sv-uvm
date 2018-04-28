/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


program memsys_test (memsys_intf intf); 

`include "cpu.v"
`include "memsys_coverage.v"

   cpu cpu0 = new (0);
   cpu cpu1 = new (1);

   range cov1 = new;
   virtual memsys_intf vintf; 
   cntlr_cov cov2 ;

initial begin
   vintf = intf; 
   cov2 = new; 
   init_ports();
   reset_sequence();
   check_all() ;
   $finish;
end


// Don't allow inputs to dut to float
task init_ports () ;
  $write("Task init_ports\n");
  @vintf.CBmemsys vintf.CBmemsys.request <= 2'b00;
  vintf.CBmemsys.busRdWr_N <= 1'b1;
  vintf.CBmemsys.adxStrb <= 1'b0;
  vintf.CBmemsys.reset <= 1'b0;
endtask

task reset_sequence () ;
   $write("Task reset_sequence\n");
   vintf.CBmemsys.reset <= 0;
   @vintf.CBmemsys vintf.CBmemsys.reset <= 1;
   repeat (10) @vintf.CBmemsys; 
   vintf.CBmemsys.reset <= 0;
   @vintf.CBmemsys assert(vintf.CBmemsys.grant == 2'b00); //check if grants are 0's
endtask

task check_all () ;
  integer randflag;
  event CPU1done;
  mailbox mboxId = new;
  $write("Task check_all:\n");

  fork 
     // fork process for CPU 0 
      repeat(256) begin
        randflag = cpu0.randomize();
        cpu0.request_bus();
        cpu0.writeOp();
        cpu0.release_bus();
        mboxId.put(cpu0.address);
        mboxId.put(cpu0.data);
        mboxId.put(cpu0.delay);
        wait(CPU1done.triggered);
        cpu0.delay_cycle();
      end

    // fork process for CPU 1 
      repeat(256) begin
        mboxId.get(cpu1.address);
        mboxId.get(cpu1.data);
        mboxId.get(cpu1.delay);
        cpu1.request_bus();
        cpu1.readOp();
        if (vintf.CBmemsys.busData == cpu1.data)
          $write("\nThe read and write cycles finished successfully\n\n");
        else
          $write("\nThe memory has been corrupted\n\n");
        cpu1.release_bus();
        ->CPU1done;
        cpu1.delay_cycle();
      end
  join
endtask

endprogram
