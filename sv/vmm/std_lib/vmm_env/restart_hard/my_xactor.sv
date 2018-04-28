/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/


class my_xactor extends vmm_xactor ;

   my_data data;

   function new(string  instance,
            integer stream_id = -1) ;
      super.new("MyXactor", instance, stream_id);
      data = new;
   endfunction
   
   virtual function void reset_xactor(reset_e rst_typ = SOFT_RST) ;
      super.reset_xactor(rst_typ);

      if (rst_typ >= FIRM_RST) 
								begin
         this.data = new;
     end 
   endfunction

   protected virtual task main() ;
      fork
									begin
         super.main();
									end
         begin
            void'(this.data.randomize());
            data.display($psprintf("%s.1.1: ", this.log.get_instance()));
            #0;
            void'(this.data.randomize());
            data.display($psprintf("%s.1.2: ", this.log.get_instance()));
            #0;
            void'( this.data.randomize());
            data.display($psprintf("%s.1.3: ", this.log.get_instance()));
         end
         begin
            $display("%s.2.1: urnd =32'h%h\n", this.log.get_instance(), $urandom());
            #0;
            $display("%s.2.2: urnd =32'h%h\n", this.log.get_instance(), $urandom());
            #0; 
            $display("%s.2.3: urnd =32'h%h\n", this.log.get_instance(), $urandom);
         end
      join
   endtask

endclass
