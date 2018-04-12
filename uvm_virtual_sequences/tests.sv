`ifndef _TEST1_
`define _TEST1_

class test1 extends uvm_test ;
  
  tb_env env ;
  input_seq1 seq1 ;
  virtual interface reset_interface intf;
  
  `uvm_component_utils(test1)
  
  function new (string name = "test1", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = tb_env::type_id::create("env", this);
    if( !resource_db_reset_intf::read_by_name("reset","intf",intf,null) )
      `uvm_fatal(this.get_name(),"Unable to read interface")
  endfunction
      
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    factory.print();
    this.print();
  endfunction
      
  task do_reset();
    intf.reset = 1 ;
    repeat(10) @(intf.cb);
    intf.reset = 0;
  endtask
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
	
    do_reset();
    
    seq1 = input_seq1::type_id::create("seq1",this);
    
    seq1.start(env.seqr1);
 
    #(100);
    phase.drop_objection(this);
  endtask
  
endclass
    
class test2 extends test1;

  test2_virtual_sequence vseq ;
  
  `uvm_component_utils(test2)
  
  function new (string name = "test2", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
	
    do_reset();
    
    vseq = test2_virtual_sequence::type_id::create("vseq",this);
    
    vseq.start(env.vseqr);
 
    #(100);
    phase.drop_objection(this);
  endtask  


endclass
    
class test3 extends test1;

   nested_seq seq ;
  
  `uvm_component_utils(test3)
  
  function new (string name = "test3", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
	
    do_reset();
    
    seq = nested_seq::type_id::create("seq");
    
    seq.start(env.seqr2);
    
    #(100);
    phase.drop_objection(this);
  endtask  


endclass
    
class test4 extends test1;
  	
   data_seq_lib seq_lib ;
  
  `uvm_component_utils(test4)
  
  function new (string name = "test4", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
	
    do_reset();
    
    seq_lib = data_seq_lib::type_id::create();

    seq_lib.add_sequence( input_seq1::get_type() );
    seq_lib.add_sequence( background_seq::get_type() );
    seq_lib.selection_mode = UVM_SEQ_LIB_RAND ;
    
    seq_lib.min_random_count =15;
    seq_lib.max_random_count = 20;
    
    seq_lib.randomize();
    

    seq_lib.start(env.seqr1);
    
    #(100);
    phase.drop_objection(this);
  endtask  


endclass
    
`endif

