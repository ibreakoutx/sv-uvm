/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`include "uniq_rand_num_list.sv"
`include "instruction.sv"

class common_instruction_scenario extends instruction_scenario ;

  uniq_rand_num_list op_branch_labels;

  constraint common_valid {
    foreach (items[i]) {
      (items[i].op[0].opcode_type == opcode::CONTROL) -> items[i].op[0].from == i;
      (items[i].op[1].opcode_type == opcode::CONTROL) -> items[i].op[1].from == i;

      items[i].op[0].to == items[i].op[0].label_suffix;
      items[i].op[1].to == items[i].op[1].label_suffix;
			
      (op_branch_labels.list.size() == 0) -> items[i].op[0].kind != opcode::LABEL;
  
      (op_branch_labels.list.size() == 0) ->
        (items[i].op[0].opcode_type != opcode::CONTROL &&
         items[i].op[1].opcode_type != opcode::CONTROL );
			
   (op_branch_labels.list.size() > 0) ->
      items[i].op[0].label_suffix inside op_branch_labels.list;

   if (i inside op_branch_labels.list) {
      (items[i].op[0].kind == opcode::LABEL && items[i].op[0].label_suffix == i);
   }

   if (!(i inside op_branch_labels.list)) {
      items[i].op[0].kind != opcode::LABEL;
   }									
    	
   (items[i].op[0].opcode_type == opcode::CONTROL) ->
      items[i].op[0].to inside op_branch_labels.list;
   (items[i].op[1].opcode_type == opcode::CONTROL) ->
      items[i].op[1].to inside op_branch_labels.list;
		
   								

			
			
    }
  }

  // do not allow cases like:
  //				BNE R1, R2, LABEL_000005  	;    ADD R1, R1, 0x5
  //				NOP				;    BNE R3, R4,  LABEL_000015
  constraint no_back2back_control_valid {
    foreach (items[i]) {
      if (i > 0)  {
        if ((items[i].op[0].opcode_type == opcode::CONTROL) ||
            (items[i].op[1].opcode_type == opcode::CONTROL)) {
          items[i-1].op[0].opcode_type != opcode::CONTROL;
          items[i-1].op[1].opcode_type != opcode::CONTROL;
        }
      }
    }
  }

  // Example:
  //  		SRL	r3, r3, 2		;  <any operation making this an legal instruction>
  // 		SLL	r3, r3, 2		;  <any operation making this an legal instruction>
  // 		LW	r0, imm ( r3 )	;  <any legal opcode>

  constraint address_alignment_good {
    foreach (items[i]){
      if (i < 2) !(items[i].op[0].kind inside { opcode::LW });
    }

    foreach (items[k]) {
      foreach (items[i]) {
        if (k >= 2 && k == i &&
            items[i].op[0].kind inside {opcode::LW}) {

          items[k-2].op[0].kind		== opcode::SRL;
          items[k-2].op[0].rd 		== items[i].op[0].rs;
          items[k-2].op[0].rs 		== items[i].op[0].rs;
          items[k-2].op[0].imm	== 2;

          items[k-1].op[0].kind 		== opcode::SLL;
          items[k-1].op[0].rd 		== items[i].op[0].rs;
          items[k-1].op[0].rs 		== items[i].op[0].rs;
          items[k-1].op[0].imm 	== 2;
        }
      }
    }
  }

  constraint forward_BNE_s0 {
    foreach (items[i]) {
      if (i > 0) {
        foreach (items[j]) {
          if ((items[i].op[0].kind == opcode::BNE) &&   	  	// BNE in Line i
              (items[i].op[0].from < items[i].op[0].to) && 	// branch forward
              (j == i -1) ) {				// operation j in Line i-1
            items[j].op[0].kind 	== opcode::ADDI;	// operation j is ADDI
            items[j].op[0].rd 		== items[i].op[0].rs;	// operand 1 for operation j
            items[j].op[0].rs	 	== items[i].op[0].rt;	// operand 2 for operation j
            items[j].op[0].imm + 10'h2 inside {[10'h0:10'h4]};  	// imm == [-2 : 2]
          }
        }
      }
    }
  }


  constraint backward_BNE_s0 {
    foreach (items[i]) {
      foreach (items[j]) {
        if ((items[i].op[0].kind == opcode::BNE) &&   	// BNE in Line i
            (items[i].op[0].from > items[i].op[0].to)) {     	// branch backward
          if (j == items[i].op[0].to -1) {			// operation j before label
            items[j].op[0].kind == opcode::ADDI;		// operation j is ADDI
            items[j].op[0].rd == items[i].op[0].rs;		// operand 1 for operation j
            items[j].op[0].rs == items[i].op[0].rt;		// operand 2 for operation j
            items[j].op[0].imm + 10'h5 inside {[10'h0:10'h4]};  		// imm = [-5:-1]
          }
          if (j == items[i].op[0].from -1) {			// operation j before BNE
            items[j].op[0].kind == opcode::ADDI;		// operation j is ADDI
            items[j].op[0].rd == items[i].op[0].rs;		// operand 1 for operation j
            items[j].op[0].rs == items[i].op[0].rs;		// operand 2 for operation j
            items[j].op[0].imm == 1;  			// imm = 1
          }
          if ( (j > items[i].op[0].to -1) && (j < items[i].op[0].from -1)) {
            !(items[j].op[0].rd inside {items[i].op[0].rs, items[i].op[0].rt});
            !(items[j].op[1].rd inside {items[i].op[0].rs, items[i].op[0].rt});
          }
        }
      }
    }
  }


  // if backward branch (say BNE R1, R2 label),
  // make sure that the neighbouring slot does not modify R1, R2 either
  // except for the R1 = R1 + 1, done in NOTE_2
  // ie. to avoid cases like:
  //      bne r1, *r2*, label  ;  add *r2*, r0, r3
  //
  constraint  neighbour_slot_in_branch_op_valid {
    foreach (items[i]) {
      if ((items[i].op[0].opcode_type == opcode::CONTROL)) {
        !(items[i].op[1].rd inside {items[i].op[0].rs, items[i].op[0].rt});
      }
      if ((items[i].op[1].opcode_type == opcode::CONTROL)) {
        !(items[i].op[0].rd inside {items[i].op[1].rs, items[i].op[1].rt});
      }
    }
  }

  
  function new();
    super.new();
    op_branch_labels = new;
  endfunction // new

endclass // common_instruction_scenario

