
all:	clean comp run

clean:
	\rm -rf simv* csrc* *.log 
comp:
	vcs  -sverilog example_queue_methods.v  -l comp.log 
run:
	./simv -l run.log

