
all:	clean comp run

clean:
	\rm -rf simv* csrc* *.log 
comp:
	vcs  -sverilog  program_block_module_example.v  -l comp.log 
run:
	./simv -l run.log

