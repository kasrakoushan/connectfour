/*
Some notes:
- move validator only needs access to one memory address
- however, game logic unit needs access to several memory addresses
- so we will need an input from the logic unit for what address it needs
*/

module myfsm(
    input clk,
    input play, // REMEMBER TO COMPLEMENT (this is a KEY)
    input reset,
    input decoder_valid, // decoder output: whether switch input was valid
    input write_to_board, // result from move validator
    input [2:0] logic_result, // result from game logic unit
    input [2:0] decoder_addr, // address from decoder
    input [5:0] validator_write_onoff, // write value from validator
    input [5:0] validator_write_player, // write value from validator
    
    output reg cur_player, // current player
    output reg game_finished, // whether game is finished (useful for VGA)
    output reg logic_go, // command to game logic unit
    output reg validator_go, // command to move validator
    output reg onoff_write, 
    output reg player_write,
    output reg [2:0] mem_address, // memory address to write to
    output reg [5:0] write_to_onoff, // value to write to on off board
    output reg [5:0] write_to_player); // value to write to player board
    
    reg [2:0] current_state, next_state;
    
    initial cur_player = 1'b0; // initialize cur_player to 0
    initial game_finished = 1'b0;
    integer index; // initialize index for memory reset loop
    
    localparam  WAIT_INPUT          = 3'd0, // wait for input
                CHECK_INPUT         = 3'd1, // check if input was valid
                UPDATE_GAME         = 3'd2, // update the game state
                CHECK_WINNER        = 3'd3, // check for a winner
                END_GAME_STATE      = 3'd4, // wait for restart
                
                // OUTPUTS OF WIN LOGIC UNIT
                LOGIC_UNSURE        = 2'd0, // logic unit is not finished
                LOGIC_OVER          = 2'd1, // game is over
                LOGIC_NOTOVER       = 2'd2; // game is not over
                // might not need these signals - just send everything to logic unit
                
    // state table
    always @(*) begin
        case (current_state)
            // wait until play is pressed, then change to CHECK_INPUT
            WAIT_INPUT: begin
                if (decoder_valid)
                    next_state = play ? CHECK_INPUT: WAIT_INPUT;
            end
            
            // if move was valid, change to UPDATE_GAME, otherwise stay
            CHECK_INPUT: next_state = write_to_board ? UPDATE_GAME: WAIT_INPUT;
            
            // change to the CHECK_WINNER state
            UPDATE_GAME: next_state = CHECK_WINNER;
            
            /* wait until logic unit has checked game state
            if game is over, change to END_GAME_STATE
            if game is not over, change to WAIT_INPUT
            */
            CHECK_WINNER: begin
                case (logic_result)
                    LOGIC_OVER: next_state = END_GAME_STATE;
                    LOGIC_NOTOVER: begin 
                        next_state = WAIT_INPUT;
                        cur_player = !cur_player;
                    end
                    LOGIC_UNSURE: next_state = CHECK_WINNER;
                    // should not need a default
                endcase
            end
                
            // wait until play is pressed, then change to WAIT_INPUT
            END_GAME_STATE: next_state = play ? WAIT_INPUT: END_GAME_STATE;
            
            // by default, go to END_GAME_STATE state
            // should not reach this
            default: next_state = END_GAME_STATE;
        endcase
    end
    
    // datapath signals
    always @(*) begin
        // by default make signals zero
        logic_go = 1'b0;
        validator_go = 1'b0;
        onoff_write = 1'b0;
        player_write = 1'b0;
        mem_address = 3'd0;
        
        case (current_state)
            // set memory address to be address from decoder
            // enable move validator
            CHECK_INPUT: begin
                validator_go = 1'b1;
                mem_address = decoder_addr;
                /* validator will take current player, and 1 column from
                each of the onoff and player boards */
            end
            
            // change player, enable writing to game boards
            UPDATE_GAME: begin
                // enable write for memory, set address
                onoff_write = 1'b1;
                player_write = 1'b1;
                mem_address = decoder_addr;
                // update memory
                write_to_onoff = validator_write_onoff;
                write_to_player = validator_write_player;
                // is this enough to update memory?
                // can we update cur_player here without messing something up?
                // TO-DO: check in Modelsim
            end
            
            // enable game logic unit
            CHECK_WINNER: begin
                logic_go = 1'b1;
                // TO-DO: change address to RAM as needed by logic unit
                // OR maybe just send logic unit all of current game state
            end
            
            // set cur_player to 0
            // wait for play button to reset game boards
            END_GAME_STATE: begin
                cur_player = 1'b0;
                game_finished = 1'b0;
                if (play)
                    onoff_write = 1'b1;
                    player_write = 1'b1;
                    write_to_onoff = 6'd0;
                    write_to_player = 6'd0;
                    for (index = 0; index < 7; index = index + 1)
                        begin
                            mem_address = index;
                            // should this be enough to fill board with 0s?
                            // TO-DO: check in Modelsim
                        end
            end
            
            // should not need a default
        endcase
    end
        
    
    // update current_state register
    always@(posedge clk) begin
        if(!reset)
            current_state <= END_GAME_STATE;
        else
            current_state <= next_state;
    end
    
endmodule