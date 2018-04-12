`ifndef _INPUT_SEQ1_
`define _INPUT_SEQ1_

class input_seq1 extends uvm_sequence #(data_xaction) ;
  
  rand byte sdata;

  `uvm_object_utils_begin(input_seq1)
  `uvm_field_int(sdata,UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "input_seq1");
    super.new(name);
  endfunction
  
  virtual task body();
    
    repeat(5)
      begin
        this.randomize();
  	  	req = new("req");
        //req.rand_mode(0);
    	start_item(req);
        req.randomize() with { data == sdata; } ;
        `uvm_info(this.get_name(),$sformatf("req : %d",req.id),UVM_NONE)
    	finish_item(req);
      end
    
  endtask
  
endclass

class background_seq extends uvm_sequence #(data_xaction) ;

  `uvm_object_utils_begin(background_seq)
  `uvm_field_object(req,UVM_ALL_ON)
  `uvm_object_utils_end
  
  function new(string name = "background_seq");
    super.new(name);
  endfunction
  
  virtual task body();
    
  	  	req = new("req");
        req.distr.constraint_mode(0);
    	start_item(req);
    	req.randomize() with { data dist { 8'haa:=50, 8'h55:=50 }; };        	     
    	`uvm_info(this.get_name(),$sformatf("req : %d",req.id),UVM_NONE)

    	finish_item(req);
    
  endtask
  
endclass

class nested_seq extends uvm_sequence #(data_xaction);
  
  `uvm_object_utils(nested_seq)
  
  `uvm_declare_p_sequencer(data_sequencer)
  
  function new(string name = "nested_seq");
    super.new(name);
  endfunction
  
  task body();
    
    p_sequencer.set_arbitration( SEQ_ARB_USER );
    
    fork
      begin
        input_seq1 seq ;
        seq = input_seq1::type_id::create("seq1");
        
        if ( !seq.randomize() )
          `uvm_error(this.get_name(), "Failed to randomize")
          
          `uvm_info(this.get_name(),"Start seq1",UVM_NONE)
          
          seq.start(p_sequencer,this,11);
      end
    
          begin
        input_seq1 seq ;
            seq = input_seq1::type_id::create("seq2");
        
            if ( !seq.randomize()  )
          `uvm_error(this.get_name(), "Failed to randomize")
              seq.print();
          
            `uvm_info(this.get_name(),"Start seq2", UVM_NONE)

            seq.start(p_sequencer,this,2);
      end
    
          begin
        input_seq1 seq ;
            seq = input_seq1::type_id::create("seq3");
        
        if ( !seq.randomize() )
          `uvm_error(this.get_name(), "Failed to randomize")

          `uvm_info(this.get_name(),"Start seq3",UVM_NONE)

          seq.start(p_sequencer,this,3);
      end
    join
  endtask
 
endclass    

class data_seq_lib extends uvm_sequence_library #(data_xaction);
  `uvm_object_utils(data_seq_lib)
  
  `uvm_sequence_library_utils(data_seq_lib)
  
  function new (string name = "data_seq_lib");
    super.new(name);
    init_sequence_library();
  endfunction
  
endclass
    
`endif

