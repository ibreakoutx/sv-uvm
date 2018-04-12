`ifndef _COVERAGE_COLLECTOR_
`define _COVERAGE_COLLECTOR_

class coverage_collector extends uvm_subscriber #(data_xaction) ; 
  
  byte data ;

  covergroup cg ;
    d1: coverpoint data {
      bins low[] = { ['h00:'h09] };
      bins special[] = { 'haa,'h55 };  
    }
  endgroup  
  
  `uvm_component_utils(coverage_collector)
  
  function new(string name = "coverage_collector", uvm_component parent);
    super.new(name,parent);
    cg  = new;
  endfunction
  
  
  function void write( input data_xaction trans) ;
    `uvm_info(this.get_type_name(),trans.sprint(),UVM_NONE)
    data = trans.data;
    cg.sample();
  endfunction
  
  
endclass
    
 `endif
    


