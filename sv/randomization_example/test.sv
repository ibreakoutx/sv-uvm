/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



program sv_prog();

class Packet;
   typedef enum { READ, WRITE} RW;
   rand reg [31:0] addr;
   rand reg [31:0] data;
   rand RW rw;
   constraint c0  {
      (rw == READ)  -> addr inside { [32'h0     : 32'h1000] };
      (rw == WRITE) -> addr inside { [32'h3000 : 32'h20000] };
      addr[1:0] == 2'b00;
   }
   task display();
      $write("addr=%h, data=%h \n", addr, data);
   endtask : display
endclass 


initial begin : prog_blk

   Packet p;
   p = new();
   repeat(10)
   begin
      p.randomize();
      p.display();
   end

   p.randomize() with {addr[15:8] == 8'hff;};
   p.display();

end : prog_blk


endprogram : sv_prog
