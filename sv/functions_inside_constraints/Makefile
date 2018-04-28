
all:	clean comp run

clean:
	\rm -rf simv* csrc* *.log 
comp:
	vcs  -sverilog funcs_in_constraints.sv  -l comp.log 
run:
	./simv -l run.log

