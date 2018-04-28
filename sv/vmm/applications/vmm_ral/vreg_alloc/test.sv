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
  vmm_rw::status_e status;
  logic [63:0] data;
		vmm_ral_vreg regs[];
  vmm_mam_region mem_reg;
  tb_env env = new;
  int i = 0;	
		env.hw_reset();
  env.start();

		`vmm_note(env.log,"**** Accessing Static Virtual registers VREG1 \n");
		for (i=0;i<5;i++) begin
				$display("Writing to vreg1[%0d] \n",i);
	   env.ral_model.dut.vreg1.write(i,status,$random);	
				$display("Reading from vreg1[%0d] \n",i);
	   env.ral_model.dut.vreg1.read(i,status,data);
		end

  `vmm_note(env.log,"**** Implementing the Dynamic Virtual Regsiter VREG2 \n");
		env.ral_model.dut.vreg2.implement(8,env.ral_model.dut.ram1,'h30,2);
		mem_reg = env.ral_model.dut.vreg2.get_region();
		if(mem_reg == null) 
				`vmm_error(env.log,"Implementing Dynamic Virtual register was not successful \n");
		for (i=0;i<8;i++) begin
				$display(" Writing to vreg2[%0d] \n",i);
	   env.ral_model.dut.vreg2.write(i,status,$random);	
				$display(" Reading from vreg2[%0d] \n",i);
	   env.ral_model.dut.vreg2.read(i,status,data);
		end

  `vmm_note(env.log,"**** Allocating the Dynamic Virtual Regsiter VREG3 using MAM \n");
		env.ral_model.dut.vreg3.allocate(15,env.ral_model.dut.ram1.mam);
		mem_reg = env.ral_model.dut.vreg3.get_region();
		if(mem_reg == null) 
				`vmm_error(env.log,"Implementing Dynamic Virtual register was not successful \n");
		for (i=0;i<15;i++) begin
				$display("Writing to vreg3[%0d] \n",i);
	   env.ral_model.dut.vreg3.write(i,status,$random);	
				$display("Reading from vreg3[%0d] \n",i);
	   env.ral_model.dut.vreg3.read(i,status,data);
		end

		
  env.ral_model.dut.vreg2.release_region();
		mem_reg = env.ral_model.dut.vreg2.get_region();
		if(mem_reg != null)
				`vmm_error(env.log,"VREG2 failed to release the region");
		else		
				`vmm_note(env.log,"VREG2 has released the region");
		
		env.ral_model.dut.vreg3.release_region();
		mem_reg = env.ral_model.dut.vreg3.get_region();
		if(mem_reg != null)
				`vmm_error(env.log,"VREG3 failed to release the region");
		else		
				`vmm_note(env.log,"VREG3 has released the region");

  env.log.report();	

end
endprogram



