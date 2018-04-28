/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

program P;
`include "vmm.sv"
`include "apb_trans.sv"
`include "alu_data.sv"
 
 
//MS scenario which generates 5 ALU transactions

class gen1_scenario extends vmm_ms_scenario;
   alu_trans_channel alu_chan;
   int MY_SCN = define_scenario("MY_SCN", 0);

   `vmm_scenario_member_begin(gen1_scenario)
      `vmm_scenario_member_scalar(MY_SCN, DO_ALL)
   `vmm_scenario_member_end(gen1_scenario)

   virtual task execute(ref int n);
     if (alu_chan == null) $cast(alu_chan, this.get_channel("ALU_SCN_CHAN"));
     repeat (5) begin
        alu_trans tr = new();
        tr.randomize();
        alu_chan.put(tr);
        n += 5;
     end
   endtask
endclass
 
//MS scenario which generated 5 APB transactions
class gen2_scenario extends vmm_ms_scenario;
   apb_trans_channel apb_chan;
   int MY_SCN = define_scenario("MY_SCN", 0);

   `vmm_scenario_member_begin(gen2_scenario)
      `vmm_scenario_member_scalar(MY_SCN, DO_ALL)
   `vmm_scenario_member_end(gen2_scenario)


   virtual task execute(ref int n);
     if (apb_chan == null) $cast(apb_chan, this.get_channel("APB_SCN_CHAN"));
     repeat (5) begin
        apb_trans tr = new();
        tr.randomize();
        apb_chan.put(tr);
        n += 5;
     end
   endtask
endclass
 
 
//top MS scenario which excecutes scenarios of generators, GEN1 and GEN2
class top_scenario extends vmm_ms_scenario;
   int TOP_SCN = define_scenario("TOP_SCN", 0);

   `vmm_scenario_member_begin(top_scenario)
      `vmm_scenario_member_scalar(TOP_SCN, DO_ALL)
   `vmm_scenario_member_end(top_scenario)


   virtual task execute(ref int n);
     vmm_ms_scenario scn1;
     vmm_ms_scenario scn2;
 
     scn1 = get_ms_scenario("GEN1_SCN", "GEN1"); //Returns scenario with name
                                                 //"GEN1_SCN" from generator "GEN1"
     scn2 = get_ms_scenario("GEN2_SCN", "GEN2");//Returns scenario with name
                                                // "GEN2_SCN" from generator "GEN2"
    
     scn1.execute(n);
     scn2.execute(n);
   endtask
 
endclass
 
initial begin
   alu_trans_channel   alu_chan = new("ALU_CHAN", "Chan");
   apb_trans_channel   apb_chan = new("APB_CHAN", "Chan");
   vmm_ms_scenario_gen gen1     = new("GEN1");
   vmm_ms_scenario_gen gen2     = new("GEN2");
   vmm_ms_scenario_gen top_gen  = new("TOP_GEN");
   gen1_scenario       scn1     = new();
   gen2_scenario       scn2     = new();
   top_scenario        top_scn  = new();
 
   gen1.register_channel("ALU_SCN_CHAN", alu_chan); //Register ALU channel
                                                    //to generator "GEN1"
   gen1.register_ms_scenario("GEN1_SCN", scn1);     //Register gen1_scenario to
                                                    //generator "GEN1"
 
   gen2.register_channel("APB_SCN_CHAN", apb_chan); //Register APB channel to
                                                    //generator "GEN2"
   gen2.register_ms_scenario("GEN2_SCN", scn2);     //Register gen2_scenario to
                                                    //generator "GEN2"
 
   top_gen.register_ms_scenario("TOP_SCN", top_scn); //Register top scenario to top
                                                     // generator
   top_gen.stop_after_n_scenarios = 1;
 
   top_gen.register_ms_scenario_gen("GEN1", gen1);   //Register generator "GEN1" with
                                                     //top generator
   top_gen.register_ms_scenario_gen("GEN2", gen2);   //Register generator "GEN2" with
                                                     //top generator
 
   top_gen.start_xactor();
 
 
   fork
     repeat(10) begin
       alu_trans tr;
       alu_chan.get(tr);
       tr.display("ALU:");
     end
     repeat(10) begin
       apb_trans tr;
       apb_chan.get(tr);
       tr.display("APB:");
     end
   join
end
 
endprogram

