`ifndef _DATA_DRIVER_
`define _DATA_DRIVER_

class data_driver extends uvm_driver #(data_xaction);
  
  data_xaction req ;
  
  virtual interface drive_interface intf;
   
  `uvm_component_utils(data_driver)
  
  function new (string name = "data_driver", uvm_component parent);
    super.new(name,parent);
    `uvm_info(this.get_name(),"data driver new function", UVM_NONE)
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(this.get_name(),"data driver build phase", UVM_NONE)

    if( !resource_db_drive_intf::read_by_name(this.get_name(),"intf",intf,null) )
      `uvm_fatal(this.get_name(),"Unable to read interface")
      
  endfunction
  
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
    `uvm_info(this.get_name(),"data driver connect phase", UVM_NONE)

    endfunction

  virtual task run_phase( uvm_phase phase);
    fork
      forever begin
      @(intf.cb);
      intf.valid <= 0;
      seq_item_port.get_next_item(req);
      @(intf.cb);
      intf.in <= req.data;
      intf.valid <= 1;
      seq_item_port.item_done();
      end
    join_none
  endtask
  
endclass

`endif

