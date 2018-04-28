/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



// Below example shows the usemodel for unpacked fixed size array inside clocking blocks

interface arb_if(input bit clk);
  logic [1:0] grant;
  logic request[4];  // unpacked fixed size array
  logic reset;

    clocking cb @(posedge clk); // Declare cb
      output request; // declared as an output port 
      input grant;
    endclocking

  modport TEST (clocking cb, output reset); // using clokcing in modports
  modport mp (input request, reset, output grant);
endinterface

program p(arb_if in1);

    initial begin
	#10 in1.request = '{1'b0,1'bz,1'b1,1'bx};
	#14 in1.request = '{1'b1,1'bx,1'bz,1'b0};
	#10;   
    end
endprogram

module top;
 bit clk =0;

// instantiating interface and program 
  arb_if i1(clk);
  p p1(i1);

 always #5 clk = ~clk;
   
 virtual arb_if vi = i1;

   always@(vi.TEST.cb) begin
     $display($time,,"vi.request[0] = %b, vi.mp.request[1] = %b, vi.mp.request[2] = %b, vi.request[3] = %b",  
		      vi.request[0],vi.mp.request[1],vi.mp.request[2],vi.request[3]);
   end
    
endmodule
