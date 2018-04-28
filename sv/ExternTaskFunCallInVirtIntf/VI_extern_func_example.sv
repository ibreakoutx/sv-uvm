/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



/* The  below example shows the usage of accessing extern functions declared inside interfaces
as extern functions and export functions inside interface modports using Virtual interface and
virtual interface modports.
*/

interface intf;
    extern function void f1();
    modport mp(export function int f2(int i));
endinterface

module top;
intf i1();
intf i2();

M1 m1(i1);   // passing interface  
M2 m2(i1.mp); //passing interface modport
M3 m3(i2);    
M4 m4(i2.mp);
p p1(i1,i2); //instantiating program 

endmodule

module M1(intf i1); // passing interface as port
    function i1.f1;
      $display($time,,"%m, calling from i1.f1");
    endfunction
endmodule

module M2(intf.mp i1); // passing interface modport as port
    function int i1.f2(int i);
      $display($time,,"%m,calling from i1.f2 , i = %d", i);
      return(i);  
    endfunction
endmodule

module M3(intf i2);
    function i2.f1;
      $display($time,,"%m, calling from i2.f1");
    endfunction
endmodule

module M4(intf.mp i2);
    function int i2.f2(int i);
      $display($time,,"%m, calling from i2.f2, i = %d", i);
      return(i);  
    endfunction
endmodule

// program testbench
program p(intf i1, intf i2);

    virtual intf vi;
    virtual intf.mp vm;

    initial begin
	vi = i1;
	vi.f1();   // function i1.f1 in M1
	vi.f2(9);     // function.i1.f2 in M2
	#10;
	vi = i2;
	vi.f1();   // function i2.f1 in M3
	vi.f2(3);   // function i2.f2 in M4
        #10;
	vm = i2.mp; //initializing VI modport
	vm.f2(6);   // function i2.f2 in M4
    end
endprogram
