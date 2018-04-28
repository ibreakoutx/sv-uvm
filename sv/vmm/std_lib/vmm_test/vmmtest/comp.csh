#!/bin/csh -f

vcs -sverilog -sverilog    +incdir+./verif+./tests -ntb_opts rvm \
	./rtl/alu.v ./verif/alu_test.sv ./verif/alu_tb_top.sv
