package env_pkg;
`include "vmm.sv"
class trans extends vmm_data;
   static vmm_log log = new("my_trans", "class");

   function new();
     super.new(log);
   endfunction

   virtual function void hello();
      `vmm_note(log, "Hello from 'trans'");
   endfunction
endclass

class my_env extends vmm_env;
   trans trans_obj;

   function new();
      trans_obj = new();
   endfunction

   task start();
      super.start();
      trans_obj.hello();
   endtask
endclass

endpackage


