 /*
Some notes:
- will need to make sure memory reset works properly
*/
module myfsm(
    input clk,
    input play, // comes from a key
    input reset, // active-low
    input valid_input, // decoder output: whether switch input was valid
    input write_to_board, // result from move validator
    input logic_result, // result from game logic unit
    input [2:0] decoder_addr, // address from decoder
    input [5:0] validator_write_onoff, // write value from validator
    input [5:0] validator_write_player, // write value from validator
    
    output reg cur_player, // current player
    output reg game_finished, // whether game is finished (useful for VGA)
    output reg logic_go, // command to game logic unit
    output reg logic_reset, // command to tell logic to reset (active high)
    output reg [2:0] mem_address, // memory address to write to
    output reg [5:0] write_to_onoff, // value to write to logic unit
    output reg [5:0] write_to_player, // value to write to logic unit
    output reg vga_go, // go signal for VGA - 0 or 1
    output reg [5:0] onoff_to_validator, // output to validator
    output reg [5:0] player_to_validator // output to validator
    );
    
    reg [2:0] current_state, next_state;
    reg next_turn; // this will block until the play button is released
    reg [41:0] onoff_board;
    reg [41:0] player_board;
    
    
    integer index; // initialize index for memory reset loop
    
    localparam  WAIT_INPUT          = 3'd0, // wait for input
                UPDATE_GAME         = 3'd1, // update the game state
                CHECK_WINNER        = 3'd2, // check for a winner
                END_GAME_STATE      = 3'd3, // wait for restart
                
                // OUTPUTS OF WIN LOGIC UNIT
                LOGIC_OVER          = 1'b1, // game is over
                LOGIC_NOTOVER       = 1'b0; // game is not over
                // might not need these signals
		// just send everything to logic unit
                
    initial begin
        cur_player = 1'b0; // initialize cur_player to 0
        game_finished = 1'b0; // game is not over
        current_state = WAIT_INPUT; // set initial state
        next_turn = 1'b1; // move forward initially
	onoff_board = 42'd0; // initialize board to zero
	player_board = 42'd0; // initialize board to zero
    end
                
    // state table
    always @(posedge clk, negedge play) begin
        case (current_state)
            // wait until play is pressed, then change to CHECK_INPUT
            WAIT_INPUT: begin
		if (next_turn) begin
		  // potential source of bugs: write_to_board might not be properly updated yet
		  if (valid_input && write_to_board)
		      next_state = !play ? UPDATE_GAME: WAIT_INPUT;
		  else
		      next_state = WAIT_INPUT;
		end
            end
            
            // change to the CHECK_WINNER state
            UPDATE_GAME: next_state = CHECK_WINNER;
            
            // check game state provided by logic unit
            CHECK_WINNER: begin
                if (logic_result)
		    next_state = END_GAME_STATE;
		else begin
			cur_player = !cur_player;
			next_state = WAIT_INPUT;
		end
            end
                
            // wait until play is pressed, then change to WAIT_INPUT
            END_GAME_STATE: next_state = !play ? WAIT_INPUT: END_GAME_STATE;
            
            // by default, go to END_GAME_STATE state
            // should not reach this
            default: next_state = END_GAME_STATE;
        endcase
    end
    
    // datapath signals
    always @(posedge clk, negedge play) begin
        // by default make signals zero
        logic_go <= 1'b0;
        logic_reset <= 1'b0;
        mem_address <= decoder_addr;
	vga_go <= 1'b0;
	// modify outputs to validator
	case (decoder_addr)
		    3'd0: begin
			onoff_to_validator <= onoff_board[5:0];
			player_to_validator <= player_board[5:0];
		    end
		    3'd1: begin
			onoff_to_validator <= onoff_board[11:6];
			player_to_validator <= player_board[11:6];
		    end
		    3'd2: begin
			onoff_to_validator <= onoff_board[17:12];
			player_to_validator <= player_board[17:12];
		    end
		    3'd3: begin
			onoff_to_validator <= onoff_board[23:18];
			player_to_validator <= player_board[23:18];
		    end
		    3'd4: begin
			onoff_to_validator <= onoff_board[29:24];
			player_to_validator <= player_board[29:24];
		    end
		    3'd5: begin
			onoff_to_validator <= onoff_board[35:30];
			player_to_validator <= player_board[35:30];
		    end
		    3'd6: begin
			onoff_to_validator <= onoff_board[41:36];
			player_to_validator <= player_board[41:36];
		    end
		endcase
        
        case (current_state)
            // change player, enable writing to game boards
            UPDATE_GAME: begin
                // update register with value from validator
		case (mem_address)
		    3'd0: begin
			onoff_board[5:0] <= validator_write_onoff;
			player_board[5:0] <= validator_write_player;
		    end
		    3'd1: begin
			onoff_board[11:6] <= validator_write_onoff;
			player_board[11:6] <= validator_write_player;
		    end
		    3'd2: begin
			onoff_board[17:12] <= validator_write_onoff;
			player_board[17:12] <= validator_write_player;
		    end
		    3'd3: begin
			onoff_board[23:18] <= validator_write_onoff;
			player_board[23:18] <= validator_write_player;
		    end
		    3'd4: begin
			onoff_board[29:24] <= validator_write_onoff;
			player_board[29:24] <= validator_write_player;
		    end
		    3'd5: begin
			onoff_board[35:30] <= validator_write_onoff;
			player_board[35:30] <= validator_write_player;
		    end
		    3'd6: begin
			onoff_board[41:36] <= validator_write_onoff;
			player_board[41:36] <= validator_write_player;
		    end
		endcase
                write_to_onoff <= validator_write_onoff;
                write_to_player <= validator_write_player;
		logic_go <= 1'b1; // also write to logic unit
		next_turn <= 1'b0;
		vga_go <= 1'b1;
            end
            
            // enable game logic unit
            CHECK_WINNER: begin
                // logic unit should already have result; nothing to do?
            end
            
            // set cur_player to 0
            // wait for play button to reset game boards
            END_GAME_STATE: begin
                cur_player <= 1'b0;
                game_finished <= 1'b1;
                logic_reset <= 1'b1;
                if (play) begin
		    onoff_board <= 42'd0;
		    player_board <= 42'd0;
		end
            end
            
            // should not need a default
        endcase
    end
    
    // only change from WAIT_INPUT to CHECK_INPUT once play button has been released
    always @(posedge play) begin
	next_turn <= 1'b1;
    end
        
    
    // update current_state register
    always@(posedge clk) begin
        if(!reset) begin
            current_state <= END_GAME_STATE;
	    game_finished <= 1'b0; // game is set back to being not over
	end
        else
            current_state <= next_state;
    end
    
endmodule