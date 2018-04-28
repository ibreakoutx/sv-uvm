
interface dut_if(input bit clk);

 logic [7:0] wdata;
 logic [7:0] rdata;
 logic [7:0] addr;
 logic direction;
 logic enable;
  
 clocking cb @(posedge clk);
   output wdata;
   output addr;
   output direction;
   output enable;
   input  rdata;
 endclocking
	
 clocking mon_cb @(posedge clk);
   input wdata;
   input addr;
   input direction;
   input enable;
   input rdata;
 endclocking

 modport mst(clocking cb); 
	modport mon(clocking mon_cb);

endinterface

