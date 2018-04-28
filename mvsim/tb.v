`timescale 1ns/1ns

module tb ;

`ifdef UPF_1_0
   import UPF::*;
`endif
   
   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg clk ;
   reg		[7:0]	idata;			// To dut of top_xorexec.v
   reg			ififo_push;		// To dut of top_xorexec.v
   reg			ofifo_pop;		// To dut of top_xorexec.v
   reg			rst;			// To dut of top_xorexec.v
   // End of automatics
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire			ififo_not_full;		// From dut of top_xorexec.v
   wire		[7:0]	odata;			// From dut of top_xorexec.v
   wire			ofifo_rdy;		// From dut of top_xorexec.v
   // End of automatics

   //clkgen
   initial clk=0;
   always #5 clk = ~clk ;

   reg 			pwr_on ;
   
   initial
     begin
	$vcdpluson;
	pwr_on = 1;
	
	rst = 1;
	ififo_push =0;
	ofifo_pop = 0;
	idata = 0;
	
	#100;
	rst = 0;
	#100;

	send_xaction;

	#10000;

	send_xaction;	

	#10000;
	
	$finish;
	
     end
   
   top_xorexec dut(/*AUTOINST*/
		   // Outputs
		   .pwr_on              (pwr_on),
		   .ififo_not_full	(ififo_not_full),
		   .ofifo_rdy		(ofifo_rdy),
		   .odata		(odata),
		   // Inputs
		   .clk                 (clk),
		   .rst			(rst),
		   .ififo_push		(ififo_push),
		   .idata		(idata),
		   .ofifo_pop		(ofifo_pop));


   always @(posedge clk)
     if ( !rst & ofifo_rdy )
       ofifo_pop <= 1;
     else
       ofifo_pop <= 0;

   integer 		num ;
   
   task send_xaction ;
      num = $random() % 8 ;
      
      @(posedge clk);
      ififo_push <= 0;
      
      if ( ififo_not_full )
	begin
	   idata <= num ;
	   ififo_push <= 1;
	end

      repeat(num)
	begin
	   @(posedge clk);
	   if ( ififo_not_full )
	     begin
		idata <= $random();
		ififo_push <= 1;
	     end
	end
      @(posedge clk);
      ififo_push <= 0;
      
   endtask // send_
   
endmodule // tb
