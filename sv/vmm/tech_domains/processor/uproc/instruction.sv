/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`include "opcode.sv"

class instruction extends vmm_data;
  static vmm_log log = new ("instruction", "class");
  rand opcode 	op[2];

  // memory load and store can only appear in slot 0
  // eg.
  // do not allow cases like		ADD R0, R1, R2 	;  SB R4, 0x0120 (R5)
  constraint slot0_only_good {				
    !(op[1].kind inside { opcode::LW, opcode::SB });
  }

  // operations on the same instruction must not write to the same
  // register
  // eg.
  // do not allow cases like		ADD R0, R1, R2	; SLL R0, R3, R1
  constraint writing_two_different_regs_valid { 	
    op[0].rd != op[1].rd;
  }

  // only op[0] can be a label,
  constraint deal_with_labels_valid {
    (op[0].kind == opcode::LABEL) -> (op[1].kind == opcode::LABEL);
    op[1].label_suffix == op[0].label_suffix;
    (op[0].kind != opcode::LABEL) -> (op[1].kind != opcode::LABEL);
  }
  
  function new();
    super.new (log);
    foreach (op[i]) op[i] = new;
  endfunction // new
   

   virtual function vmm_data copy(vmm_data to = null);
      
    instruction data;
    
    // New an instance is none is passed in
    if (to == null) begin
      data = new;
    end
    else begin
      // Copying to an existing instance. 
      if (!$cast(data, to)) begin
         `vmm_fatal(this.log, "Attempting to copy to a non instruction instance");
        return to;
      end
    end
      
    super.copy_data(data);
    $cast(data.op[0], this.op[0].copy());
    $cast(data.op[1], this.op[1].copy());

    data.op[0].stream_id = this.stream_id;
    data.op[0].scenario_id = this.scenario_id;
    data.op[0].data_id = this.data_id;
    
    data.op[1].stream_id = this.stream_id;
    data.op[1].scenario_id = this.scenario_id;
    data.op[1].data_id = this.data_id;    
    
    // Assign to output
    copy = data;       
   endfunction // vmm_data
   

   virtual function vmm_data allocate();
    instruction tr = new;
    allocate = tr;
   endfunction // vmm_data
   
  
  // Example:		SB R4, 0x0120 (R5)  ; ADD R0, R1, R2
   virtual function string psdisplay (string prefix = "");
      
    if (op[0].kind != opcode::LABEL) begin
       $sformat (psdisplay, "%10s %-50s;%-50s\n", prefix, op[0].psdisplay(), op[1].psdisplay());
    end
    else begin
       $sformat (psdisplay, "%10s %-50s;\n", prefix, op[0].psdisplay());
    end
   endfunction // string

endclass // instruction

`vmm_channel (instruction)
   
`vmm_scenario_gen (instruction, "Instruction")   
