
all: clean comp 

clean:
	
	\rm -rf DW_ahb_dmac.ralf
comp:
	
	ralgen  -ipxact2ralf DW_ahb_dmac.xml

	diff DW_ahb_dmac.ralf DW_ahb_dmac.ralf.gold
