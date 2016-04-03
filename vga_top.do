# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog vga_top.v

# Load simulation using mux as the top level simulation module.
vsim vga_top

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force {KEY0[0]} 0 
#clk
force {KEY0[1]} 0 
#resetn
force {SW[0]} 0 
#player
force {SW[1]} 0 
#go
run 10ns

force {KEY0[0]} 1
run 10ns
force {KEY0[0]} 0
force {SW[1]} 1 
#go
run 10ns

force {KEY0[0]} 1
run 10ns
force {KEY0[0]} 0
run 10ns

#X IS 2

force {KEY0[0]} 1
run 10ns
force {KEY0[0]} 0
run 10ns

force {KEY0[0]} 1
run 10ns
force {KEY0[0]} 0
run 10ns
#X IS 3

force {KEY0[0]} 1
run 10ns
force {KEY0[0]} 0
run 10ns

force {KEY0[0]} 1
run 10ns
force {KEY0[0]} 0
run 10ns
#X IS 4

force {KEY0[0]} 1
run 10ns
force {KEY0[0]} 0
run 10ns

force {KEY0[0]} 1
run 10ns
force {KEY0[0]} 0
run 10ns
#X IS 5

force {KEY0[0]} 1
run 10ns
force {KEY0[0]} 0
run 10ns

force {KEY0[0]} 1
run 10ns
force {KEY0[0]} 0
run 10ns
#X IS 2, Y IS 3

force {KEY0[0]} 1
run 10ns
force {KEY0[0]} 0
run 10ns

force {KEY0[0]} 1
run 10ns
force {KEY0[0]} 0
run 10ns
#X IS 3, Y IS 3, BUT SHOULD CHANGE BACK to 0, STOP DRAWING

force {KEY0[0]} 1
run 10ns
force {KEY0[0]} 0
run 10ns

force {KEY0[0]} 1
run 10ns
force {KEY0[0]} 0
run 10ns
#done should change?????