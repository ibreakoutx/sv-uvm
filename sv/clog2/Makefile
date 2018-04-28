
all:	clean comp run
clean:
	\rm -rf simv* csrc* *.log
comp:
	vcs  -sverilog  clog2.sv  -l comp.log 
run:
	./simv -l run.log
