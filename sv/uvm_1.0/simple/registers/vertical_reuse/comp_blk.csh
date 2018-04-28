#!/bin/csh -f
ralgen -uvm -t B blk.ralf
vcs -cpp g++ -cc gcc -sverilog -ntb_opts uvm-1.0 -timescale=1ns/1ns +incdir+../common/apb -debug +define+RALGEN \
		blk_run.sv -l blk_comp.log
