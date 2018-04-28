/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



`include "ral_mysys.sv"

`include "dpi_tasks_sv.h"

ral_sys_mysys ral = new();

class dut_r4_reg extends vmm_ral_reg_frontdoor;
   bit [31:0] value;

   function void reset();
      value   = '0;
   endfunction

   virtual task write(output vmm_rw::status_e              status,
                      input  bit [`VMM_RAL_DATA_WIDTH-1:0] data,
                      input  int                           data_id = -1,
                      input  int                           scenario_id = -1,
                      input  int                           stream_id = -1);
      status = vmm_rw::IS_OK;
      this.value = data;
   endtask: write

   virtual task read(output vmm_rw::status_e              status,
                     output bit [`VMM_RAL_DATA_WIDTH-1:0] data,
                     input  int                           data_id = -1,
                     input  int                           scenario_id = -1,
                     input  int                           stream_id = -1);
      data = this.value;
      status = vmm_rw::IS_OK;
   endtask: read

endclass: dut_r4_reg


program test;

initial
begin
   vmm_ral_access acc = new;
   dut_r4_reg r4;

   r4  = new; ral.myblk[0].R1.set_frontdoor(r4);  r4.reset();
   r4  = new; ral.myblk[1].R1.set_frontdoor(r4);  r4.reset();

   acc.set_model(ral);

   cmain(ral.myblk[0].get_block_ID());
end
endprogram: test

