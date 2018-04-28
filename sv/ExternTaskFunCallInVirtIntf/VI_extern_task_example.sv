/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



/* The  below example shows the usage of accessing tasks declared inside interfaces
as extern tasks and export tasks inside interface modports using Virtual interface and
virtual interface modports.
*/

interface intf;
    extern task  t1();
    modport mp(export task t2()); // exporting task through modport
endinterface

module top;
    intf i1();
    intf i2();

    M1 m1(i1);
    M2 m2(i1.mp);
    M3 m3(i2);
    M4 m4(i2.mp);
    p p1(i1,i2); //instantiating program 

    virtual intf vi ; // creating virtual interface handle
    virtual intf.mp vm; // creating virtual interface modport handle

    initial begin
        vi = i1;
        vi.t1();   // task i1.t1 in M1
        vi.t2();     // task.i1.t2 in M2
        #10;
        vi = i2;
        vi.t1();   // task i2.t1 in M3
        vi.t2();   // task i2.t2 in M4
        #10;
        vm = i2.mp; //initializing VI modport
        vm.t2();   // task i2.t2 in M4
    end
endmodule

module M1(intf i1); // passing interface as port
    task i1.t1;
      #1;
      $display($time,,"%m, calling from i1.t1");
    endtask
endmodule

module M2(intf.mp i1); // passing interface modport as port
    task i1.t2;
      #1;
      $display($time,,"%m, calling from i1.t2");
    endtask
endmodule

module M3(intf i2);
    task i2.t1;
       #1;
      $display($time,,"%m, calling from i2.t1");
    endtask
endmodule

module M4(intf.mp i2);
    task i2.t2;
      #1;
      $display($time,,"%m, calling from i2.t2");
    endtask
endmodule

// program testbench passing interface as ports
program p(intf i1, intf i2);
endprogram
