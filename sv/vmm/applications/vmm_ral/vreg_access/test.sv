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
  logic [15:0] data;
		vmm_ral_vreg vregs[];
  vmm_ral_mem mem;
	 int i = 0;
  tb_env env;
		env =  new;
  env.hw_reset();
		env.start();
  env.ral_model.get_virtual_registers(vregs);
		`vmm_note(env.log,"Printing all virtual registers available in the design .....\n");
  foreach (vregs[i]) begin
    `vmm_note(env.log, $psprintf("Virtual register Name: %s\n", vregs[i].get_fullname()));
  end

  `vmm_note(env.log,"***********Accessing register via FRONTDOOR *************");
		for(i = 0; i<20; i++) begin
			data = $random;	
   env.ral_model.dut.vreg_rw.write(i,status,data);
   env.ral_model.dut.vreg_rw.read(i,status,data);
  end
		for(i = 0; i<3; i++) begin
			data = $random;	
   env.ral_model.dut.vreg_ro.write(i,status,data);
   env.ral_model.dut.vreg_ro.read(i,status,data);
  end
		for(i = 0; i<5; i++) begin
			data = $random;	
   env.ral_model.dut.vreg_w1c.write(i,status,data);
   env.ral_model.dut.vreg_w1c.read(i,status,data);
  end

  `vmm_note(env.log,"***********Accessing register via BACKDOOR *************");
		for(i = 0; i<20; i++) begin
			data = $random;	
	  $display("Backdoor write to vreg_rw[%0d] %0h \n",i,data);
   env.ral_model.dut.vreg_rw.poke(i,status,data);
   env.ral_model.dut.vreg_rw.peek(i,status,data);
	  $display("Backdoor read from vreg_rw[%0d] returns %0h \n",i,data);
  end
  `vmm_note(env.log,"***********BACKDOOR write and FRONTDOOR read *************");
		for(i = 0; i<3; i++) begin
			data = $random;	
	  $display("Backdoor write to vreg_ro[%0d] : %0h \n",i,data);
   env.ral_model.dut.vreg_ro.poke(i,status,data);
   env.ral_model.dut.vreg_ro.read(i,status,data);
	  $display("Frontdoor read from vreg_ro[%0d] returns %0h \n",i,data);
  end
  `vmm_note(env.log,"***********FRONTDOOR write and BACKDOOR read *************");
		for(i = 0; i<5; i++) begin
			data = $random;	
	  $display("Frontdoor write to vreg_w1c[%0d] : %0h \n",i,data);
   env.ral_model.dut.vreg_w1c.write(i,status,data);
   env.ral_model.dut.vreg_w1c.peek(i,status,data);
	  $display("Backdoor read from vreg_w1c[%0d] returns %0h \n",i,data);
  end

  `vmm_note(env.log,"***********Accessing fields in the register via BACKDOOR *************");
/* peek and poke of fields */		
		for(i = 0; i<5; i++) begin
			data = $random;	
	  $display("Backdoor write to field f1 : %0h \n",data[7:0]);
   env.ral_model.dut.vreg_w1c.f1.poke(i,status,data[7:0]);
   env.ral_model.dut.vreg_w1c.f1.peek(i,status,data);
	  $display("Backdoor read to field f1 returns %0h \n",data);
  end

  env.log.report();
end
endprogram



