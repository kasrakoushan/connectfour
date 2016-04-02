module find_vga_row(
    input [5:0] onoff_val, 
    output [2:0] vga_row);
    
    /* set vga_row to be the value of the row to put in the most
    recent piece 
    top row is 0
    bottom row is 5 */
    always @(*) begin
        case (num)
            6'b000001: vga_row = 3'd0;
            6'b000011: vga_row = 3'd1;
            6'b000111: vga_row = 3'd2;
            6'b001111: vga_row = 3'd3;
            6'b011111: vga_row = 3'd4;
            6'b111111: vga_row = 3'd5;
            default: vga_row = 3'd0;
        endcase
    end
    
    
endmodule