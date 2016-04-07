module vga_top(
//IMPORTANT IMPORTANT IMPORTANT: CHANGE PIXELCOUNT == TO 4'D15 BEFORE RUNNING FOR REAL
	input [2:0] KEY0, //will serve as clock for now, resetn
	input [9:0] SW, //so far just to specify player, go
	
	
	output [9:0] VGA_R,
	output [9:0] VGA_G,
	output [9:0] VGA_B,
	output VGA_HS,
	output VGA_VS,
	output VGA_BLANK,
	output VGA_SYNC,
	output VGA_CLK
	
	
	
	);
	
	wire clk;
	wire resetn;
	wire player;
	wire [2:0] colour; 
	wire go;
	wire [3:0] pixel_count;
	wire done, plot; 
	wire [9:0] new_x, new_y;
	
	wire [2:0] decoded_height, location;
	
	assign clk = KEY0[0];
	assign resetn = KEY0[1];
	assign player = SW[0];
	assign go = SW[1]; 
	
	assign decoded_height = 1'b1;
	assign location = 1'b1;

control_vga control1(clk, resetn, go, pixel_count, done, plot);
datapath_vga datapath1(clk, pixel_count, decoded_height, location, go, player, new_x, new_y, colour);
/*vga_adapter actual_vga1(
resetn, clk, new_x,new_y, plot,VGA_R, VGA_G, 
VGA_B, VGA_HS, VGA_VS, VGA_BLANK, 
VGA_SYNC, VGA_CLK);
		 defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif"; */




endmodule

module control_vga(
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

        case (current_state)
            DRAWING_PLAYER: begin
				if (pixel_count == 4'd5 || pixel_count > 4'd5) begin
					done = 1'b1;
					pixel_count = 1'b0;
					plot = 1'b0; end
				else  begin
					plot = 1'b1;
					pixel_count = pixel_count + 1'b1;
					end
                end
            DRAWING_POINTER: begin
				plot = 1'b0;
                end
            DONE: begin
				plot = 1'b1;
				pixel_count = 1'b0;
				done = 1'b0;
				end
			STILL_DRAWING: begin 
				if (pixel_count == 4'd5 || pixel_count > 4'd5) begin
					done = 1'b1;
					pixel_count = 1'b0; end
				plot = 1'b0;
                end          

        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // POSSIBLE SOLUTION 1: do updating here? i think it doesn't like different places updating pixelcount etc
    always@(posedge clk) //, posedge really_go) 
    begin: state_FFs
        if(resetn)
            current_state <= DONE;
        else
            current_state <= next_state;
    end // state_FFS
	
	/* 	POSSIBLE SOLUTION 2: <= maybe? this unsure what the error even means
	always@(posedge really_go)
    begin: point_or_player
		p_state =really_go;
		done = 1'b0;
		pixel_count = 1'b0;
		plot = 1'b1; 
	end */
        
endmodule

module datapath_vga(
    clk, pixel_count, decoded_height, location, go, player, new_x, new_y, colour
    );
    
	input clk;
    input [3:0] pixel_count; //determines x and y shifts
    input [2:0] decoded_height; //a sequence of ones decoded to be 0-5 height value
    input [2:0] location; //a 0-6 number representing column value
    input go; //the actual load key from the player
	input player; //just the player's 0 or 1 value
    output reg [9:0] new_x, new_y; //big, actual locations for the vga to get and plot
    output [2:0] colour;
	localparam  grid_length     = 5'd2,
                block_length   	= 5'd4;
				
	assign colour[2] = 1'b1;
	assign colour[1] = player;
	assign colour[0] = 1'b0;
	
    // Registers a, b, c, x with respective input logic
    always@(posedge clk) begin
        if(~go) begin
            new_y = pixel_count[3:2] + 1'b1;
			new_x = pixel_count[1:0] + (location + 1'b1) * grid_length + location * block_length;
        end
        else begin
            new_x = pixel_count[1:0] + (location + 1'b1) * grid_length + location * block_length;
			new_y = pixel_count[3:2] + (decoded_height + 1'b1) * grid_length + decoded_height * block_length;
        end
    end
    
endmodule