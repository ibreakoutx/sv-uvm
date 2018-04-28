#!/bin/csh -f

vcs -R -sverilog -ntb_opts rvm   +define+USE_SQLTXT test.sv \
       $VCS_HOME/etc/vmm/shared/src/vmm_sqltxt_interface.c
