/*
Function:
 Running XOR of a stream of bytes.
 Number of bytes indicated by first byte (not included in XOR).
 Eg:
 Bytestream: 0x04,0x16,0x5,0x8,0xFF,    0x3,0x44,0x76,0x65
              ^     <----------->       <-- Next set of 3 bytes->
              |           |     |
             Number  XOR these  |
             bytes   4 bytes    |
                                |-> Push to output fifo                  
*/

module xorexec_sva #(parameter int dwidth=8)
   ( input clk, rst,

     //ififo interface
     input ififo_pop,
     input ififo_rdy,
     input [dwidth-1:0] idata,

     //ofifo interface
     input ofifo_not_full,
     input ofifo_push,
     input [dwidth-1:0] odata,

     input [2:0] fsm_cs 
     );

default clocking cb @(posedge clk);  endclocking

//If ififo_pop is active, ififo_rdy should be true
//as_ififo_data: assume property ( idata >= 8'h4 );
//as_ififo_pop: assume property ( disable iff(rst) ififo_pop |-> ififo_rdy  );

logic [3:0] fsm_cs_cnt ;
   
always @(posedge clk)
  if (rst)
    fsm_cs_cnt <= 0;
  else
    if ( fsm_cs == 4 )
      fsm_cs_cnt <= fsm_cs_cnt + 1;
    else
      fsm_cs_cnt <=0;
    
//cp_push: cover property ( disable iff(rst) ofifo_push |-> (fsm_cs_cnt == 4) );

cp_push: cover property ( disable iff(rst) ofifo_push );      
   
endmodule // xorexec

bind xorexec xorexec_sva sva_inst( .* );
