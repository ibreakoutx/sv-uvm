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
// some global defines
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

localparam int bitmax=31;
typedef logic [bitmax:0] data_type;

// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// the parallel interface, with read and write tasks
// data -->
// valid -->
// ready <--
// ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
interface parallel(input bit clk);
 `ifdef VCS  //Step1: include vmm.sv; 
`include "vmm.sv" 
  vmm_log mylog;
initial
 begin
   mylog=new("Interface","parallel"); //Step2: Create an object for vmm_log and new it. 
end
`endif

  logic [3:0] data;
  logic valid; 
  logic ready;

  modport rtl_receive(input data, valid, output ready),
          rtl_send   (output data, valid, input ready);

  task write(input data_type d);
    @(posedge clk) ;
    while (ready !== 1) @(posedge clk) ;
    data = d;
    $display("in write task, data is %0h", data);
    valid = 1;
    @(posedge clk) data = 'x;
    valid = 0;
  endtask

  task read(output data_type d);
    ready = 1;
    while (valid !== 1) @(negedge clk) ;
    ready = 0;
    d = data;
    @(negedge clk) ;
  endtask

property check_read(valid,ready);
@(negedge clk) valid |-> ##1 (ready==1'b0); 
endproperty
`ifdef VCS
CHECK_READ: assert property(check_read(valid,ready))  else `vmm_error(mylog,"protocol violated"); //Step3: use macro that uses mylog
`endif
endinterface


