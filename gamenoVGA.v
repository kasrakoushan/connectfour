`include "logicunit.v"
`include "movevalidator.v"
`include "myfsm.v"
`include "switchdecoder.v"
`include "gameboard.v"
// `include "/data/quartus/quartus/eda/sim_lib/altera_mf.v"
// check if the fact that mylog.v is included twice is an issue
// not really, is just over-written

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
    
    // TO-DO: re-write this in the .( ) notation
    
    // instantiate switch decoder
    switchdecoder swi_dec(switch, decoder_address, valid_input);
    
    // instantiate validator
    movevalidator move_val(onoff_data_out, player_data_out, 
        cur_player, valid_move, validator_write_onoff, validator_write_player);
        
    // instantiate logic unit
    logicunit log_unit(logic_reset, mem_address, write_to_onoff,
        write_to_player, logic_go, logic_result);
        
    // instantiate FSM
    myfsm my_fsm(clk, play, game_reset, valid_input, valid_move, 
        logic_result, decoder_address, validator_write_onoff,
        validator_write_player,
        
        cur_player, gameover, logic_go, logic_reset,
        mem_write_onoff, mem_write_player, mem_address, write_to_onoff, 
        write_to_player);
    
    // instantiate memory
    gameboard onoff_board(mem_address, clk, write_to_onoff,
        mem_write_onoff, onoff_data_out);
    gameboard player_board(mem_address, clk, write_to_player,
        mem_write_player, player_data_out);
        
    // now just sit back and LOL
    
endmodule
