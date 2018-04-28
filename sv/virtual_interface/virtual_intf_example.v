/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



// this is an example of using virtual interfaces
// an interface is created and then passed into the program block arg list
// the class 

interface ifc(input clk);
  bit a; 
  bit b;

 clocking ifc_clk @(posedge clk);
    default input #1 output #1;
   input a_p = a;
   output b_p = b;
 endclocking

 always @(posedge clk)
   begin 
     a = ~a ;
  end
endinterface


module top ; 
    reg clk = 0 ; 

     always 
         #5 clk = ~clk ; 

     ifc u_ifc (clk) ; 

    test u_test(u_ifc) ; 
endmodule 

program test(ifc in_ifc);


  class DriverClass;
  	virtual ifc virt_ifc;

       	function new(virtual ifc in_ifc);
    		this.virt_ifc = in_ifc;
       	endfunction

	task display ; 
	   if (virt_ifc.ifc_clk.a_p == 1) 
	      $display ($time, "virt_ifc.a = %b",  virt_ifc.ifc_clk.a_p) ; 
	   else 
	    if (virt_ifc.ifc_clk.a_p == 0) 
	       $display ($time, "virt_ifc.a = %b",  virt_ifc.ifc_clk.a_p) ; 
	 endtask

  endclass 


 DriverClass BFM ; 
 
  initial  begin 
 
    	BFM = new(in_ifc) ; 
     	for (int i ; i < 10 ; i++) 
          begin
             @(in_ifc.ifc_clk) ;
             BFM.display() ;  
           end
   end
endprogram


