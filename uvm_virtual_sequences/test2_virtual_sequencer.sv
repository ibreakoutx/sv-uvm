`ifndef _TEST2_VIRTUAL_SEQUENCE_
`define _TEST2_VIRTUAL_SEQUENCE_

class test2_virtual_sequence extends uvm_sequence ;

  input_seq1 seq1 ;
  background_seq bseq ;
  
  `uvm_object_utils(test2_virtual_sequence)
  
  `uvm_declare_p_sequencer(virtual_sequencer)
  
  function new(string name = "test2_virtual_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    input_seq1 s1 ;
    input_seq1 s2 ;

    p_sequencer.seqr1_handle.set_arbitration( SEQ_ARB_STRICT_RANDOM );

     fork
      forever
        begin
          bseq = new("bseq");
          `uvm_info(this.get_name(),"Start bseq",UVM_NONE)
          bseq.start(p_sequencer.seqr1_handle,this,1);
        end
      join_none
    
    
    //this.lock(p_sequencer.seqr1_handle);
    s1 = new("s1");
    s1.start(p_sequencer.seqr1_handle,this,1);
    //this.unlock(p_sequencer.seqr1_handle);
      
    s2 = new("s2");
    s2.start(p_sequencer.seqr2_handle);
    
  endtask
  
endclass
`endif

