#!/bin/csh -f

ralgen -l sv -t ec ec.ralf



vcs  -l com_ralp.log  -sverilog  +incdir+$VCS_HOME/etc/rvm -debug_all ec_intf.if.svi ec_ral_test.sv  ec.v  ec_top.v
