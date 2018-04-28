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
  bit [127:0] data;
  tb_env env = new;
		vmm_ral_reg regs[];
  env.start();

   
  `vmm_note(env.log, "Resetting the ENV ...");
		env.hw_reset();
		
  `vmm_note(env.log,"Following registers are available in the system :: \n");
  env.ral_model.display();
		env.ral_model.get_registers(regs,"");
		/* Check the reset value of these registers */
  `vmm_note(env.log,"Checking the reset values of all the registers available in the system :: \n");
		foreach(regs[i]) begin
				regs[i].mirror(status,vmm_ral::VERB);
  end
  
		`vmm_note(env.log, "**** Starting register write/reads from the testcase ***");
		$display("\n\n");
		`vmm_note(env.log, "**** Write to field a with value 4'ha ***");
  env.ral_model.DUT_BLK.TEMP_REG.a.write(status,4'ha);
		$display("\n\n");
		`vmm_note(env.log, "**** Write to field b with value 4'hb ***");
  env.ral_model.DUT_BLK.TEMP_REG.b.write(status,4'hb);
		$display("\n\n");
		`vmm_note(env.log, "**** Write to field c with value 4'hc ***");
  env.ral_model.DUT_BLK.TEMP_REG.c.write(status,4'hc);
		$display("\n\n");
		`vmm_note(env.log, "**** Write to field d with value 8'hd ***");
  env.ral_model.DUT_BLK.TEMP_REG.d.write(status,8'hdd);
		$display("\n\n");
		`vmm_note(env.log, "**** Write to field e with value 32'heeeeeeee ***");
  env.ral_model.DUT_BLK.TEMP_REG.e.write(status,32'heeeeeeee);
		$display("\n\n");
		`vmm_note(env.log, "**** Write to field f with value 24'hffffff ***");
  env.ral_model.DUT_BLK.TEMP_REG.f.write(status,24'hffffff);
		$display("\n\n");
		`vmm_note(env.log, "**** Write to field g with value 16'h1111 ***");
  env.ral_model.DUT_BLK.TEMP_REG.g.write(status,16'h1111);
		$display("\n\n");
		`vmm_note(env.log, "**** Write to field h with value 24'h111111 ***");
  env.ral_model.DUT_BLK.TEMP_REG.h.write(status,24'h111111);
		$display("\n\n");

  env.ral_model.DUT_BLK.TEMP_REG.a.read(status,data);
		`vmm_note(env.log, $psprintf("**** Read to field a returns value %0h :: write_value(a) ***\n\n",data));
  env.ral_model.DUT_BLK.TEMP_REG.b.read(status,data);
		`vmm_note(env.log, $psprintf("**** Read to field b returns value %0h :: write_value(b) ***\n\n",data));
  env.ral_model.DUT_BLK.TEMP_REG.c.read(status,data);
		`vmm_note(env.log, $psprintf("**** Read to field c returns value %0h :: write_value(c) ***\n\n",data));
  env.ral_model.DUT_BLK.TEMP_REG.d.read(status,data);
		`vmm_note(env.log, $psprintf("**** Read to field d returns value %0h :: write_value(dd) ***\n\n",data));
  env.ral_model.DUT_BLK.TEMP_REG.e.read(status,data);
		`vmm_note(env.log, $psprintf("**** Read to field e returns value %0h :: write_value(eeeeeeee) ***\n\n",data));
  env.ral_model.DUT_BLK.TEMP_REG.f.read(status,data);
		`vmm_note(env.log, $psprintf("**** Read to field f returns value %0h :: write_value(ffffff) ***\n\n",data));
  env.ral_model.DUT_BLK.TEMP_REG.g.read(status,data);
		`vmm_note(env.log, $psprintf("**** Read to field g returns value %0h :: write_value(1111) ***\n\n",data));
  env.ral_model.DUT_BLK.TEMP_REG.h.read(status,data);
		`vmm_note(env.log, $psprintf("**** Read to field h returns value %0h :: write_value(111111) ***\n\n",data));

  env.log.report();
end
endprogram
