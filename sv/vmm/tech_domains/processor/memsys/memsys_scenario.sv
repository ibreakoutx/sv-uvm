/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


class memsys_scenario extends vmm_ms_scenario;

   cpu_scenario      cpu0_scn;
   cpu_scenario      cpu1_scn;
			semaphore         sem;

   int MSCN = define_scenario("MSCN", 0);

			function new();
			   super.new(null);
						cpu0_scn = new;
						cpu1_scn = new;
						sem = new(1);
			endfunction

   virtual task execute(ref int n);
		   cpu_trans_channel cpu0_chan;
		   cpu_trans_channel cpu1_chan;
					int unsigned insts = n;
					$cast(cpu0_chan,  get_channel("cpu0_chan"));
					$cast(cpu1_chan,  get_channel("cpu1_chan"));
					fork 
					  begin
					    sem.get();
									void'(cpu0_scn.randomize());
					   	cpu0_scn.apply(cpu0_chan, insts);
					    sem.put();
							end
					  begin
					    sem.get();
									void'(cpu1_scn.randomize());
					   	cpu1_scn.apply(cpu1_chan, insts);
					    sem.put();
							end
					join
					n = insts;
			endtask

endclass

