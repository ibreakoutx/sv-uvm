/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


//object of this base class can not be created directly
virtual class arb;
   extern virtual task driveRequest(input bit s); 
   extern virtual function logic getGrant(); 
endclass

class arb0 extends arb;
    task driveRequest(input bit s);
        vintf.CBmemsys.request[0] <= s;
    endtask

    function logic getGrant();
        return vintf.CBmemsys.grant[0];
    endfunction
endclass

class arb1 extends arb;
    task driveRequest(input bit s);
        vintf.CBmemsys.request[1] <= s;
    endtask
    function logic getGrant();
        return vintf.CBmemsys.grant[1];
    endfunction
endclass

// class header
class cpu ;

   //properties
   arb localarb;
   integer cpu_id;
   randc bit [7:0] address;
   randc bit [7:0] data;
   rand integer delay;

   constraint del_lt10
   {
       delay < 10;
       delay >= 0;
   }
 
   covergroup cpu_cov ;
       option.per_instance = 1;
       address:      coverpoint this.address;
       data:         coverpoint this.data;
       delay:        coverpoint this.delay {
                         bins delay0 = {0};
                         bins delay[] ={[1:9]} ;
                         option.at_least = 50;
                     }
   endgroup

// Method definitions
function new (integer id) ;
  $write("Constructing new CPU.\n"); 
  case (id)
    0: begin arb0 a = new; localarb = a; end
    1: begin arb1 a = new; localarb = a; end
    default : assert(0 && "unknown cpu id\n");
  endcase
  cpu_id = id;  
  cpu_cov = new;
  case (id)
    0: begin cpu_cov.set_inst_name("my_cpu0"); end
    1: begin cpu_cov.set_inst_name("my_cpu1"); end
    default : assert(0 && "unknown cpu id\n");
  endcase
    
endfunction

function void post_randomize();
    cpu_cov.sample(); 
endfunction

task readOp () ;
  $write("CPU %0d readOp: address %h data %h\n", cpu_id, address, data);
  @vintf.CBmemsys vintf.CBmemsys.busAddr <= address;
  vintf.CBmemsys.busRdWr_N <= 1'b1;
  vintf.CBmemsys.adxStrb <= 1'b1; 
  @vintf.CBmemsys vintf.CBmemsys.adxStrb <= 1'b0;
  expect (@(vintf.CBmemsys) ##[2:5] vintf.CBmemsys.busData == data);
  $write("READ address = 0%H, data = 0%H \n", address, data);
endtask

task writeOp() ;
  $write("CPU %0d writeOp: address %h data %h\n", cpu_id, address, data);
  @vintf.CBmemsys vintf.CBmemsys.busAddr <= address; 
  vintf.CBmemsys.busData <= data; 
  vintf.CBmemsys.busRdWr_N <= 1'b0; 
  vintf.CBmemsys.adxStrb <= 1'b1; 
  @vintf.CBmemsys vintf.CBmemsys.busRdWr_N <= 1'b1; 
  vintf.CBmemsys.busData <= 8'bzzzzzzzz; 
  vintf.CBmemsys.adxStrb <= 1'b0; 
  $write("CPU%0d is writing \n", cpu_id);
  $write("WRITE address = 0%H, data = 0%H \n", address, data); 
endtask

task request_bus ();
  $write("CPU%0d requests bus on cpu%0d\n", cpu_id, cpu_id);
  @vintf.CBmemsys localarb.driveRequest(1'b1); // request the bus 
  expect (@(vintf.CBmemsys) ##[2:20] localarb.getGrant() == 1'b1);
endtask

task release_bus ();
  $write("CPU%0d releases bus on cpu%0d\n", cpu_id, cpu_id);
   @vintf.CBmemsys localarb.driveRequest(1'b0); // request the bus
  expect (@(vintf.CBmemsys) ##[1:2] localarb.getGrant() == 1'b0);
endtask

task delay_cycle();
  $write("CPU%0d Delay cycle value: %d\n", cpu_id, delay);
  repeat(delay) @vintf.CBmemsys; 
  $write("delay = %d \n",delay);
endtask
endclass
