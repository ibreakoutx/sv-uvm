#!/bin/csh -f

vcs -sverilog -ntb_opts rvm alu_tb_top.sv alu.v test.sv -debug_pp
