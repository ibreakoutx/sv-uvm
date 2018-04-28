/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

class telegraph_bad_cells extends atm_cell_scenario;
   integer TELEGRAPH;
   
   constraint telegraph_scenario {
      length == 5;
      repeated == 0;

      foreach (items[i]) {
         if (i % 2) items[i].hec != 8'h00;
         else       items[i].hec == 8'h00;
         if (i > 1) items[i].vpi == items[i-2].vpi;
         if (i==1)  items[i].vpi != items[i-1].vpi;
      }
   }

   function new();
     super.new();
     this.TELEGRAPH = this.define_scenario("Telegraph bad cells", 5);
   endfunction
      
   function void pre_randomize();
      super.pre_randomize();
      foreach (items[i])
      begin
         items[i].constraint_mode(0);
      end
   endfunction
endclass

class procedural_cells extends atm_cell_scenario;
   integer PROCEDURAL;
   
   constraint default_scenario {
      length == 0;
      repeated == 0;
   }
   
   function new();
      super.new();
      this.PROCEDURAL = this.define_scenario("Procedural cells", 0);
   endfunction

   virtual task apply(atm_cell_channel channel, ref int unsigned n_insts);
     atm_cell cell = new;

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
      $write("-------------------------------------------\n");
   endtask
endclass

program automatic test_gen;
   atm_cell_scenario_gen gen = new("Singleton");
   my_atm_cell_scenario_gen_callbacks cb = new;

   telegraph_bad_cells s1 = new;
   procedural_cells    s2 = new;

   initial
   begin
     gen.scenario_set.push_back(s1);
     gen.scenario_set.push_back(s2);

     gen.prepend_callback(cb);

     // Drain the output channel
     fork
     begin
     atm_cell cell;
       while (1)
         gen.out_chan.get(cell);
     end 
     join_none   

     `vmm_note(gen.log, "Generating 10 scenarios...");
     gen.stop_after_n_scenarios = 10;
     gen.start_xactor();

     gen.notify.wait_for(atm_cell_scenario_gen::DONE);
     repeat(100);

     $write("===========================================\n");

     // Randomly pick scenarios from set now...
     `vmm_note(gen.log, "Generating sets in random order...");

     gen.select_scenario.round_robin.constraint_mode(0);
     gen.reset_xactor();
     gen.start_xactor();

     gen.notify.wait_for(atm_cell_scenario_gen::DONE);
     repeat(100);

     gen.log.report();
   end  
endprogram
