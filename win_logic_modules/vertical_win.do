# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog register_decoder.v

# Load simulation using mux as the top level simulation module.
vsim register_decoder

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# Set input values using the force command, signal names need to be in {} brackets.
# Set up clock (alternate every 1 ns, until 50 ns)

force player_register 0
force onoff_register 0

force player 1
run 10ns

force player 0
run 10ns

force onoff_register 6'b001111
run 10ns

force onoff_register 6'b011110
force player_register 6'b000001
run 10ns

force onoff_register 6'b011111
run 10ns

force onoff_register 6'b111110
force player_register 6'b000011
run 10ns

force onoff_register 6'b111111
run 10ns

force player 1
force player_register 6'b000111
run 10ns

force player_register 6'b001111
run 10ns

force player_register 6'b011111
run 10ns

force player_register 6'b011110
run 10ns

force player_register 6'b111111
run 10ns

force player_register 6'b111101
run 10ns

force player_register 6'b111100
run 10ns
run 10ns