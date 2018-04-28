/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



interface intf (input clk, input a, input b, input c, input d, input e ) ;

  clocking cb @(posedge clk) ;
  endclocking: cb

  sequence abc;
   @(posedge clk) a ##1 b ##1 c;
  endsequence

  sequence de;
   @(negedge clk) d ##[2:5] e;
  endsequence

  property p1 ;
    @(posedge clk) (a ##1 b)  ;
    
  endproperty

  A: assert property(@(cb) disable iff (abc.triggered) p1) ; // New in 0812

endinterface

module top ;
 parameter mydelay = 100 ;

 reg clk ;
 reg a, b, c, d, e ;

 initial   
   begin
     #10 ;
     a = 1'b1 ;
     #1 b = 1'b1 ;
     #1 c = 1'b1 ;
   end

 initial
  begin
   clk = 0 ;
   forever
    begin
    #(mydelay/2)
    clk = ~clk ;
  end
 end

 intf i (clk, a, b, c, d, e) ;
 check tb(clk, i) ;
endmodule: top


// Program block showing the usage of sequence.triggered
program check(input clk, intf i);

 initial 
   begin
    wait( i.abc.triggered || i.de.triggered );
     if( i.abc.triggered )
      $display( "abc succeeded" );
     if( i.de.triggered )
      $display( "de succeeded" );
     // @(clk) i.abc.triggered 
   end
 endprogram
