/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`include "vmm.sv"

class opcode extends vmm_data;
   static vmm_log log = new ("opcode", "class");
   
   typedef enum {
      NOP, LW, SB, ADD, ADDI, SRL, SLL, XOR, BNE, LABEL 
   } kind_e;
   
   typedef enum {
      NO_OPERATION, LOAD_STORE, COMPUTE, CONTROL, LABEL_NAME
   } opcode_type_e;
   
   rand kind_e          kind;
   rand opcode_type_e   opcode_type;
   
   rand bit [5:0]       rs;
   rand bit [5:0]       rt;
   rand bit [5:0]       rd;
   rand bit [9:0]       imm;

   rand bit [9:0]       from;
   rand bit [9:0]       to;
   rand bit [9:0]       label_suffix;
   
   constraint only_48_registers_valid {
     rd inside {[0:47]};
     rs inside {[0:47]};
     rt inside {[0:47]};
   }
      
   constraint opcode_type_valid {
     (opcode_type == NO_OPERATION) -> kind inside { NOP };
     (opcode_type == LOAD_STORE)   -> kind inside { LW, SB };
     (opcode_type == COMPUTE)      -> kind inside { ADD, ADDI, SRL, SLL, XOR }; 
     (opcode_type == CONTROL)      -> kind inside { BNE };
     (opcode_type == LABEL_NAME)   -> kind inside { LABEL };
   }

   virtual function vmm_data copy(vmm_data to = null);
      opcode data;
      // New an instance is none is passed in
      if (to == null) begin
	 data = new;
      end
      else begin
	 // Copying to an existing instance. 
	 if ($cast(data, to)) begin
	    `vmm_fatal(this.log, "Attempting to copy to a non opcode instance");
	    return to;
	 end
      end // else: !if(to == null)
      super.copy_data(data);

      // Copy local data fields
      data.kind = this.kind;
      data.opcode_type = this.opcode_type;

      data.rd = this.rd;
      data.rt = this.rt;
      data.rs = this.rs;

      data.imm = this.imm;
      data.from = this.from;
      data.to = this.to;
      data.label_suffix = this.label_suffix;

      // assign to output
      copy = data;
   endfunction // vmm_data
   
   virtual function vmm_data allocate();
      opcode tr = new;
      allocate = tr;
   endfunction // vmm_data
   
   
   // Example:    LW   R0, 0x50 (R1)
   //      BNE  R1, R2, LABEL_000005
   virtual function string psdisplay (string prefix = "");
      string str;
      case (this.kind) 
	NOP    : $sformat (str, "%0s\tNOP                                ", prefix);
	LW     : $sformat (str, "%0s\tLW    R%0d, 0x%3x(R%0d)               ", prefix, rd, imm, rs);
	SB     : $sformat (str, "%0s\tSB    0x%3x(R%0d)                     ", prefix, imm, rs);
	ADD    : $sformat (str, "%0s\tADD   R%0d, R%0d, R%0d                ", prefix, rd, rs, rt);
	ADDI   : $sformat (str, "%0s\tADDI  R%0d, R%0d, 0x%3x               ", prefix, rd, rs, imm);
	SRL    : $sformat (str, "%0s\tSRL   R%0d, R%0d, 0x%3x               ", prefix, rd, rs, imm);           
	SLL    : $sformat (str, "%0s\tSLL   R%0d, R%0d, 0x%3x               ", prefix, rd, rs, imm);
	XOR    : $sformat (str, "%0s\tXOR   R%0d, R%0d, R%0d                ", prefix, rd, rs, rt);
	BNE    : $sformat (str, "%0s\tBNE   R%0d, R%0d, LABEL_scn%0d_%x     ", prefix, rs, rt, scenario_id, to);
	LABEL  : $sformat (str, "%0sLABEL_scn%0d_%x", prefix, scenario_id, label_suffix);
      endcase // case (this.kind)
      
`ifdef DEBUG  
      if (this.kind == BNE) begin
	 $sformat (str, "%0s (from=%0d,to=%0d,label_suffix=%0d)", str, from, to, label_suffix);
      end
`endif
      
      psdisplay = str;
      
   endfunction // string

   function new ();
      super.new(log);
   endfunction // new
   

endclass // opcode
