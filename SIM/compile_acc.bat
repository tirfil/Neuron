set FLAG=-v -PALL_LIB --syn-binding --ieee=synopsys --std=93c -fexplicit

ghdl -a --work=WORK --workdir=ALL_LIB %FLAG% ..\vhdl\selector.vhd
ghdl -a --work=WORK --workdir=ALL_LIB %FLAG% ..\vhdl\shift5.vhd
ghdl -a --work=WORK --workdir=ALL_LIB %FLAG% ..\vhdl\fp16adderppl.vhd
ghdl -a --work=WORK --workdir=ALL_LIB %FLAG% ..\vhdl\fifo_control.vhd
ghdl -a --work=WORK --workdir=ALL_LIB %FLAG% ..\vhdl\dp8x16.vhd
ghdl -a --work=WORK --workdir=ALL_LIB %FLAG% ..\vhdl\fifo_out_adaptor.vhd
ghdl -a --work=WORK --workdir=ALL_LIB %FLAG% ..\vhdl\accumulator.vhd
ghdl -a --work=WORK --workdir=ALL_LIB %FLAG% ..\test\tb_accumulator.vhd
ghdl -e --work=WORK --workdir=ALL_LIB %FLAG% tb_accumulator

ghdl -r --work=WORK --workdir=ALL_LIB %FLAG% tb_accumulator --wave=tb_accumulator.ghw

gtkwave tb_accumulator.ghw






