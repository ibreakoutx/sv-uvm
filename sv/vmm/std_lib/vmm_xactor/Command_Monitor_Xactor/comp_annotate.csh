#!/bin/csh -f
vcs +plusarg_save -sverilog  -ntb_opts rvm  test_annotate.sv tb_top.sv -l comp_annotate.log
