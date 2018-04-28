#!/bin/csh -f

ralgen -l sv -t dropsys drop_shared.ralf
vcs -sverilog +verilog1995ext+.v \
	 -ntb -ntb_opts rvm \
	$VCS_HOME/etc/vmm/sv/RAL/tests/bit_bash.sv .//tb_top.sv .//dropbox.sv .//dropsys.sv  +incdir+./
