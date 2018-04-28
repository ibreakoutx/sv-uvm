all: comp run 

clean:
	\rm -rf simv* csrc vc_hdrs* ucli.key *.log 

comp:
	vcs -sverilog -ntb_opts rvm test.sv 

run:
	simv
