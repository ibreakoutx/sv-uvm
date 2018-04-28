//-------------------------------------------------
//-------------------------------------------------
  module top_xorexec #(parameter int dwidth=8)
   (
    //clk and rst (active high)
    input clk,rst,
    
    //ififo interface
    input ififo_push,
    output ififo_not_full,
    input [7:0] idata,

    input pwr_on ,
    
    //ofifo interface
    input ofifo_pop,
    output ofifo_rdy,
    output [7:0] odata
    
    );

   logic [7:0] exec_idata , exec_odata ;
   wire 	 pwr_down ,pwron_reset;
   
   hfifo #(.size(8), .dwidth(8)) ififo (
	       .clk			(clk),
	       .reset			(rst),
	       
	       //output interface to exec unit
	       .dout			(exec_idata[dwidth-1:0]),
	       .rdy			(exec_rdy),
	       .pop			(exec_pop),

               //input interface
	       .not_full		(ififo_not_full),
	       .din			(idata[dwidth-1:0]),
	       .push			(ififo_push)
	       );

   hfifo #(.size(8), .dwidth(8)) ofifo(
	       .clk			(clk),
	       .reset			(rst),
	       
	       // Outputs
	       .dout			(odata[dwidth-1:0]),
	       .rdy			(ofifo_rdy),
	       .pop			(ofifo_pop),
	       .not_full		(exec_not_full),
	       
	       // push interface from exec unit
	       .din			(exec_odata[dwidth-1:0]),
	       .push			(exec_push)
	       );

   xorexec exec_unit(
		     // Outputs
		     .ififo_pop		(exec_pop),
		     .ofifo_push	(exec_push),
		     .odata		(exec_odata),
		     // Inputs
		     .clk               (clk),
		     .rst		(rst | pwron_reset),
		     .ififo_rdy		(exec_rdy),
		     .idata		(exec_idata),
		     .ofifo_not_full	(exec_not_full),
		     .exec_idle         (exec_idle)
		     );

   pmu pmu_i (
	      // Outputs
	      .pwr_down			(pwr_down),
	      .iso_enable		(iso_enable),
	      .pwron_reset              (pwron_reset),

	      // Inputs
	      .clk                      (clk),
	      .rst			(rst),
	      .ififo_rdy		(exec_rdy),
	      .exec_idle		(exec_idle));
   
endmodule // top_xorexec
