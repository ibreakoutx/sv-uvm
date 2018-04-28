/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

`include "common_instruction_scenario.sv"

class basic_instruction_scenario extends common_instruction_scenario;
  integer BASIC;
  bit back_branch = 1;
  
  constraint length_repeated_valid {
    if (scenario_kind == BASIC) {
      repeated == 0;
      length == 20;
    }
  }

  constraint no_sb {
    foreach (items[i]) {
      !(items[i].op[0].kind inside { opcode::SB });
    }
  }
    
  constraint few_nop {
    foreach (items[i]) {
      items[i].op[0].opcode_type dist { opcode::NO_OPERATION := 1, [opcode::LOAD_STORE:opcode::LABEL_NAME] := 9 };
      items[i].op[1].opcode_type dist { opcode::NO_OPERATION := 1, [opcode::LOAD_STORE:opcode::LABEL_NAME] := 9 };			
    }
  }
								
  constraint single_branch {
    foreach (items[i]) {
      if (back_branch == 0) {
        if (i == 2) {
          items[i].op[0].opcode_type == opcode::CONTROL;
          items[i].op[1].opcode_type != opcode::CONTROL;
        }
        if (i != 2) {
          items[i].op[0].opcode_type != opcode::CONTROL;
          items[i].op[1].opcode_type != opcode::CONTROL;
        }
      }
      if (back_branch == 1) {
        if (i == 18) {
          items[i].op[0].opcode_type == opcode::CONTROL;
          items[i].op[1].opcode_type != opcode::CONTROL;
        }
        if (i != 18) {
          items[i].op[0].opcode_type != opcode::CONTROL;
          items[i].op[1].opcode_type != opcode::CONTROL;
        }
      }
    }
  }
  

  function void pre_randomize();
    super.pre_randomize();
    back_branch = $random()%2;
     
`ifdef DEBUG
    $display ("back_branch = %0d\n", back_branch);
    $display ("op_branch_labels.list.size() = 'd%0d\n", op_branch_labels.list.size());
    op_branch_labels.display();
`endif
     
  endfunction // void
   
  
   function new();
    super.new();
    op_branch_labels = new (1, 4, 16);
    this.BASIC = define_scenario("BASIC", 20);
   endfunction // new
   
endclass // basic_instruction_scenario



program test;
   
   initial begin

      instruction_scenario_gen gen;
      basic_instruction_scenario scn_basic;
      
      gen = new ("instruction", 0);

      fork
	 while (1) begin
	    string prefix;
	    instruction t = new;
	    gen.out_chan.get(t);
	    $sformat (prefix, "[%2d.%2d.%2d] ",
		      t.stream_id, t.scenario_id, t.data_id);
	    $display ("%0s", t.psdisplay(prefix));
	 end
      join_none

      scn_basic = new;
      gen.scenario_set[0] = scn_basic;
      
      gen.stop_after_n_scenarios = 5;
      gen.start_xactor();
      
      gen.notify.wait_for (instruction_scenario_gen::DONE);
      gen.log.report();
   end // initial begin
   
endprogram // test
   
