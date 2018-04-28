#!/bin/csh -f

vcs -sverilog +verilog1995ext+.v -ntb_opts rvm +warn=noBCNACMBP    test_mii.sv top.sv  \
                +define+ASSERT_ON+SVA_CHECKERS+COVER_ON+ASSERT_INIT_MSG+SVA_CHECKER -assert quiet+report
