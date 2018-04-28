
all:	clean comp run
clean:
	\rm -rf simv* csrc* *.log
comp:
	vcs  -sverilog  clocking_block_example.v  -l comp.log 
run:
	./simv -l run.log
