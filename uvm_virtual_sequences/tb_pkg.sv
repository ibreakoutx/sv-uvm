package tb_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
     
  typedef uvm_resource_db #(virtual interface drive_interface) resource_db_drive_intf ;
  typedef uvm_resource_db #(virtual interface sample_interface) resource_db_sample_intf ;
  typedef uvm_resource_db #(virtual interface reset_interface) resource_db_reset_intf ;
    
  `include "data_xaction.sv"
  `include "data_driver.sv"
  `include "data_monitor.sv"
  `include "data_sequencer.sv"
  `include "virtual_sequencer.sv"
  `include "coverage_collector.sv"
  `include "tb_env.sv"
  `include "sequences.sv"
  `include "test2_virtual_sequence.sv"
  `include "tests.sv"
    
endpackage

