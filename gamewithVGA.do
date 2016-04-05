# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog gamewithVGA.v

# Load simulation using mux as the top level simulation module.
vsim -L altera_mf_ver gamewithVGA

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# Set input values using the force command, signal names need to be in {} brackets.
# Set up clock (alternate every 1 ns, until 50 ns)
force {clk} 0 0ns, 1 1ns -repeat 2ns

# Set all signals to zero
force {game_reset} 1
force {play} 1
force {switch[6:0]} 0
run 10ns

# Try setting inputs to column 0 and pressing play
force {switch[6:0]} 1000000
force {play} 0
run 10ns
force {play} 1
run 10ns

# Now press play again with player 1 playing
force {play} 0
run 10ns
force {play} 1
run 10ns

# Now keep pressing play until column is full, see what happens
# This should do 5 consecutive moves in the same column (1 move should be ineffectual)
force {play} 0 0ns, 1 4ns -repeat 8ns -cancel 48ns

run 48ns

# Run player 0 now on a valid column
force {switch[6:0]} 0100000
force {play} 0
run 10ns
force {play} 1
run 10ns
