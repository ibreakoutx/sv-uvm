class tb_mon extends vmm_xactor;
  virtual dut_if.mon iport;
  tb_data_channel    chan;

  function new(string instance, virtual dut_if.mon iport, tb_data_channel chan);
    super.new("tb_mon", instance);
    this.iport = iport;
    this.chan  = chan;
  endfunction

 task main();
   super.main();
   $display("== MON Started == "); 
   scan();
 endtask

 task scan();
   tb_data out_tran;

   while (1) begin
      @(iport.mon_cb);
      if (iport.mon_cb.enable) begin
        out_tran = new();
   
        out_tran.kind = iport.mon_cb.direction;
        out_tran.addr = iport.mon_cb.addr; 	 
       
        @(iport.mon_cb);
        if(iport.mon_cb.direction == tb_data :: WRITE)
          out_tran.data = iport.mon_cb.wdata;
        else if (iport.mon_cb.direction == tb_data :: READ)  
          out_tran.data = iport.mon_cb.rdata;
   
        chan.put (out_tran);
      end
   end  
 endtask  

endclass


