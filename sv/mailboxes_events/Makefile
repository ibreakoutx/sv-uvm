
all:	clean comp run

clean:
	\rm -rf simv* csrc* *.log urgReport 
comp:
	vcs  -sverilog  mailbox_events_example.v  -l comp.log 
run:
	./simv -l run.log

