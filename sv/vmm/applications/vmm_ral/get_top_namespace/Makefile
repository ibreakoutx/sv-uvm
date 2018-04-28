
all: clean comp run

clean:
	\rm -rf simv* csrc ral_* ucli.key *.h *.hvp *.log

comp: 
	ralgen -c b -l sv -t sys2 top0.ralf
	ralgen -c b -l sv -t sys2a top1.ralf
	ralgen -c b -l sv -t sys2b top2.ralf
	vcs -sverilog -ntb -ntb_opts rvm top.sv +define+VMM_12_UNDERPIN_VMM_RAL

run: 
	simv -l run.log
