#!/bin/csh -f 

vcs -sverilog  -ntb_opts rvm +incdir+./verif +define+ALU_BUG1 alu_test.sv \
        ./rtl/alu.v ./verif/alu_tb_top.sv -l comp.log
