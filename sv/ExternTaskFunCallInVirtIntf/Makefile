
all : clean comp run 

clean:
	\rm -rf simv* csrc *.key
comp:
	vcs VI_extern_func_example.sv -sverilog -o simv1
	vcs VI_extern_task_example.sv -sverilog -o simv2
run:
	./simv1
	./simv2


