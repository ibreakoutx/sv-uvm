//-----------------------------
//Shit through a goose
// out1 = in1 
// out2 = in2
// in1 and in2 are byte wide
// valid1 and valid2
// outvalid1, outvalid2
// event1 and event2 are internal
// signals that fire when 8'haa 
// and 8'h55 are detected on out1
// and out2 respectively
//-----------------------------
module goose ( input clk, reset, valid1,valid2,
               input [7:0] in1,in2,
               output logic [7:0] out1,out2,
               output logic outvalid1, outvalid2 ) ;
 
  
  wire event1, event2 ;
  
  always @(posedge clk)
    if (reset)
      begin
        out1 <= 0;
        out2 <= 0;
      end
  else
    begin
      outvalid1 <= 0;
      outvalid2 <= 0;
      if (valid1)
        begin
          out1 <= in1 ;
          outvalid1 <= valid1;
        end
      
      if (valid2)
        begin
          out2 <= in2 ;
          outvalid2 <= valid2;
        end
    end
  
  assign event1 = (outvalid1 === 1'b1 && out1 == 8'haa) ? 1'b1 : 1'b0;
  assign event2 = (outvalid2 === 1'b1 && out2 == 8'h55) ? 1'b1 : 1'b0;
  
  
endmodule

