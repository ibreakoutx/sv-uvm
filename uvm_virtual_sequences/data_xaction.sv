`ifndef _DATA_XACTION_
`define _DATA_XACTION_

class data_xaction extends uvm_sequence_item ;

  static int id ;
  rand byte data ;
  
  `uvm_object_utils_begin(data_xaction)
   `uvm_field_int(id, UVM_ALL_ON)
   `uvm_field_int(data, UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "data_xaction");
    super.new(name);
    id++;
  endfunction
    
  //data cannot be 0
  constraint legal { data != 8'b00; };
  
  //weight distribution, 20% of the time it is 0x55 and 0xaa
  constraint distr { data dist { 8'h55:=0 , 8'haa:=0, [8'h01:8'h54]:=20, [8'h56:8'ha9]:=20,
                                [8'hab:8'hff]:=20 }; }
  
endclass

`endif


