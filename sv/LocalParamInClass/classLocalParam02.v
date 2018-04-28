/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/



program top;

  class C #(P1 = 10,type TP = int);
	parameter byte Pvalue = P1;
	parameter type PType = TP;
	PType var1;	
	function new();
		var1 = P1;
	endfunction	
  endclass

	C c1;
    C#(100,logic[7:0]) c2;

  initial begin
  	c1 = new;  						// Pvalue & Ptype will  have default value & type i.e 10 & int	
	A1:assert(c1.var1 == 10);
	A2:assert($bits(c1.var1) == 32);
  	c2 = new;						// Pvalue will have 100 &  PType will be logic[7:0]
	A3:assert(c2.var1 == 100);
	A4:assert($bits(c2.var1) == 8);
  end
endprogram
