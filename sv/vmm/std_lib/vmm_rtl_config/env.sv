//
// -------------------------------------------------------------
//    Copyright 2004-2009 Synopsys, Inc.
//    All Rights Reserved Worldwide
//
//    Licensed under the Apache License, Version 2.0 (the
//    "License"); you may not use this file except in
//    compliance with the License.  You may obtain a copy of
//    the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in
//    writing, software distributed under the License is
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//    CONDITIONS OF ANY KIND, either express or implied.  See
//    the License for the specific language governing
//    permissions and limitations under the License.
// -------------------------------------------------------------
//



`include "vmm.sv"

program P;

//configurations
class ahb_master_config extends vmm_rtl_config;
   rand  int addr_width;
   rand  bit mst_enable;
   string    kind = "MSTR";
   
   constraint cst_mst {
     addr_width == 64;
     mst_enable == 1;
   }
`vmm_rtl_config_begin(ahb_master_config)
   `vmm_rtl_config_int(addr_width, mst_width)  
   `vmm_rtl_config_boolean(mst_enable, mst_enable)
   `vmm_rtl_config_string(kind, kind)
`vmm_rtl_config_end(ahb_master_config)

   function new(string name = "", vmm_rtl_config parent = null);
      super.new(name, parent);
   endfunction

endclass

//configurations
class ahb_slave_config extends vmm_rtl_config;
   rand  int addr_width;
   rand  bit slv_enable;
   string    kind = "SLV";

   constraint cst_slv {
     addr_width == 32;
     slv_enable == 0;
   }
   
`vmm_rtl_config_begin(ahb_slave_config)
   `vmm_rtl_config_int(addr_width, slv_width)  
   `vmm_rtl_config_boolean(slv_enable, slv_enable)  
   `vmm_rtl_config_string(kind, kind)
`vmm_rtl_config_end(ahb_slave_config)

   function new(string name = "", vmm_rtl_config parent = null);
      super.new(name, parent);
   endfunction

endclass

class env_config extends vmm_rtl_config;
   rand ahb_master_config mst_cfg;
   rand ahb_slave_config  slv_cfg;

   function new(string name = "", vmm_rtl_config parent = null);
      super.new(name, parent);
   endfunction

   function void build_config_ph();
      mst_cfg = new("mst_cfg", this);
      slv_cfg = new("slv_cfg", this);
   endfunction

endclass


//Object hierarchy
class ahb_master extends vmm_xactor;
   ahb_master_config cfg;

   function new(string name, vmm_unit parent = null);
      super.new(get_typename(), name,0, parent);
   endfunction

   function void configure_ph();
      $cast(cfg, vmm_rtl_config::get_config(this, `__FILE__, `__LINE__));
      if (cfg == null) begin
        `vmm_error(log, `vmm_sformatf("null Config obtained for %s", this.get_object_hiername()));
        return;
      end
      if (!cfg.mst_enable) `vmm_error(log, "mst_enable is not set");
      if (cfg.addr_width != 64) `vmm_error(log, `vmm_sformatf("Expected addr_width 32, actual %0d", cfg.addr_width));
      if (cfg.kind != "MSTR") `vmm_error(log, `vmm_sformatf("Expected kind MSTR, actual %s", cfg.kind));
   endfunction

endclass

class ahb_slave extends vmm_xactor;

   ahb_slave_config cfg;

   function new(string name, vmm_unit parent = null);
      super.new(get_typename(), name,0,parent);
   endfunction

   function void configure_ph();
      $cast(cfg, vmm_rtl_config::get_config(this, `__FILE__, `__LINE__));
      if (cfg == null) begin
        `vmm_error(log, `vmm_sformatf("null Config obtained for %s", this.get_object_hiername()));
        return;
      end
      if (cfg.slv_enable) `vmm_error(log, "slv_enable is set");
      if (cfg.addr_width != 32) `vmm_error(log, `vmm_sformatf("Expected addr_width 32, actual %0d", cfg.addr_width));
      if (cfg.kind != "SLV") `vmm_error(log, `vmm_sformatf("Expected kind SLV, actual %s", cfg.kind));
   endfunction

endclass


class env extends vmm_group;
  ahb_master mstr;
  ahb_slave  slv;

   function new(string name, vmm_object parent = null);
      super.new(get_typename(), name, parent);
   endfunction

  function void build_ph();
     mstr = new("mst", this);
     slv  = new("slv", this);
     env_cfg.map_to_name("^");
     env_cfg.mst_cfg.map_to_name("env:mst"); //todo - to be moved to test
     env_cfg.slv_cfg.map_to_name("env:slv"); //todo - to be moved to test
  endfunction

endclass

class test extends vmm_test;

   function new(string name = "");
      super.new(name);
   endfunction

endclass


env_config env_cfg = new("env_cfg");
env e = new("env");
vmm_rtl_config_default_file_format dflt_fmt = new();

initial begin
  test t = new();
  vmm_rtl_config::default_file_fmt = dflt_fmt;
  vmm_simulation::run_tests();
end

endprogram



