/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


//  here is an example of using expects inside the the testbench

 // here is a module with some logic toggling

module test;
	logic log1,log2,clk;

  initial begin
	log1=0;
	log2=0;
	clk=0;
	#33 log1=1;
	#27 log2=1;
	#120 $finish;
   end

   always #5 clk=~clk;

	// instantiate the testbench inside the module
  tbpb tbpb1(log1, log2, clk);
endmodule




	// there is the testbench

program tbpb (input in1, input in2, input clk);

	bit bit1;
	
   initial begin
     e1: expect (@(posedge clk) ##1 in1 && in2) 
	   begin 
		bit1=1; 
		$display("success at %0t in %m\n",$time); 
	   end 
	else 
	   begin 
		bit1=0; 
		$display("failure at %0t in %m\n",$time); 
	   end



    e2: expect (@(posedge clk) ##[1:9] in1 && in2) 
	  begin 
		bit1=1; 
		$display("success at %0t in %m\n",$time); 
	  end 
	else 
	  begin 
		bit1=0; 
		$display("failure at %0t in %m\n",$time); 
	  end


    e3: expect (@(posedge clk) ##1 in1 && in2 [*5]) 
	  begin 
		bit1=1; 
		$display("success at %0t in %m\n",$time); 
	  end 
	else 
	  begin 
		bit1=0; 
		$display("failure at %0t in %m\n",$time); 

	  end 


end

endprogram
