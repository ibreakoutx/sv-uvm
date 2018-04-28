#!/bin/csh -f

./simv  -l simv.log
./simv  +UVM_TESTNAME=hw_reset -l hw_reset.log
