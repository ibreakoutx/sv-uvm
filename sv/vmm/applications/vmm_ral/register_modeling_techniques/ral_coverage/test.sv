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
 bit [`VMM_RAL_DATA_WIDTH-1:0] data_a [];

initial begin
  vmm_version v = new;
  vmm_ral_version ral_v = new;
  vmm_rw::status_e status;
  vmm_ral_mem_burst burst = new;
  logic [63:0] data;
  tb_env env = new;
 		
    v.display();
    ral_v.display();
    env.start();


   $display("\nDUT_BLK1 :: Frontdoor write : 8'h FF to DUMMY_REG ");

      env.ral_model.DUT_BLK1.DUMMY_REG.mirror(status,,,);
      env.ral_model.DUT_BLK1.DUMMY_REG.mirror(status,,,);


     env.ral_model.update(status);
     env.ral_model.DUT_BLK1.DUMMY_REG.update(status);

       env.ral_model.DUT_BLK2.STATUS_REG.read(status, data);
       $display("DUT_BLK2 :: Frontdoor read to STATUS_REG returns = %0h \n",data);
       env.ral_model.DUT_BLK2.STATUS_REG.read(status, data);
       $display("DUT_BLK1 :: Frontdoor read to DUMMY_REG returns = %0b \n",data);
       env.ral_model.DUT_BLK1.TEMP_REG.write(status, 8'hFF);
       $display("Executing from REGFILE block");


       env.ral_model.DUT_BLK1.DUMMY_REG.mirror(status,,,);
       $display("DUT_BLK1 :: Frontdoor read to DUMMY_REG returns = %0b \n",data);
       env.ral_model.DUT_BLK1.TEMP_REG.write(status, 8'hFF);
       env.ral_model.DUT_BLK2.TEMP_REG.write(status, 8'hFF);
       env.ral_model.DUT_BLK2.DUMMY_REG.write(status, 8'hFF);
       env.ral_model.DUT_BLK1.STATUS_REG.write(status, 8'hFF);
      			
       	env.ral_model.DUT_BLK1.DUMMY_REG.mirror(status, vmm_ral::VERB); 
   	$display("DUT_BLK2 :: Frontdoor write : 8'h 00 to STATUS_REG \n");
	    	env.ral_model.DUT_BLK2.STATUS_REG.write(status, 8'h00);
   	$display("DUT_BLK2 :: Frontdoor write : status : %s \n",status.name);
			env.ral_model.DUT_BLK2.STATUS_REG.read(status, data);
   	$display("DUT_BLK2 :: Frontdoor read to STATUS_REG returns = %0h \n",data);
        env.ral_model.DUT_BLK1.TEMP_REG.TMP1.write(status,4);	
        env.ral_model.DUT_BLK1.TEMP_REG.TMP1.read(status,data);
        env.ral_model.DUT_BLK1.TEMP_REG.TMP1.mirror(status,vmm_ral::VERB);
       

   // FIELD COVERAGE     
      	env.ral_model.DUT_BLK1.TEMP_REG.field_values.sample();
      	env.ral_model.DUT_BLK1.DUMMY_REG.field_values.sample();

    

        env.report();

end

endprogram
