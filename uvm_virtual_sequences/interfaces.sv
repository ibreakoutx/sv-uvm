interface drive_interface (input clk,
                           output [7:0] in,
                           output valid
                          ) ;
  default clocking cb @(posedge clk);
  endclocking

endinterface

interface sample_interface (input clk,
                            input [7:0] out,
                            input valid
                          ) ;
  
  default clocking cb @(posedge clk);
  endclocking
  
endinterface

interface reset_interface (input clk);
  logic reset ;
  
  default clocking cb @(posedge clk);
  endclocking
  
endinterface

