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
`include "atm_cell.sv"
`include "atm_cover.sv"
program t( );
`vmm_atomic_gen(atm_cell, "ATM Cell")

   atm_cell_atomic_gen gen = new("Singleton");
   atm_cell cell;
   atm_cover cvr = new;
   
	initial 
	begin
   `vmm_note(gen.log, "Generating 25 cells...");
   gen.stop_after_n_insts = 25;
   gen.start_xactor();


   gen.notify.wait_for(atm_cell_atomic_gen::DONE);
   #100;

   // Make sure it can be restarted...
   `vmm_note(gen.log, "Generating 10 more cells...");
   gen.stop_after_n_insts = 10;
   gen.reset_xactor();
   gen.start_xactor();

   gen.notify.wait_for(atm_cell_atomic_gen::DONE);
   #100;

   gen.log.report();
			end

			initial
			begin
   fork
			begin
      while (1) 
								begin
								gen.out_chan.get(cell);
        cell.display();
        cvr.cover_task(cell);
								end	
				end				
   join_none

			end
endprogram
