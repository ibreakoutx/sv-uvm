/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



class child;
	integer t= 10;
endclass



 class Packet;
   reg[4:0] x,y;
   int temp;
   child child_obj;


    function new;
	child_obj = new( );
   endfunction

  function int fact(int n); 
    if (n>1) 
	fact = n * fact(n-1);
    else 
	    fact = 1;
  endfunction


  task A ();
	for (int i;i<=1;i++)
	begin
	 	$display("\n From task Package::A at %0t ",$time);
 		@(posedge dsp_clk);
		temp =i;
		if (temp == 1  )
		$display("\n Task A terminated sucessfully" );
	 end
  endtask

   task B ();
	for (int i;i<=5;i++)
	begin
		$display("\n From task Packet::B at %0t ",$time );
		@(posedge dsp_clk);
    		temp =i;
	     if (temp == 5  )
		$display("\n Task B terminated sucessfully" );
	 end
  endtask


  task fork_join ( );
    fork 
	A( );
	B( );

  `ifdef JOIN_NONE
	join_none
  `else
  `ifdef JOIN_ANY
	join_any
  `else
	join
  `endif	
 `endif
    disable fork;	
  endtask
endclass

