/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

program test (arb_if.TEST arbif);

    int max_trans;
    
task reset_test();
  begin
   $display("Task reset_test: asserting and checking reset");
   arbif.reset <= 0;
   #100 arbif.reset <= 1;
   arbif.cb.request <= 0;
   repeat (2) @arbif.cb;
   arbif.reset <= 0;
   @arbif.cb;
   a0: assert (arbif.cb.grant == 2'b00);
  end
endtask


task request_grant_test();
  $monitor("@%0d: grant=%b", $time, arbif.cb.grant);
    
  // Test out bit 0
  $display("Task request_grant_test: asserting and checking reset");

  ##1 arbif.cb.request <= 2'b01;
  $display("@%0d: Drove req=01", $time);
  repeat (2) @arbif.cb;
  a1: assert (arbif.cb.grant == 2'b01);

  ##1 arbif.cb.request <= 2'b00;
  $display("@%0d: Drove req=00", $time);
  repeat (2) @arbif.cb;
  a2: assert (arbif.cb.grant == 2'b00);

  ##1 arbif.cb.request <= 2'b10;
  $display("@%0d: Drove req=10", $time);
  repeat (2) @arbif.cb;
  a3: assert (arbif.cb.grant == 2'b10);

  ##1 arbif.cb.request <= 2'b00;
  $display("@%0d: Drove req=00", $time);
  repeat (2) @arbif.cb;
  a4: assert (arbif.cb.grant == 2'b00);

  ##1 arbif.cb.request <= 2'b11;
  $display("@%0d: Drove req=11", $time);
  repeat (2) @arbif.cb;
  a5: assert (arbif.cb.grant == 2'b01);

  ##1 arbif.cb.request <= 2'b00;
  $display("@%0d: Drove req=00", $time);
  repeat (2) @arbif.cb;
  a6: assert (arbif.cb.grant == 2'b00);
endtask


initial begin

  repeat (10) @arbif.cb;

  reset_test();
  request_grant_test();

  repeat (10) @arbif.cb;
  $finish;

end
endprogram
