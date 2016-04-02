module control_vga_sim(
    input clk,
    input resetn,
    input go,
	
	
	
	output reg [3:0] pixel_count,
    output reg done,
	output reg plot
    );
	
	wire really_go;
	reg p_state;
	
	assign really_go = go;

    reg [5:0] current_state, next_state; 
    
    localparam  DRAWING_POINTER     = 5'd0,
                DRAWING_PLAYER   	= 5'd1,
				DONE				= 5'd2,
				STILL_DRAWING 		= 5'd3;

    
    // Next state logic aka our state table
	initial begin p_state = 1'b1; end
    always@(*)
    begin: state_table 
            case (current_state)
                DRAWING_POINTER: next_state = (done) ? DONE : DRAWING_POINTER; // Loop in current state until value is input
                DRAWING_PLAYER: next_state = (done) ? DONE :  STILL_DRAWING; // Loop in current state until go signal goes low
				STILL_DRAWING: next_state = (done) ? DONE : DRAWING_PLAYER;
				DONE: begin
						if (p_state && ~done)
							next_state = DRAWING_PLAYER;
						else if (~p_state && ~done)
							next_state = DRAWING_POINTER;
						else
							next_state = DONE;
					end
			default:     next_state = DONE;
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always @(*)
    begin: enable_signals
        // By default make all our signals 0
        /*ld_alu_out = 1'b0;
        ld_a = 1'b0;
        ld_b = 1'b0;
        ld_c = 1'b0;
        ld_x = 1'b0;
        ld_r = 1'b0;
        alu_select_a = 2'b0;
        alu_select_b = 2'b0;
        alu_op       = 1'b0; */

        case (current_state)
            DRAWING_PLAYER: begin
				if (pixel_count == 3'd4) begin
					done = 1'b1;
					pixel_count = 1'b0;
					plot = 1'b0; end
				else 
					plot = 1'b1;
					pixel_count = pixel_count + 1'b1;
					
                end
            DRAWING_POINTER: begin
				plot = 1'b0;
                end
            DONE: begin
				pixel_count = 1'b0;
				plot = 1'b1;
				end
			STILL_DRAWING: begin
				if (pixel_count == 3'd4) begin
					done = 1'b1;
					pixel_count = 1'b0; end
				plot = 1'b0;
                end          

        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(resetn)
            current_state <= DONE;
        else
            current_state <= next_state;
    end // state_FFS
	
	always@(posedge really_go)
    begin: point_or_player
		p_state =really_go;
		done = 1'b0;
		pixel_count = 1'b0;
		plot = 1'b1; 
	end
        
endmodule