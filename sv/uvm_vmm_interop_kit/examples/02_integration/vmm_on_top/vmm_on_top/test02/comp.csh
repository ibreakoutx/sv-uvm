#!/bin/csh -f
if ($1 != USE_VCS_LIB) then
 set COMP_ARGS = (-sverilog -ntb_opts uvm+rvm +define+VMM_ON_TOP +incdir+../../../../src +incdir+../../../../src/hfpb +incdir+../../../../src/hfpb_components)
else
 set COMP_ARGS = (-sverilog +incdir+${VCS_HOME}/etc/vmm +incdir+${VCS_HOME}/etc/uvm +incdir+../../../../src +incdir+../../../../src/hfpb +incdir+../../../../src/hfpb_components +define+VMM_ON_TOP +define+VMM_IN_PACKAGE)
endif

vcs $COMP_ARGS -l comp.log test.sv
