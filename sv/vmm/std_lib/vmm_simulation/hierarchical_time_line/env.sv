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

program automatic ugExample1;
  `include "vmm.sv"

  class  timelineExtension extends vmm_timeline;
    `vmm_typename(timelineExtension)
  
    extern virtual function void build_ph();
    extern virtual function void configure_ph();
    extern virtual function void connect_ph();
    extern virtual function void start_of_sim_ph();
    extern virtual function void start_of_test_ph();
    extern virtual function void report_ph();
    
    function new (string name, string inst, vmm_unit parent=null);
      super.new(name,inst,parent);
      this.delete_phase("reset");
      this.delete_phase("training");
      this.delete_phase("config_dut");
      this.delete_phase("start");
      this.delete_phase("run_test");
      this.delete_phase("shutdown");
      this.delete_phase("cleanup");
    endfunction
  endclass

//Methods Definations
  function void timelineExtension::build_ph();
    `vmm_note(log, `vmm_sformatf($psprintf("%s:A",this.get_object_hiername())));
  endfunction:build_ph 

  function void timelineExtension::configure_ph(); 
    `vmm_note(log, `vmm_sformatf($psprintf("%s:B",this.get_object_hiername())));
  endfunction:configure_ph
  
  function void timelineExtension::connect_ph(); 
    `vmm_note(log, `vmm_sformatf($psprintf("%s:C",this.get_object_hiername())));
  endfunction:connect_ph

  function void timelineExtension::start_of_sim_ph(); 
    `vmm_note(log, `vmm_sformatf($psprintf("%s:D",this.get_object_hiername())));
  endfunction:start_of_sim_ph
  
  function void timelineExtension::start_of_test_ph(); 
    `vmm_note(log, `vmm_sformatf($psprintf("%s:E",this.get_object_hiername())));
  endfunction:start_of_test_ph

  function void timelineExtension::report_ph(); 
    `vmm_note(log, `vmm_sformatf($psprintf("%s:G",this.get_object_hiername())));
  endfunction:report_ph

  class myTimeline1 extends timelineExtension;
    function new (string name, string inst, vmm_unit parent=null);
      super.new(name,inst,parent);
      this.delete_phase("build");
      this.delete_phase("connect");
      this.delete_phase("start_of_sim");
      this.delete_phase("report");
    endfunction
  endclass

  class myTimeline2 extends timelineExtension;
    
    function new (string name, string inst, vmm_unit parent=null);
      vmm_unit_startsimph_phase_def ph;
      super.new(name,inst,parent);
      ph = new;
      this.delete_phase("connect");
      this.delete_phase("start_of_sim");
      this.delete_phase("start_of_test");
      this.delete_phase("report");
      this.insert_phase("start_of_sim", "configure", ph);
    endfunction
  endclass

  class myTimeline3 extends timelineExtension;
    function new (string name, string inst, vmm_unit parent=null);
      super.new(name,inst,parent);
      this.delete_phase("connect");
      this.delete_phase("start_of_test");
    endfunction
  endclass

 
  myTimeline1      top;
  myTimeline2      mid;
  myTimeline3      low;
  vmm_log   log = new("test", "test");
  
  initial begin
    top = new("top", "top");
    mid = new("mid", "mid", top);
    low = new("low", "low", mid);
    top.run_phase();
    log.report();
  end

endprogram
