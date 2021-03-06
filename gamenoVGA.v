`include "logicunit.v"
`include "movevalidator.v"
`include "myfsm.v"
`include "switchdecoder.v"
`include "gameboard.v"
// `include "/data/quartus/quartus/eda/sim_lib/altera_mf.v"
// check if the fact that mylog.v is included twice is an issue
// not really, is just over-written
// this code no longer works with myfsm (because myfsm has been updated
// to include outputs to VGA)

module gamenoVGA(
    input clk,
    input game_reset,
    input play,
    input [6:0] switch,
    
    output gameover); // just an output for game result
    
    wire [2:0] decoder_address, mem_address;
    wire valid_input, valid_move;
    wire [5:0] onoff_data_out, player_data_out;
    wire logic_go, cur_player;
    wire logic_reset, logic_result;
    wire [5:0] write_to_onoff, write_to_player;
    wire [5:0] validator_write_onoff, validator_write_player;
    wire mem_write_onoff, mem_write_player;
    
    // instantiate switch decoder
    switchdecoder swi_dec(
        .switch(switch), 
        .address(decoder_address), 
        .valid_input(valid_input)
        );
    
    // instantiate validator
    movevalidator move_val(
        .onoff_data(onoff_data_out), 
        .player_data(player_data_out),
        .cur_player(cur_player), 
        .valid_move(valid_move), 
        .write_onoff(validator_write_onoff), 
        .write_player(validator_write_player)
        );
        
    // instantiate logic unit
    logicunit log_unit(
        .reset(logic_reset), 
        .address(mem_address), 
        .onoff_write(write_to_onoff),
        .player_write(write_to_player), 
        .go(logic_go), 
        .logic_result(logic_result)
        );
        
    // instantiate FSM
    myfsm my_fsm(
        .clk(clk), 
        .play(play), 
        .reset(game_reset), 
        .valid_input(valid_input), 
        .write_to_board(valid_move),
        .logic_result(logic_result), 
        .decoder_addr(decoder_address), 
        .validator_write_onoff(validator_write_onoff),
        .validator_write_player(validator_write_player),
        
        .cur_player(cur_player), 
        .game_finished(gameover), 
        .logic_go(logic_go), 
        .logic_reset(logic_reset),
        .onoff_write(mem_write_onoff), 
        .player_write(mem_write_player), 
        .mem_address(mem_address), 
        .write_to_onoff(write_to_onoff), 
        .write_to_player(write_to_player)
        );
    
    // instantiate memory
    gameboard onoff_board(
        .address(mem_address), 
        .clock(clk), 
        .data(write_to_onoff),
        .wren(mem_write_onoff), 
        .q(onoff_data_out)
        );
    gameboard player_board(
        .address(mem_address), 
        .clock(clk), 
        .data(write_to_player),
        .wren(mem_write_player), 
        .q(player_data_out)
        );
        
    // now just sit back and LOL
    
endmodule
