//module top (pwr_ctl) ;
module top ;

   //reg pwr_ctl ;
   
   down down();
   
   initial
     begin
	$display("hello world");
	$finish;
     end

endmodule // top

module down() ;

   wire pwr_ctl;

   initial
     begin
	$display("hello world");
	$finish;
     end

endmodule // top

