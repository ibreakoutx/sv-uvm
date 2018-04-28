#!/bin/csh -f

ralgen -l sv -t dropsys drop_shared.ralf
vcs -sverilog +verilog1995ext+.v \
	 -R -ntb -ntb_opts rvm \
	user_test.sv .//tb_top.sv .//dropbox.sv .//dropsys.sv  +incdir+./
