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

task automatic cpu_process(input semaphore s, input cpu cpuI, ref bit[7:0] mem_addI[*]);
        if(cpuI.randomize() == 0) begin
           $display("Fatal Error Randomization Failed. Exiting\n");
           $finish;
        end
        $write("\nCPU%0d : THE RAND MEM ADD IS %b \n\n", cpuI.cpu_id, cpuI.address);
        if (mem_addI[cpuI.address] !== cpuI.address)
        begin
           mem_addI[cpuI.address] = cpuI.address;
           $write("\nCPU%0d : mem_add[%b] is %b \n\n", 
              cpuI.cpu_id, cpuI.address, mem_addI[cpuI.address]);
        end
        else
        begin
           $write("\nCPU%0d : The memory address is being repeated\n\n", cpuI.cpu_id);
           $write("\nCPU%0d : mem_add[%b] is %b \n\n", 
              cpuI.cpu_id, cpuI.address, mem_addI[cpuI.address]);
        end
        s.get(1);
        cpuI.request_bus();
        cpuI.writeOp();
        cpuI.release_bus();
        cpuI.request_bus();
        cpuI.readOp();
        cpuI.release_bus();
        s.put(1);
        cpuI.delay_cycle();
endtask

task check_all () ;
  bit[7:0] mem_add0[*], mem_add1[*];
  semaphore semaphoreId = new(1);

  $write("Task check_all:\n");

  fork 
      // fork process for CPU 0
      repeat(256) cpu_process(semaphoreId, cpu0, mem_add0); 

     // fork process for CPU 1 
      repeat(256) cpu_process(semaphoreId, cpu1, mem_add1); 
  join
endtask
endprogram  // end of program memsys_test
