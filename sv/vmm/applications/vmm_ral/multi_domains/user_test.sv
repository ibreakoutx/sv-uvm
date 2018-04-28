/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

// Description: Simple user test for the RAL model

`include "tb_env.sv"

program test;

tb_env env = new;


initial
begin
   //vmm_ral_block_or_sys ral_model;
   vmm_ral_reg regs[];
   env.reset_dut();
   //ral_model = env.ral.get_model();
//simple example that iterates through the ral model, reads each field of each register except the Counters Array
   
   env.ral_model.box0.get_registers(regs);
   foreach (regs[i]) begin
          bit [63:0] val;
          vmm_rw::status_e status;
          regs[i].read(status,val);
           // Not primting fileds of COUNTER ARRAY
          $display("value of reg %s is %h",regs[i].get_name(), regs[i].get());
    end

   

    

   //env.run_for = 200;   
   env.run();
end
endprogram
