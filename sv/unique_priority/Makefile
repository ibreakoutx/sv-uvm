
all:	clean comp run
clean:
	\rm -rf simv* csrc* *.log
comp:
	vcs  -sverilog  unique_priority.sv  -l comp.log 
run:
	./simv -l run.log
