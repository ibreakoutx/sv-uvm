#!/bin/csh -f 


 vcs \
        -l no_ral_comp.log \
        -sverilog \
        -ntb_opts rvm \
        -debug_all \
        ec_bfm.sv ec_env.sv  ec_intf.if.svi ec_top.v  ec_test.sv ec.v

