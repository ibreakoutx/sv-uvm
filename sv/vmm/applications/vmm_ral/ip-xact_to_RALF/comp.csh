#! /bin/csh -f


ralgen  -ipxact2ralf DW_ahb_dmac.xml

diff DW_ahb_dmac.ralf DW_ahb_dmac.ralf.gold
