set FLAG=-v -PALL_LIB --syn-binding --ieee=synopsys --std=93c -fexplicit


ghdl -a --work=WORK --workdir=ALL_LIB %FLAG% ..\vhdl\fifo_control.vhd
ghdl -a --work=WORK --workdir=ALL_LIB %FLAG% ..\vhdl\dp8x16.vhd
ghdl -a --work=WORK --workdir=ALL_LIB %FLAG% ..\vhdl\fifo_out_adaptor.vhd
ghdl -a --work=WORK --workdir=ALL_LIB %FLAG% ..\test\tb_fifo_out_adaptor.vhd
ghdl -e --work=WORK --workdir=ALL_LIB %FLAG% tb_fifo_out_adaptor
ghdl -r --work=WORK --workdir=ALL_LIB %FLAG% tb_fifo_out_adaptor --wave=tb_fifo_out_adaptor.ghw

gtkwave tb_fifo_out_adaptor.ghw
