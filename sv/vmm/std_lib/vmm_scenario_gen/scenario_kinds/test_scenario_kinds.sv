/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class my_atm_cell_scenarios extends atm_cell_scenario; 
    int BAD_CELLS;
    int PROCEDURAL;

     constraint bad_cells_scenario {
      if (scenario_kind == BAD_CELLS)
      {
         length == 5;
         repeated == 0;

         foreach (items[i])
	 {
            if (i % 2)  items[i].hec != 8'h00;
            else        items[i].hec == 8'h00;
            if (i > 1)  items[i].vpi == this.items[i-2].vpi;
            if (i == 1) items[i].vpi != this.items[i-1].vpi;
         }
       }
     }

   constraint procedural_scenario_c {
      if (scenario_kind == PROCEDURAL)
      {
         length == 0;
         repeated == 0;
      }
   }

   constraint hec_valid {
      if (scenario_kind != this.BAD_CELLS)
      {
         foreach (items[i]) 
            items[i].hec == 8'h00;
      }     
   }

   function  new();
     super.new();
     this.BAD_CELLS  = define_scenario("Telegraph bad cells", 5);
     this.PROCEDURAL = define_scenario("Procedural cells", 0);
   endfunction

   function void pre_randomize();
      super.pre_randomize();
      foreach (items[i])
      begin 
         items[i].constraint_mode(0);
      end
   endfunction

   virtual task apply(atm_cell_channel channel, ref int unsigned n_insts);
     if(scenario_kind == this.PROCEDURAL)
     begin
       this.procedural_scenario(channel);
     end
     super.apply(channel, n_insts);
   endtask

   task procedural_scenario(atm_cell_channel channel);
     atm_cell cell = new();

     cell.randomize() with {
       gfc == 4'h0;
       vpi == 8'h00;
       vci == 16'h0000;
       pt  == 3'h0;
       clp == 1'b0;
     };

      repeat (3) 
      begin
         atm_cell c;
         $cast(c, cell.copy());
         channel.put(c);
      end

      cell.randomize() with {
         gfc == 4'hF;
         vpi == 8'hFF;
         vci == 16'hFFFF;
         pt  == 3'h7;
         clp == 1'b1;
      };

      channel.put(cell);
      
   endtask 
   
endclass

class my_atm_cell_scenario_gen_callbacks extends atm_cell_scenario_gen_callbacks;
    virtual task post_scenario_gen(atm_cell_scenario_gen gen,
                                   atm_cell_scenario     scenario,
				   ref bit               dropped);

      scenario.display();
      $write("-----------------------------------------------------------------\n");
    endtask
endclass

program automatic test_gen;
  atm_cell_scenario_gen gen = new("Singleton");
  my_atm_cell_scenario_gen_callbacks cb = new();
  my_atm_cell_scenarios ss = new();
    
  initial
  begin

    fork
    begin
    atm_cell cell;
      while(1)
        gen.out_chan.get(cell); 
    end
    join_none
    
    gen.scenario_set[0] = ss;
    gen.append_callback(cb);
    `vmm_note(gen.log, "10 Scenarios...");
    gen.stop_after_n_scenarios = 10;
    gen.start_xactor();

    gen.notify.wait_for(atm_cell_scenario_gen::DONE);
    repeat(100);

    gen.log.report();
  end
endprogram
