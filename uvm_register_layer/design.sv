`include "uvm_macros.svh"

interface dut_if;

  // Simple synchronous bus interface
  logic clock, reset;
  logic en;
  logic cmd;
  logic [7:0] addr;
  logic [7:0] wdata;
  logic [7:0] rdata;

endinterface


module dut(dut_if dif);

  import uvm_pkg::*;

  // Two memory-mapped registers at addresses 0 and 1
  logic [7:0] r0;
  logic [7:0] r1;
  
  always @(posedge dif.clock)
  begin
 
    if (dif.en)
    begin
      logic [7:0] value;
      
      if (dif.cmd == 1 )
        if (dif.addr == 0)
          r0 <= dif.wdata;
        else if (dif.addr == 1)
          r1 <= dif.wdata;
        
      if (dif.cmd == 0)
        if (dif.addr == 0)
          value = r0;
        else if (dif.addr == 1)
          value = r1;
        else
          value = $random;

      if (dif.cmd == 1)
        `uvm_info("", $sformatf("DUT received cmd=%b, addr=%d, wdata=%d",
                            dif.cmd, dif.addr, dif.wdata), UVM_MEDIUM)
      else
        `uvm_info("", $sformatf("DUT received cmd=%b, addr=%d, rdata=%d",
                            dif.cmd, dif.addr, value), UVM_MEDIUM)
      dif.rdata <= value;
    end
  end
  
endmodule

