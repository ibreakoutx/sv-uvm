/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



// Example for unpacked array members in struct usage in clocking blocks.

`timescale 1ns/1ns
typedef struct {
     bit s[2:1];
} my_struct;

 program tb(input my_struct my_str,
                input wire b,
                input wire kk );
 logic foo;
 logic [1:0] abc [1:0];

//clocking block using  unpacked struct as input.

 default clocking cb @(posedge kk);
   default input #0;
   default output #2;
   input             kk;
   input             b ;
   input             my_str;  // unpacked struct
endclocking

initial begin

   foo = 0;
   forever
     #5 foo = ~foo;
 end

initial begin
$monitor("%t kk , b , my_str %b,%b,{%b,%b}",$time, cb.kk,cb.b,cb.my_str.s[2],cb.my_str.s[1]);
#100 $finish;
end

 endprogram

module top;
 logic b;
  logic kk;

my_struct myst;
tb ptb(myst,b,kk);

   initial begin
     forever
    #5 kk = ~kk;
   end

   initial begin
     #30 b <= 1'b1;
         myst = '{'{1,0}};
     #30 b <= 1'bx;
         myst = '{'{1,1}};
      $monitor("%t kk , b , myst %b,%b,{%b,%b}",$time, kk,b,myst.s[2],myst.s[1]);
     #1000 $finish;
  end
endmodule
