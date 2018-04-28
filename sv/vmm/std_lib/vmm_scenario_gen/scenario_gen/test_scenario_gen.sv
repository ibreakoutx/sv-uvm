/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class my_atm_cell_scenario_gen_callbacks extends atm_cell_scenario_gen_callbacks;
    virtual task post_scenario_gen(atm_cell_scenario_gen gen,
                                   atm_cell_scenario     scenario,
				   ref bit               dropped);

      scenario.display();
      $write("---------------------------------------------------------\n");
    endtask
endclass

program automatic test_gen;
    atm_cell_scenario_gen gen = new("Singleton");
    my_atm_cell_scenario_gen_callbacks cb = new();
    
    
    //Drain the output channel
    initial
    begin
    fork
    begin
      atm_cell cell;
      while(1)
        gen.out_chan.get(cell);      	
    end
    join_none
    
    `vmm_note(gen.log, "Generating 10 scenarios...");
    gen.prepend_callback(cb);
    gen.stop_after_n_scenarios = 10;
    gen.start_xactor();

    gen.notify.wait_for(atm_cell_scenario_gen::DONE);
    repeat(100);
    $write("=========================================================\n");

    //Make sure it can be restarted...
    `vmm_note(gen.log, "Generating 3 scenarios...");
    gen.stop_after_n_scenarios = 3;
    gen.reset_xactor();
    gen.start_xactor();

    gen.notify.wait_for(atm_cell_scenario_gen::DONE);
    repeat(100);

    gen.log.report();
    end   
endprogram
