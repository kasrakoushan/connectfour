// modelsim testing complete
module switchdecoder(
    input [6:0] switch, // take a one-hot encoding and produce a col number
    output reg [2:0] address,
    output valid_input);
    
    
    assign valid_input = ^ switch;
    always @(*) begin
        case (switch)
            7'b0000001: address = 3'd6;
            7'b0000010: address = 3'd5;
            7'b0000100: address = 3'd4;
            7'b0001000: address = 3'd3;
            7'b0010000: address = 3'd2;
            7'b0100000: address = 3'd1;
            7'b1000000: address = 3'd0;
            // should not need default
        endcase
    end
endmodule
