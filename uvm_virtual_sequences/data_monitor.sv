`ifndef _DATA_MONITOR_
`define _DATA_MONITOR_

class data_monitor extends uvm_monitor #(data_xaction) ;
  
  virtual interface sample_interface intf ;
    
  uvm_analysis_port #(data_xaction) analysis_port;
    
  `uvm_component_utils(data_monitor)
  
  function new(string name = "data_monitor", uvm_component parent);
    super.new(name,parent);
    `uvm_info(this.get_name(),"data monitor new function", UVM_NONE)
    resource_db_sample_intf::read_by_name(this.get_name(),"intf",intf,null);
    analysis_port = new ("analysis_port", this);
  endfunction
  
    virtual task run_phase( uvm_phase phase ) ;
  
  data_xaction trans ;
    
  forever
    begin
      @(intf.cb iff intf.valid);
      trans = data_xaction::type_id::create("mon_trans");
      trans.data = intf.out;
      analysis_port.write(trans);
    end
  
  endtask

  
endclass
    
 `endif
    

