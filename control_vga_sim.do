# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog control_vga_sim.v

# Load simulation using mux as the top level simulation module.
vsim control_vga_sim

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {go} 0
force clk 0
run 10ns
force clk 1
run 10ns
force clk 0
run 10ns

force clk 1
run 10ns
force {go} 1
force clk 0
run 10ns

force clk 1
run 10ns

force clk 0
run 10ns

force clk 1
run 10ns

force clk 0
run 10ns

force clk 1
run 10ns

force clk 0
run 10ns

force clk 1
run 10ns

force clk 0
run 10ns

force clk 1
run 10ns

force clk 0
run 10ns

force clk 1
run 10ns

force clk 0
run 10ns

force clk 1
run 10ns

force clk 0
run 10ns

#SHOULD BE A CHANGE OF STATE TO DONE AFTER THIS

force clk 1
run 10ns

force clk 0
run 10ns

force clk 1
run 10ns

force clk 0
force go 0
run 10ns

force clk 1
force go 1
run 10ns

force clk 0

force clk 1
run 10ns

force clk 0
run 10ns
force clk 1
run 10ns

force clk 0
run 10ns
force resetn 1

force clk 1
run 10ns

force clk 0
run 10ns
run 10ns
