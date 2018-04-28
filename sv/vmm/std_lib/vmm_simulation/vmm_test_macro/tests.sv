import env_pkg::*;

`vmm_test_begin(test1, my_env, "Test #1")
   `vmm_note(log, {"Starting test ", get_name()});
   this.env.run();
   `vmm_note(log, {"Done test ", get_name()});
`vmm_test_end(test1)

class my_trans extends trans;
   virtual function void hello();
      `vmm_note(log, "Hello from 'my_trans'");
   endfunction
endclass


`vmm_test_begin(test2, my_env, "Test #2")
   `vmm_note(log, {"Starting test ", get_name()});
			begin
     my_trans my_trans_obj = new;
					this.env.trans_obj = my_trans_obj;
			end
   this.env.run();
   `vmm_note(log, {"Done test ", get_name()});
`vmm_test_end(test2)
