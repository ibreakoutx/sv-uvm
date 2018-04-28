/*********************************************************************
 * SYNOPSYS CONFIDENTIAL                                             *
 *                                                                   *
 * This is an unpublished, proprietary work of Synopsys, Inc., and   *
 * is fully protected under copyright and trade secret laws. You may *
 * not view, use, disclose, copy, or distribute this file or any     *
 * information contained herein except pursuant to a valid written   *
 * license from Synopsys.                                            *
 *********************************************************************/

program test_vmm_log;

`include "vmm.sv"


class vmm_log_breakpoint;    
  vmm_log           bp           = new("vmm_log_breakpoint", "vmm_log_breakpoint");;
  int         wp;
  string   stop_at;
  vmm_log           L              = new("Log11", "base");
    
    task wait_for_bp();
                int wp;  

                wp = L.create_watchpoint();
                L.add_watchpoint(wp, "/Log11/", "/./");  //Using pattern match for the instance name
                L.add_watchpoint(wp, "/KSKS/","/./");    //Using pattern match for the instance name

                fork
                  begin
                vmm_log_msg msg; 
                forever begin
                  L.wait_for_watchpoint(wp, msg);
                  $display("Stop at 'wait_at_bp'");               // When a vmm_note is fired, the following should be displayed
                end
                  end
                join_none
    endtask
endclass

// ******** start or MAIN ********

  vmm_log l         = new("KSKS", "a");
  vmm_log l11    = new("Log11", "base2");

initial begin
  vmm_log_breakpoint vmm_bp = new();
  
  vmm_bp.wait_for_bp();
  
  #100;
  `vmm_note(l11, "MESSAGE FROM l11");           
  #12;
  `vmm_note(l,   "MESSAGE FROM l");                  
  #100;
  $display;
  #100;
        
end // initial begin
endprogram
