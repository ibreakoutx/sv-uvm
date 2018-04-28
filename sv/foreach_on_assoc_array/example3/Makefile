
all:	clean comp run
clean:
	\rm -rf simv* csrc* *.log
comp:
	vcs  -sverilog -ntb_opts interop test.vr test.sv  -l comp.log 
run:
	./simv -l run.log
