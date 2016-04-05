`include "logicunit.v"
`include "movevalidator.v"
`include "myfsm.v"
`include "switchdecoder.v"
`include "gameboard.v"
`include "find_vga_row.v"
// `include "vga_top.v"
// `include "/data/quartus/quartus/eda/sim_lib/altera_mf.v"

/* module that takes switch/clock inputs and outputs the proper
 values to the top-level VGA module */

module gamewithVGA(
    input clk,
    input game_reset,
    input play,
    input [6:0] switch,
    
    output [2:0] row,
    output [2:0] column,
    output cur_player,
    output gameover,
    output go); // just an output for game result
    
    wire [2:0] decoder_address, mem_address;
    wire valid_input, valid_move;
    wire [5:0] onoff_data_out, player_data_out;
    wire logic_go;
    wire logic_reset, logic_result;
    wire [5:0] write_to_onoff, write_to_player;
    wire [5:0] validator_write_onoff, validator_write_player;
    wire mem_write_onoff, mem_write_player;
    
    // set up VGA row and column outputs
    // top row is 0, bottom row is 5
    // left column is 0, right column is 6
    assign column = decoder_address;
    find_vga_row row_decoder(validator_write_onoff, row);
    
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
        .mem_address(mem_address), 
        .write_to_onoff(write_to_onoff), 
        .write_to_player(write_to_player),
        .vga_go(go),
        .onoff_to_validator(onoff_data_out),
        .player_to_validator(player_data_out)
        );
        
endmodule
