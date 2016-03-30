`include "mylog.v"

// modelsim testing complete
module movevalidator(
    input [5:0] onoff_data,
    input [5:0] player_data,
    // input go,
    input cur_player,
    
    output valid_move,
    output [5:0] write_onoff,
    output reg [5:0] write_player);
    
    // reg [2:0] height;
    wire [2:0] height;
    
    mylog heightnum(onoff_data, height);
    
    assign valid_move = onoff_data < 6'b111111; // must not be full
    assign write_onoff = (onoff_data << 1) + 1'b1; // shift left, add 1
    
    always @(*) begin
        if (cur_player) // cur_player is 1
            write_player = player_data + (6'b1 << height);
        else
            write_player = player_data; // do nothing
    end
    
endmodule
