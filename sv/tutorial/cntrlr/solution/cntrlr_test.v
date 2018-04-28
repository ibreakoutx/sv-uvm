/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

program cntrlr_test (cntrlr_intf intf); 

`include "device.v"

device0 d0 = new;
device1 d1 = new;
device2 d2 = new;
device3 d3 = new;
virtual cntrlr_intf vintf; 
initial begin
  vintf = intf; 
  @vintf.CBcntrlr;
  resetSequence();
  resetCheck();
  checkSimpleReadWrite();  
  checkAllAddresses(); 
  $finish;
end  


//reset sequence
task resetSequence ();  
  $write("Task resetSequence entered\n");
  vintf.CBcntrlr.reset <= 1'b1;
  vintf.CBcntrlr.ramData <= 8'bzzzzzzzz;
  repeat (2) @vintf.CBcntrlr;
  vintf.CBcntrlr.reset <= 1'b0;
endtask

//Check state of controller after reset
task resetCheck ();
  $write("Task resetCheck entered to check reset values\n");
  //all chip enables must be deasserted
  expect(@(vintf.CBcntrlr) ##[0:10] vintf.CBcntrlr.ce0_N === 1'b1);
   assert(vintf.CBcntrlr.ce1_N == 1'b1); 
   assert(vintf.CBcntrlr.ce2_N == 1'b1);
   assert(vintf.CBcntrlr.ce3_N == 1'b1);

endtask

// low level task to drive a read onto the bus
task readOp (bit [7:0] adx); 
  $write("Task readOp : address %0h\n", adx);
  vintf.CBcntrlr.busAddr <= adx;
  vintf.CBcntrlr.busRdWr_N <= 1'b1;
  vintf.CBcntrlr.adxStrb <= 1'b1;
  @vintf.CBcntrlr vintf.CBcntrlr.adxStrb <= 1'b0;
endtask 


//low level task to drive a write onto the bus
task writeOp (bit [7:0] adx, bit [7:0] data); 
  $write("Task writeOp : address %0h data %0h\n", adx, data);
  @vintf.CBcntrlr vintf.CBcntrlr.busAddr <= adx;
  vintf.CBcntrlr.busData <= data;
  vintf.CBcntrlr.adxStrb <= 1'b1;
  vintf.CBcntrlr.busRdWr_N <= 1'b0;
  @vintf.CBcntrlr vintf.CBcntrlr.adxStrb <= 1'b0;
  vintf.CBcntrlr.busRdWr_N <= 1'b1;
  vintf.CBcntrlr.busData <= 8'bzzzzzzzz;
endtask

//Checker to Verify sram write on a particular device meets the timing
task checkSramWrite ( device device_id, bit [5:0] adx, bit [7:0] data);
  expect (@(vintf.CBcntrlr) ##[1:5]device_id.getRamAddr() == adx);
  expect (@(vintf.CBcntrlr) ##[0:2] device_id.getRamData() == data);
   assert(device_id.getRdWr_N() == 1'b0); 
   assert(device_id.getCe_N() == 1'b0); 
   assert(device_id.getRamData() == data); 
   assert(device_id.getRamAddr() == adx); 
   @vintf.CBcntrlr assert(device_id.getRdWr_N() == 1'b1); 
   $write("Task checkSramWrite: Address %0h data %0h\n", 
   vintf.CBcntrlr.ramAddr, vintf.CBcntrlr.ramData);
   assert(device_id.getCe_N() == 1'b1); 
   assert(device_id.getRamData() == data); 
   assert(device_id.getRamAddr() == adx); 
endtask

//Checker to verify sram read from pins of the sram
task checkSramRead (  device device_id, bit [5:0] adx, bit [7:0] data);

  device_id.driveRamData(data); 
  device_id.waitCe_N();
  assert(device_id.getCe_N() == 0); 
  assert(device_id.getRdWr_N() == 1); 
  assert(device_id.getRamAddr() == adx); 
  $write("Task checkSramRead: Address %0h data %0h\n", adx, data);
  printCycle();
  expect (@(vintf.CBcntrlr) ##[0:2] device_id.getBusData() === data);
  printCycle();
  device_id.driveRamData (8'bzzzzzzzz);
endtask

// higher level tasks
task checkSimpleReadWrite (); 
  $write("Task checkSimpleReadWrite entered\n");
  writeOp (8'h01 + 0*64, 8'h5a);
  checkSramWrite (d0, 6'h1, 8'h5a);
  writeOp (8'h01 + 1*64, 8'h5a);
  checkSramWrite (d1, 6'h1, 8'h5a);
  writeOp (8'h01 + 2*64, 8'h5a);
  checkSramWrite (d2, 6'h1, 8'h5a);
  writeOp (8'h01 + 3*64, 8'h5a);
  checkSramWrite (d3, 6'h1, 8'h5a);
  readOp (8'h03 + 0*64);
  checkSramRead (d0, 6'h3, 8'h95);
  readOp (8'h03 + 1*64);
  checkSramRead (d1, 6'h3, 8'h95);
  readOp (8'h03 + 2*64);
  checkSramRead (d2, 6'h3, 8'h95);
  readOp (8'h03 + 3*64);
  checkSramRead (d3, 6'h3, 8'h95);
endtask

task checkAllAddresses ();
  device dev;
  bit [7:0] index;
  bit [7:0] data;

  $write("Task checkAllAddresses entered\n");
  for (int i = 0; i < 256; i++) begin
    $write("Expect6: Index %0d time %0d\n", i, $time);
    index = i;
    data = 8'h5a;
    writeOp (index, data);
    case (index[7:6])
     2'b00: dev = d0;
     2'b01: dev = d1;
     2'b10: dev = d2;
     2'b11: dev = d3;
    endcase
    checkSramWrite (dev, index[5:0], data);
    readOp(index);
    checkSramRead (dev, index[5:0], data);  
  end
endtask

task printCycle () ;
  $write("Cycle %0d Time %0d\n", $time/100+1, $time);
endtask

endprogram
