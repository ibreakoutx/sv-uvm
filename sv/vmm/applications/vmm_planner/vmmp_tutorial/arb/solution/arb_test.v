/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

program arb_test( 
	input  clk,
	input  [1:0]  grant_p,
	output logic [1:0] request_p,
	output logic reset_p);

task reset_test; 
  $write("Task reset_test: asserting and checking reset\n"); 
  reset_p <= 1; 
  repeat (2) @(posedge clk); 
  reset_p <= 0; 
  request_p <= 2'b00;
  expect(@(negedge clk) grant_p == 2'b00) else $display($time, " Failed");
endtask 

task drive_test1;
  $write("Task drive_test1: driving request and checking grant for CPU0 \n"); 
  @(posedge clk) request_p <= 2'b01; 
  @(posedge clk);
  expect(@(negedge clk) grant_p == 2'b01); 
  @(posedge clk) request_p <= 2'b00;
  @(posedge clk);
  expect(@(negedge clk) grant_p == 2'b00); 
endtask 

task drive_test2;
  $write("Task drive_test1: driving request and checking grant for CPU1 \n"); 
  @(posedge clk) request_p <= 2'b10; 
  @(posedge clk);
  expect(@(negedge clk) grant_p == 2'b10); 
  @(posedge clk) request_p <= 2'b00;
  @(posedge clk);
  expect(@(negedge clk) grant_p == 2'b00); 
endtask 

task drive_test3;
  $write("Task drive_test3: driving request and checking grant for both CPU0 and CPU1 \n"); 
  @(posedge clk) request_p <= 2'b11;
  @(posedge clk);
  expect(@(negedge clk) grant_p == 2'b01); 
  @(posedge clk) request_p <= 2'b10; 
  @(posedge clk); 
  expect(@(negedge clk) ##[0:2] grant_p == 2'b10); 
  @(posedge clk) request_p <= 2'b00; 
  @(posedge clk);
  expect(@(negedge clk) grant_p == 2'b00); 
endtask 

initial begin
  reset_test();
  drive_test1();
  drive_test2();
  drive_test3();
  $finish;
end
endprogram
