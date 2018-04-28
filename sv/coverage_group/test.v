/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


////////////////////////////////////////////////////////////////////////////////////////////////////// 
//// This example demonstrates Embedded Coverage Group inside Class Coverage  Model for Input-Ouput 
//// Ports of 4x4 Cross Switch. 
//// It ensures that Packets have been sent from all Input Ports to Output Ports.
////                                                                                              
////                                                                                              
////
////                                                                                              
////////////////////////////////////////////////////////////////////////////////////////////////////// 

program test ();
reg clk;
integer success;
 
// Embedded Coverage Group in a Class

  class cross_switch;
    rand bit [3:0] iport_no;
    rand bit [3:0] oport_no;

      covergroup inout_ports @(posedge clk);

        // Set Coverage Goal for this Coverage Group to 100%
        type_option.goal = 100;
	// Auto Bin Cover Points to create one bin for each Input Port and each Output Port 
        coverpoint iport_no;
        coverpoint oport_no; 

        // Cross of Input Port Versus Output Port Coverpoints to know if Packets have been sent from all-
        // Input Ports to all Output Ports 	
        all_in_out_ports: cross iport_no, oport_no; 

      endgroup

// Instantiate a Coverage Group everytime this Class is instantiated
  function new();
    inout_ports = new;
  endfunction : new

   function void post_randomize();
         $display ("Sending Packet: Input Port #%0d ---> Output Port #%0d\n", this.iport_no, this.oport_no);
   endfunction : post_randomize
  endclass



// Clock Generator
initial 
begin
clk = 0;
forever  #5  clk  = ~clk ;
end

initial 
begin

// Class instantiation
cross_switch switch_01;
switch_01 = new();

// Keep on randomizing the Object until 100% Coverage is reached using get_coverage () Function which returns
// Coverage number of the whole Coverage Group

  while ( switch_01.inout_ports.get_coverage() < 100)
    begin
       @(posedge clk); 
       success = switch_01.randomize();  	
       if (success == 0)	
           $display ("ERROR: Randomization Failed!\n");
       $display ("Coverage = %0d \n", switch_01.inout_ports.get_coverage());
    end // while( ...

    // Stop Coverage Collection since Coverage Goal is achieved
    switch_01.inout_ports.stop();
    // Finish the Simulation since Coverage Goal is achieved
    $finish();

end // initial begin

endprogram
