# Set the working dir, where all compiled Verilog goes.
vlib work

# Compile all verilog modules in mux.v to working dir;
# could also have multiple verilog files.
vlog myfsm.v

# Load simulation using mux as the top level simulation module.
vsim myfsm

# Log all signals and add some signals to waveform window.
log {/*}
# add wave {/*} would add all items in top level simulation module.
add wave {/*}

# Set input values using the force command, signal names need to be in {} brackets.
# Set up clock (alternate every 1 ns, until 50 ns)
force {clk} 0 0ns, 1 1ns -repeat 2ns

# Set all signals to zero
force {play} 1
force {reset} 1
force {valid_input} 0
force {write_to_board} 0
force {logic_result} 0
force {decoder_addr[2:0]} 0
force {validator_write_onoff[5:0]} 0
force {validator_write_player[5:0]} 0
run 10ns


# Leave valid_input low, but change decoder_addr to column 4, press play
force {decoder_addr[2:0]} 100
run 10ns
force {play} 0
run 10ns
force {play} 1
run 10ns
# Nothing should happen, because switch input is invalid

# Turn on valid_input, and press play, but leave write_to_board off
force {valid_input} 1
force {play} 0
run 10ns
force {play} 1
run 10ns
# Should switch to CHECK_INPUT state (1)
# validator_go should be 1
# mem_address should be 100
# Should switch back to WAIT_INPUT state because move is invalid

# Now turn on write_to_board as well
force {validator_write_onoff[5:0]} 000001
force {validator_write_player[5:0]} 000000
force {write_to_board} 1
force {play} 0
run 10ns
force {play} 1
run 10ns
# Now the game_state should go to CHECK_INPUT, then UPDATE_GAME
# then CHECK_WINNER, then WAIT_INPUT

# Now change input position to 3
force {decoder_addr[2:0]} 011
force {validator_write_onoff[5:0]} 000001
force {validator_write_player[5:0]} 000001
force {play} 0
run 10ns
force {play} 1
run 10ns

# Now change input position back to 4
force {decoder_addr[2:0]} 100
force {validator_write_onoff[5:0]} 000011
force {validator_write_player[5:0]} 000000
force {play} 0
run 10ns
force {play} 1
run 10ns

# Now suppose game ends, when player 1 moves
force {validator_write_onoff[5:0]} 000111
force {validator_write_player[5:0]} 000100
force {play} 0
force {logic_result} 1
run 10ns
force {play} 1
force {logic_result} 0
run 10ns

# Now run a test where an invalid move is made after a valid one
# See if current player switches properly
force {decoder_addr[2:0]} 010
force {validator_write_onoff[5:0]} 111111
force {validator_write_player[5:0]} 011010
# Should be player 0
force {play} 0
run 5ns
# Disable valid move while play is pressed
force {write_to_board} 0
run 5ns
force {play} 1
run 10ns

# Now try pressing
force {play} 0
run 10ns
force {play} 1
run 10ns
force {play} 0
run 10ns
force {play} 1
run 10ns
# Should be player 1
