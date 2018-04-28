/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

program test;
`define VMM_12
`include "tb_env.sv"

class my_test extends vmm_test;
   tb_env env = new;
   vmm_ral_block_or_sys rals[$];
   vmm_rw::status_e status;
   vmm_ral_reg regs[];
   logic [63:0] data;

   function new();
      super.new("RAL-based Verif Env", "RAL test", null);
   endfunction

   virtual function void build_ph();
      super.build_ph();
      this.env = new("tb_env", this);
   endfunction

   virtual function void start_of_sim_ph();
      env.ral_model.display();
   endfunction

   virtual task start_ph();
     env.ral_model.get_registers(regs,"");
     /* Check the reset value of these registers */
     `vmm_note(env.log,"Checking the reset values of all the registers available in the system :: \n");
      foreach(regs[i]) begin
         regs[i].mirror(status,vmm_ral::VERB);
      end
   endtask

   virtual task run_ph();
      env.ral_model.DUT_BLK.DATA_REG.write(status,8'hAB);
      env.ral_model.DUT_BLK.DATA_REG.read(status,data);
      if(data != 8'hAB)
         `vmm_error(env.log,$psprintf("Read returns incorrect value(%0h) ...\n",data));
      else
         `vmm_note(env.log,$psprintf("Read returns correct value(%0h) ...\n",data));

      env.ral_model.DUT_BLK.CTRL_REG.write(status,8'hCD);
      env.ral_model.DUT_BLK.CTRL_REG.read(status,data);
      if(data != 8'hCD)
         `vmm_error(env.log,$psprintf("Read returns incorrect value(%0h) ...\n",data));
      else
         `vmm_note(env.log,$psprintf("Read returns correct value(%0h) ...\n",data));
   endtask

endclass

initial begin
		
  my_test tst = new;
  vmm_simulation::list();
  vmm_simulation::run_tests();

end
endprogram



