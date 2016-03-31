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


