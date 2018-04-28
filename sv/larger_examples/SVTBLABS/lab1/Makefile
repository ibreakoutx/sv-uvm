FILES = hdl/top.v hdl/arb.v hdl/arb_if.v tests/test.v
FLAGS = -sverilog -debug

run:	simv
	./simv -l simv.log

simv:	${FILES}
	vcs ${FLAGS} ${FILES}

clean: 	
	@rm -rf csrc simv* *.tcl *.vpd .res* ucli* .ucli* *.old *.txt *.db 
	@rm -rf *.log *~ */*~ .*/*~
