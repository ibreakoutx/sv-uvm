#!/bin/csh -f

	./simv +UVM_TESTNAME=cmdline_test +UVM_REG_SEQ=uvm_reg_hw_reset_seq
	./simv +UVM_TESTNAME=cmdline_test +UVM_REG_SEQ=user_test_seq
