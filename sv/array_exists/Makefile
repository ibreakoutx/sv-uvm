
all:	clean comp run
clean:
	\rm -rf simv* csrc* *.log
comp:
	vcs  -sverilog  array_exists.sv  -l comp.log 
run:
	./simv -l run.log
