# Syntax of a Makefile target:
#
# target: dependency1 dependency2 ...
#	process (command to generate target from dependencies)

# If no targets are specified when calling make, it will build the first target
# in the file. The first target is usually called 'all'
all: tb_monitor.ghw

# Phony targets are always executed, even if a file with the same name exists
# These are typically short names for other recipes
.PHONY: all prog clean

##################
### Simulation ###
##################

# Analyze vhdl sources for simulation
protocol_common.o: ../practica1/protocol_common.vhd
	ghdl -a ../practica1/protocol_common.vhd

driver.o: ../practica1/driver.vhd
	ghdl -a ../practica1/driver.vhd

monitor.o: monitor.vhd
	ghdl -a monitor.vhd

tb_monitor.o: tb_monitor.vhd
	ghdl -a tb_monitor.vhd

# Generate simulation executable
tb_monitor: protocol_common.o tb_monitor.o monitor.o driver.o
	ghdl -e tb_monitor

# Generate simulation waveform
tb_monitor.ghw: tb_monitor
	./tb_monitor --wave=tb_monitor.ghw

# Open gtkwave
view: tb_monitor.ghw
	gtkwave tb_monitor.ghw

######################
### Implementation ###
######################

# # Synthesize
# monitor.json: monitor.vhd
# 	yosys -m ghdl -p 'ghdl monitor.vhd -e monitor; synth_ice40 -json monitor.json'

# # Place and route
# monitor.asc: monitor.json
# 	nextpnr-ice40 --up5k --package sg48 --pcf monitor.pcf --json monitor.json --asc monitor.asc

# # Bitstream generation
# monitor.bin: monitor.asc
# 	icepack monitor.asc monitor.bin

# # Configure the FPGA
# prog: monitor.bin
# 	iceprog monitor.bin

###############
### Cleanup ###
###############

# Clean:
clean:
	rm -f *.o *.ghw work-obj??.cf tb_monitor
	rm -f *.json *.asc *.bin

