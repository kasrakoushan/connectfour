module vga_top(
	input [2:0] KEY, //will serve as clock for now, go, resetn
	input [1:0] SW, //so far just to specify player
	
	output [9:0] VGA_R,
	output [9:0] VGA_G,
	output [9:0] VGA_B,
	output VGA_HS,
	output VGA_VS,
	output VGA_BLANK,
	output VGA_SYNC,
	output VGA_CLK,
	
	wire clock = KEY[0],
	wire resetn = KEY[1]
	wire player = SW[0],
	wire go = SW[1],
	wire [3:0] pixel_count,
	wire done, plot, 
	wire [7:0] new_x, new_y
	
	wire [2:0], decoded_height, location
	
	);
	
	assign decoded_height = 2'd3;
	assign location = 2'd3;	

);

controller control(clk, resetn, go, pixel_count, done plot);
datapather datapath_vga(clk, resetn, pixel_count, decoded_height, location, go, new_x, new_y, colour);
actual_vga vga_adapter(
resetn, clock, new_x,new_y, plot,VGA_R, VGA_G, 
VGA_B, VGA_HS, VGA_VS, VGA_BLANK, 
VGA_SYNC, VGA_CLK);




endmodule

module control(
    input clk,
    input resetn,
    input go,
	
	wire really_go;
	
	output reg [3:0] pixel_count,
    output done;
	output plot;
    );
	
	assign really_go = go;

    reg [5:0] current_state, next_state; 
    
    localparam  DRAWING_POINTER     = 5'd0,
                DRAWING_PLAYER   	= 5'd1,
				DONE				= 5'd2;

    
    // Next state logic aka our state table
    always@(*)
    begin: state_table 
            case (current_state)
                DRAWING_POINTER: next_state = (done) ? DONE : DRAWING_POINTER; // Loop in current state until value is input
                DRAWING_PLAYER: next_state = (done) ? DONE :  DRAWING_PLAYER; // Loop in current state until go signal goes low
				DONE: next_state = (go and ~done) ? DRAWING_PLAYER: DONE;
						if (go and ~done)
							next_state = DRAWING_PLAYER;
						else if (~go and ~done)
							next_state = DRAWING_POINTER;
						else
							next_state = DONE;
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
				if (pixel_count == 4'd15)
					done = 1'b1;
					pixel_count = 1'b0;
					plot = 1'b1
				else
					pixel_count = pixel_count + 1'b1;
                end
            DRAWING_POINTER: begin
				plot = 1'b0
                end
            DONE: begin
				plot = 1'b0
                end          

        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
    end // enable_signals
   
    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(!resetn)
            current_state <= DONE;
        else
            current_state <= next_state;
    end // state_FFS
	always@(posedge go, negedge go)
    begin: point_or_player
        done = 0;
    end // state_FFS
endmodule

module datapath(
    clk, resetn, pixel_count, decoded_height, location, go, new_x, new_y, colour
    );
    
	input clk,
    input resetn,
    input [3:0] pixel_count, //determines x and y shifts
    input [2:0] decoded_height, //a sequence of ones decoded to be 0-5 height value
    input [2:0] location, //a 0-6 number representing column value
    input go, //the actual load key from the player
	input player, //just the player's 0 or 1 value
    output reg [8:0] new_x, new_y //big, actual locations for the vga to get and plot
    output [2:0] colour,
	localparam  grid_length     = 5'd2,
                block_length   	= 5'd4;
				
	assign colour[2] = 1'b1;
	assign colour[1] = player;
	assign colour[0] = 1'b0;
	
    // Registers a, b, c, x with respective input logic
    always@(posedge clk) begin
        if(~go) begin
            new_y = pixel_count[3:2] + 7'd128;
			new_x = pixel_count[1:0] + (location + 1'b1) * grid_length + location * block_length;
        end
        else begin
            new_x = pixel_count[1:0] + (location + 1'b1) * grid_length + location * block_length;
			new_y = pixel_count[3:2] + (decoded_height + 1'b1) * grid_length + decoded_height * block_length;
        end
    end
    
endmodule