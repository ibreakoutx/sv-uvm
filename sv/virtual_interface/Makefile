
all:	clean comp run

clean:
	\rm -rf simv* csrc* *.log 
comp:
	vcs  -sverilog  virtual_intf_example.v -l comp.log 
run:
	./simv -l run.log


