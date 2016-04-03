# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog control_vga.v

# Load simulation using mux as the top level simulation module.
vsim control_vga

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

force clk 0 
#clk
force resetn 0 
#resetn
force go 0 
#go
run 10ns

force clk 1
run 10ns
force clk 0
force go 1 
#go
run 10ns

force clk 1
run 10ns
force clk 0
run 10ns

#X IS 2

force clk 1
run 10ns
force clk 0
run 10ns

force clk 1
run 10ns
force clk 0
run 10ns
#X IS 3

force clk 1
run 10ns
force clk 0
run 10ns

force clk 1
run 10ns
force clk 0
run 10ns
#X IS 4

force clk 1
run 10ns
force clk 0
run 10ns

force clk 1
run 10ns
force clk 0
run 10ns
#X IS 5

force clk 1
run 10ns
force clk 0
run 10ns

force clk 1
run 10ns
force clk 0
run 10ns
#X IS 2, Y IS 3

force clk 1
run 10ns
force clk 0
run 10ns

force clk 1
run 10ns
force clk 0
run 10ns
#X IS 3, Y IS 3, BUT SHOULD CHANGE BACK to 0, STOP DRAWING

force clk 1
run 10ns
force clk 0
run 10ns

force clk 1
run 10ns
force clk 0
run 10ns
#done should change?????