analyze -clear
analyze -sva top_xorexec.v hfifo.v xorexec.v
analyze -sva top_xorexec_sva.sv

elaborate -top top_xorexec

clock clk
reset rst

