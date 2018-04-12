`ifndef _VIRTUAL_SEQUENCER_
`define _VIRTUAL_SEQUENCER_

class virtual_sequencer extends uvm_sequencer ;
  
	data_sequencer seqr1_handle;
  	data_sequencer seqr2_handle;
  
  `uvm_component_utils(virtual_sequencer)
  
  function new(string name = "virtual_sequencer", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  
endclass

`endif

