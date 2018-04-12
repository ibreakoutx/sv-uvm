`ifndef _DATA_SEQUENCER_
`define _DATA_SEQUENCER_

class data_sequencer extends uvm_sequencer #(data_xaction) ;
  
  `uvm_component_utils(data_sequencer);
  
  function new (string name = "data_sequencer", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction
  
  function integer user_priority_arbitration( integer avail_sequences[$] ) ;
    integer max_index = 0;
    foreach (avail_sequences[i])
      begin
        integer index = avail_sequences[i];
        uvm_sequence_request req = arb_sequence_q[index];
        uvm_sequence_base seq = req.sequence_ptr ;
        int pri = req.item_priority ;
        
        if ( index > max_index ) max_index = index;
      end
    return max_index;
  endfunction
  
endclass

`endif

