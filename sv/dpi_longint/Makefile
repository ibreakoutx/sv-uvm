
all: clean comp run 

clean:
	rm -Rf csrc simv*  vc_hdrs.h *.log
comp: 
	vcs -sverilog case1.sv case1.cpp -l comp.log 

run:
	simv -l run.log 
