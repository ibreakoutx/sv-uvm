
all:	clean comp run
clean:
	\rm -rf simv* csrc* *.log
comp:
	vcs  -sverilog example_dynamic_array.v -l comp.log 
run:
	./simv -l run.log
