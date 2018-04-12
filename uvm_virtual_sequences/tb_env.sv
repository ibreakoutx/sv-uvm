`ifndef _TB_ENV_
`define _TB_ENV_

class tb_env extends uvm_env ;
  
  data_driver drv1 ;
  data_driver drv2 ;
  data_sequencer seqr1 ;
  data_sequencer seqr2 ;
  data_monitor  mon1 ;
  data_monitor  mon2 ;
  virtual_sequencer vseqr;
  coverage_collector  cov_collector ;
  
  `uvm_component_utils(tb_env)
  
  function new (string name = "tb_env", uvm_component parent);
    super.new(name,parent);
    `uvm_info(this.get_name(),"tb env new function", UVM_NONE)
  endfunction
  
  function void build_phase( uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(this.get_name(),"tb env build phase", UVM_NONE)
    
    drv1 = data_driver::type_id::create("drv1",this);
    drv2 = data_driver::type_id::create("drv2",this);
    seqr1 = data_sequencer::type_id::create("seqr1",this);
    seqr2 = data_sequencer::type_id::create("seqr2",this);
    mon1 = data_monitor::type_id::create("mon1",this);
    mon2 = data_monitor::type_id::create("mon2",this);
    vseqr = virtual_sequencer::type_id::create("vseqr",this);
    cov_collector = coverage_collector::type_id::create("cov_collector",this);
  endfunction
  
  function void connect_phase( uvm_phase phase );
    
    //Connect driver upto sequencer
    drv1.seq_item_port.connect(seqr1.seq_item_export);
    drv2.seq_item_port.connect(seqr2.seq_item_export);
    
    //Assign handles in virtual sequencer
    vseqr.seqr1_handle = seqr1 ;
    vseqr.seqr2_handle = seqr2 ;
    
    mon1.analysis_port.connect(cov_collector.analysis_export);
    
  endfunction

endclass

`endif

