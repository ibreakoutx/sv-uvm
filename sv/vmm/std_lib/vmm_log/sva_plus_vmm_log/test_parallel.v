/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// parallel test block, sends data to out and expects the
// same data to arrive on in
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

module test(parallel in, out);

data_type data_out, data_in;
`include "vmm.sv"

    vmm_log mylog;

initial
  begin
    mylog=new("testbench","test");
    repeat(10)
      begin
        data_out = $random();
	out.write(data_out);
      end
    in.ready =1'b1; //Introduced an error to check the assertion 
    @(negedge in.clk); //wait for a clock 
    data_out = $random();
    out.write(data_out);
    @(negedge in.clk);
 
    mylog.report();
    $finish(0);
  end

always
  begin
    in.read(data_in);
    
    `vmm_note(mylog,$psprintf("Received     %h", data_in));
  end

endmodule

