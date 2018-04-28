/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


program main ;

class itirk ;
  rand integer total ;  
  rand bit [31:0] vec ;
  rand bit x ;
  
constraint con 
  {
   total == count_ones(vec) ;
   }
endclass: itirk

function int count_ones ( bit [31:0] w );
  for( count_ones = 0; w != 0; w = w >> 1 )
  count_ones += w & 1'b1;
endfunction

initial 
  begin
    bit status ;
    itirk a = new ;
    repeat(1)
    begin
      status = a.randomize() ;
      //$write("status = %0b\n", status) ;
      $write("Count of 1's in %0d('b%0b) is %0d\n", a.vec, a.vec, a.total) ;
    end
  end
endprogram: main

