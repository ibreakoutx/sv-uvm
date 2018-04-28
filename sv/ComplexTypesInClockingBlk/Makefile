
all : clean comp run 

clean:
	\rm -rf simv* csrc *.key
comp:
	vcs cmplx_unpack_fa_clk_blk.sv -sverilog -o simv1
	vcs cmplx_unpack_struct_clk_blk.sv -sverilog -o simv2
run:
	simv1
	simv2


