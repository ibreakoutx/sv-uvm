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
   vmm_rw::status_e status;

   env.cfg_dut();

   env.ral_model.default_access = vmm_ral::BFM;

   //read counter 20
   env.ral_model.COUNTERS[20].read(status, reg_value);
   `vmm_note(log, $psprintf("COUNTER[20] reset value %0h", reg_value));

   if (reg_value != 32'hdead_dead) begin
      `vmm_fatal(log, "Expected Reset value: 32'hdeaddead!\n");
   end

   env.run();
end
endprogram
