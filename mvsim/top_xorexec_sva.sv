  module top_xorexec_sva #(parameter int dwidth=8)
   (
    //clk and rst (active high)
    input clk,rst,
    
    //ififo interface
    input ififo_push,
    input ififo_not_full,
    input [7:0] idata,
    
    //ofifo interface
    input ofifo_pop,
    input ofifo_rdy,
    input [7:0] odata
    );


default clocking cb @(posedge clk);  endclocking

//If ififo_pop is active, ififo_rdy should be true
as_ififo_data: assume property ( idata >= 8'h4 );
as_ififo_push: assume property ( disable iff(rst) ififo_push |-> ififo_not_full  );
as_ififo_push_stutter: assume property ( disable iff(rst) ififo_push |-> ~$past(ififo_push) );   
as_ofifo_pop: assume property ( disable iff(rst) ofifo_pop |-> ofifo_rdy  );   

cp_rdy: cover property ( disable iff(rst) ofifo_rdy );
   
endmodule // top_xorexec

bind top_xorexec  top_xorexec_sva sva_inst (.*);

