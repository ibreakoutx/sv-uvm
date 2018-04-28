/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



`include "vmm_ral.sv"
`include "ral_sys2.sv"
`include "ral_sys2a.sv"
`include "ral_sys2b.sv"

program test;

initial
begin
   vmm_rw_access r ;
   ral_sys_sys2 sys2;
   ral_sys_sys2a sys2a;
   ral_block_sys2b sys2b;
   vmm_ral_block_or_sys temp ;
   vmm_ral_access sys2_a,sys2a_a,sys2b_a;

   integer n ;
   r = new();
   sys2 = new();
   sys2a = new();
   sys2b = new();
		 
			$display("Getting the object name from the namespace 'RAL' .... \n");
   $display("sys2  name = %s\n",sys2.get_object_hiername(null, "RAL")); 
   $display("sys2a name = %s\n",sys2a.get_object_hiername(null, "RAL"));
   $display("sys2b name = %s\n",sys2b.get_object_hiername(null, "RAL"));
			
   sys2_a = new();
   sys2a_a = new();
   sys2b_a = new();
			
   sys2_a.set_model(sys2);
   sys2a_a.set_model(sys2a);
   sys2b_a.set_model(sys2b);
			
   $display("*** No. of tops in sys2 is %0d \n",sys2.get_n_tops());
			for(int i = 0;i<sys2.get_n_tops(); i++) begin
     temp = sys2.get_top(i); 
			  $display("Printing top %0d...\n",i);
     temp.display();
   end
			
end 
endprogram: test
