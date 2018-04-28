program run;

`include "vmm.sv"
import env_pkg::*;

initial 
begin
   my_env env = new;
   $write("--- Start of Reflog ---\n");
   vmm_test_registry::run(env);
   $write("--- End of Reflog ---\n");
end
endprogram

