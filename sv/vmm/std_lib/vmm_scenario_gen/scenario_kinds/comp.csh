#!/bin/csh -f

vcs -sverilog -ntb_opts rvm ../atm_cell.sv test_scenario_kinds.sv -l comp.log
