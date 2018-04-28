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

 `include "tb_env.sv"

initial begin
  vmm_version v = new;
  vmm_ral_version ral_v = new;
  vmm_rw::status_e status;
  logic [63:0] data;
		vmm_ral_reg regs[];
		
  tb_env env = new;
  	
  env.start();
	
	 env.ral_model.get_registers(regs,"");
  foreach(regs[i]) begin
		  regs[i].read(status,data);
				$display("Read Data for register '%s' : %h ",regs[i].get_fullname,data);
				`vmm_note(env.log,$psprintf("Read Status : %s \n",status));
		end

	env.log.report();	
		
end
endprogram
