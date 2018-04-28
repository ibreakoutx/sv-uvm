/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


program run_01 ( );
`include "vmm.sv"
`include "my_data.sv"
`include "my_xactor.sv"
`include "my_env.sv"
`include "test_01.sv"

   my_env env = new;

initial
begin
   test_01 t = new;
   t.run(env);
end			

endprogram
