#!/bin/csh -f

vcs -sverilog  -ntb_opts rvm  env_pkg.sv tests.sv prog.sv -l comp.log
