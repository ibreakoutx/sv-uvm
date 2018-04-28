
program test(dut_if.mst iport);

`include "tb_env.sv"

/**** TASK which directly accesses the physical interface of DUT ( NON-RAL) */
 task write(bit[7:0] addr, logic[7:0] data);
   @(iport.cb);
   @(iport.cb);
   iport.cb.addr <= addr;
   iport.cb.wdata <= data;
   iport.cb.direction <= tb_data :: WRITE;
   iport.cb.enable <= 1;
   @(iport.cb);
   @(iport.cb);
   iport.cb.enable <= 0;
   @(iport.cb);
 endtask
/**** TASK which directly accesses the physical interface of DUT ( NON-RAL) */

initial begin
  vmm_rw::status_e status;
  bit [7:0] rd_data,get_data;
  tb_env env = new;
  env.start();

   
  `vmm_note(env.log, "Resetting the ENV ...");
   env.hw_reset();
		
  `vmm_note(env.log,"Following registers are available in the system :: \n");
   env.ral_model.display();

  `vmm_note(env.log,"REG1 and REG3.CNT1 have auto_mirror capability ON ...\nChecking the updated values at regular intervals ..\n");

for(int i = 0; i<5; i++) begin
  $display("At time %t ...",$time);
  get_data = env.ral_model.DUT_BLK.reg1.get();
  $display(" **** REG1 Get returns %h **** \n",get_data);
  get_data = env.ral_model.DUT_BLK.reg3.get();
  $display(" **** REG3 Get returns %h **** \n",get_data);
#(150);
end		

 `vmm_note(env.log,"REG2 has auto_mirror capability OFF \nBut the register value is updated by passive update mechanism .. \n");
		
  $display("NON_RAL Write REG2 with value 'hab..\n");
  write('h01,'hab);
  get_data = env.ral_model.DUT_BLK.reg2.get();
  env.ral_model.DUT_BLK.reg2.read(status,rd_data);
  $display(" **** REG2 Get returns (%h) while Read returns (%h) **** \n",get_data,rd_data);
  if(rd_data != get_data)
   `vmm_error(env.log,"REG2 :: Passive update mechanism failed ..\n");

  $display("NON_RAL Write REG2 with value 'h12..\n");
  write('h01,'h12);
  get_data = env.ral_model.DUT_BLK.reg2.get();
  env.ral_model.DUT_BLK.reg2.read(status,rd_data);
  $display(" **** REG2 Get returns (%h) while Read returns (%h) **** \n",get_data,rd_data);
  if(rd_data != get_data)
   `vmm_error(env.log,"REG2 :: Passive update mechanism failed ..\n");


		
  $display("NON_RAL Write REG1 with value 'h85..\n");
  write('h00,'h85);
  get_data = env.ral_model.DUT_BLK.reg1.get();
  $display(" **** REG1 Get returns %h **** \n",get_data);
  if(get_data != 'h85)
    `vmm_error(env.log,"REG1 :: Passive update mechanism failed ..\n");

#150;
  $display("Value for REG1 is now updated via DIRECT UPDATE mechanism ....");
  get_data = env.ral_model.DUT_BLK.reg1.get();
  $display(" **** REG1 Get returns %h **** at time %t \n",get_data,$time);
#150;
  get_data = env.ral_model.DUT_BLK.reg1.get();
  $display(" **** REG1 Get returns %h **** at time %t \n",get_data,$time);
  env.log.report();	
end
endprogram
