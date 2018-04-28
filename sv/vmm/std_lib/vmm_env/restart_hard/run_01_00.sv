/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


`include "vmm.sv"
`include "my_data.sv"
`include "my_xactor.sv"
`include "my_env.sv"
`include "test_00.sv"
`include "test_01.sv"


program run_01_00 ( );

   my_env env = new;
   string rs;

			initial
			begin
      test_01 t = new;
      test_00 t1 ;
   env.log.set_verbosity(vmm_log::TRACE_SEV,"/./","/./");
   
//   get_randstate(rs); $display("State = %b\n", rs);
   
			
      t.run(env);
   
   env.restart(1);
//   get_randstate(rs); $display("State = %b\n", rs);
   
			
      t1= new;
      t1.run(env);
   env.report();
  end
endprogram
