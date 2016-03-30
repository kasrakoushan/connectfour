`include "mylog.v"

// modelsim testing (except for actual game calculation) complete
module logicunit(
    input reset, // active-high reset
    input [2:0] address,
    input [5:0] onoff_write, // new value in onoff board column
    input [5:0] player_write, // new value in player board column
    input go,
    
    output reg logic_result); // SHOULD THIS BE 1 BIT??
    
    // the registers holding the current game state
    reg [5:0] col0, col1, col2, col3, col4, col5, col6; // columns
    reg [2:0] h0, h1, h2, h3, h4, h5, h6; // heights
    
    wire [2:0] height; // output of mylog
    
    initial begin 
        // set columns to zero
        col0 = 6'b0; col1 = 6'b0; col2 = 6'b0; col3 = 6'b0;
        col4 = 6'b0; col5 = 6'b0; col6 = 6'b0; 
        // set heights of columns to zero
        h0 = 3'b0; h1 = 3'b0; h2 = 3'b0; h3 = 3'b0; h4 = 3'b0;
        h5 = 3'b0; h6 = 3'b0;
        // set logic_result
        logic_result = 1'b0; // game not over yet
    end
    
    mylog logheight(onoff_write, height); // translate inputted onoff column
    
    always @(*) begin
        // update game board with given inputs
        if (go) begin
            case (address)
                3'd0: begin 
                    col0 <= player_write;
                    h0 <= height;
                end
                3'd1: begin 
                    col1 <= player_write;
                    h1 <= height;
                end
                3'd2: begin 
                    col2 <= player_write;
                    h2 <= height;
                end
                3'd3: begin 
                    col3 <= player_write;
                    h3 <= height;
                end
                3'd4: begin 
                    col4 <= player_write;
                    h4 <= height;
                end
                3'd5: begin 
                    col5 <= player_write;
                    h5 <= height;
                end
                3'd6: begin 
                    col6 <= player_write;
                    h6 <= height;
                end
                // don't need a default
            endcase
        end
        
        // reset game board if reset is high
        if (reset) begin
            // update columns
            col0 <= 6'b0;
            col1 <= 6'b0;
            col2 <= 6'b0;
            col3 <= 6'b0;
            col4 <= 6'b0;
            col5 <= 6'b0;
            col6 <= 6'b0;
            // update heights
            h0 <= 3'b0;
            h1 <= 3'b0;
            h2 <= 3'b0;
            h3 <= 3'b0;
            h4 <= 3'b0;
            h5 <= 3'b0;
            h6 <= 3'b0;
        end
        // now conduct logic to set logic_result
        // for now will just leave it as zero
        // conduct a search from the most recent insertion location
        // i.e. at address input
    end
    
endmodule
