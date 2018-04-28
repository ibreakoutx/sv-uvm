/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


// program ec_test(ec_intf ec_bind);
program ec_test(ec_intf ec_port_0);
`include "ec_ral_env.sv"
// program ec_test();


   vmm_log              log = new("log","program");
   ec_ral_env           ec_ral_env_0; 
   vmm_ral_reg          ral_reg[];
   vmm_ral_block_or_sys ral_block;
   reg [63:0]  val;
   reg [63:0]  addr;
   bit [63:0]  rdata;
   reg [63:0]  reg_rdata;
   bit [63:0]  wdata;
   vmm_rw::status_e stat;
   integer id;

   initial begin
   // ec_ral_env_0 = new(ec_bind); 
   ec_ral_env_0 = new(); 
   ral_block = ec_ral_env_0.ral.get_model();
   if (ral_block == null)
      `vmm_error(log, "ral_block is null ");
   ec_ral_env_0.reset_dut(); 
   ral_block.reset();

   ral_block.get_registers(ral_reg);

   $display("1 Sweeping through registers found in ec.ralf \n");
   foreach(ral_reg[i]) begin
      rdata = ral_reg[i].get(); // from RAL
      $display("\t reg(%0d)  name is %s, val (RAL) = %0h \n", i, ral_reg[i].get_name(), rdata);
   end   



   $display("2. A quick comparison between the RAL model and the design \n");
   // reg_rdata = ral_reg[0].get(); // from RAL
   // $display(" Register reset value from RAL = %0h \n", reg_rdata);

   // addr = 64'h0;
   // ec_ral_env_0.ral.read(addr, rdata);
   // ral_reg[0].read(stat, rdata); // orig

   for(id=0;id<3;id++) begin
      $display("        reg(%0d) Comparing RAL reset value to  design \n", id);
      ral_reg[id].mirror(stat, vmm_ral::VERB, vmm_ral::BFM); 
      // if (rdata == reg_rdata) 
      if (stat != vmm_rw::IS_OK) 
         $display("          Compare between RAL and design FAILED \n");
      else
         $display("          Compare between RAL and design PASSED \n");
   end


   addr = 64'h0;
   wdata = 8'h87;
   $display("3. Writing to dut - addr = %0h, wdata = %0h  \n", addr, wdata);
   ral_reg[0].write(stat, wdata);

   ral_reg[0].read(stat, wdata);
   $display("4. Reading from addr = %0h, rdata = %0h  \n", addr, rdata);
   // repeat(4) 
   //       @(ec_bind.cb);

   ec_ral_env_0.run();
   end
 
endprogram



