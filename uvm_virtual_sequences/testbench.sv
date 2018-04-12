// Code your testbench here
// or browse Examples
`include "interfaces.sv"
`include "tb_pkg.sv"

module tb ;
  
  import uvm_pkg::*;
  import tb_pkg::*;

  logic clk ;
  logic reset ;
  logic [7:0] in1,in2,out1,out2;
  logic valid1,valid2,outvalid1,outvalid2;
  
  initial clk = 0;
  always #5 clk = ~clk ;

  //Instantiate interfaces here
  drive_interface  drive_in1_intf(clk,in1,valid1);
  drive_interface  drive_in2_intf(clk,in2,valid2);
  reset_interface  reset_intf(clk);

  sample_interface sample_out1_intf(clk,out1,outvalid1);
  sample_interface sample_out2_intf(clk,out2,outvalid2);
  
  //Connect
  goose dut(.*, .reset(reset_intf.reset) );

  //Store config db interface handles
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars;
      resource_db_drive_intf::set("drv1","intf",drive_in1_intf,null);
      resource_db_drive_intf::set("drv2","intf",drive_in2_intf,null);
      resource_db_sample_intf::set("mon1","intf",sample_out1_intf,null);
      resource_db_sample_intf::set("mon2","intf",sample_out2_intf,null);
      resource_db_reset_intf::set("reset","intf",reset_intf,null);
      run_test("test1");
    end

endmodule
