/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



`include "tb_env.sv"

program test;

vmm_log log = new("User Defined", "Test");
tb_env env = new;

initial
begin
   bit [`VMM_RAL_DATA_WIDTH-1:0] reg_value;
   bit status;
   vmm_ral_field fields[]; 
   vmm_ral_reg regs[]; 
   env.cfg_dut();

   env.ral_model.get_registers(regs);
   foreach (regs[i]) begin
   regs[i].get_fields(fields);
   foreach (fields[i]) begin

//frontdoor write and frontdoor read
     fields[i].write(status, 8'hf);
     fields[i].read(status, reg_value);
          `vmm_note(log, $psprintf("FRONTDOOR - READ: field: %s = %0h \n\n", fields[i].get_name(), reg_value));

//frontdoor write and backdoor read
     fields[i].write(status, 8'h0);
     fields[i].read(status, reg_value,vmm_ral::BACKDOOR);
          `vmm_note(log, $psprintf("BACKDOOR - READ: field: %s = %0h \n\n", fields[i].get_name(), reg_value)); 

//backdoor write and frontdoor read
     fields[i].write(status, 8'hf,vmm_ral::BACKDOOR);
     fields[i].read(status, reg_value);
          `vmm_note(log, $psprintf("FRONTDOOR - READ: field: %s = %0h \n\n", fields[i].get_name(), reg_value)); 

//backdoor write and backdoor read
     fields[i].write(status, 8'h0,vmm_ral::BACKDOOR);
     fields[i].read(status, reg_value,vmm_ral::BACKDOOR);
          `vmm_note(log, $psprintf("BACKDOOR - READ: field: %s = %0h \n\n", fields[i].get_name(), reg_value)); 
    
   end
  end

   env.run();
end
endprogram
