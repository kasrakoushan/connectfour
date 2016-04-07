module diagonal_win(player, location, height, early_win,dia_TL, dia_TR, dia_BL, dia_BR, won_game);
	input player;
	input [2:0] location, height;
	input early_win;
	input [2:0] dia_TL, dia_TR, dia_BL, dia_BR;
	
	output reg won_game;
	

	
	always @(*) begin
	 if (early_win) won_game = 1'b1;
	end
		
	always @(*) begin //if any diagonal set is 3 or 0 then 3 + 1 or 0 + 0 imply a diagonal
		if (player) begin
			if (dia_TL > 2'd2 || dia_TR> 2'd3 || dia_BL> 2'd3 || dia_BR > 2'd3)
				won_game = 1'b1;
			end
		else begin
			if (dia_TL < 2'd1 || dia_TR < 2'd1 || dia_BL < 2'd1 || dia_BR < 2'd1)
				won_game = 1'b1;
		end
	end

	always @(*) begin //checks case for 2 on one side, 1 on other
	
		if (player) begin 
			if (dia_TL[1:0] + dia_BR[0] == 2'd3 || dia_TR[1:0] + dia_BL[0] == 2'd3 || 
				dia_TL[0] + dia_BR[1:0] == 2'd3 || dia_TR[0] + dia_BR[1:0] == 2'd3)	
				won_game = 1'b1;
			
			end
		else begin
			if (dia_TL[1:0] + dia_BR[0] == 0 || dia_TR[1:0] + dia_BL[0] == 0 || 
				dia_TL[0] + dia_BR[1:0] == 0 || dia_TR[0] + dia_BR[1:0] == 0)	
				won_game = 1'b1;
		end
	
	end
	
		always @(*) begin //checks case for 2 on one side, 2 on other
	
		if (player) begin 
			if (dia_TL[1:0] + dia_BR[1:0] == 3'd6 || dia_TR[1:0] + dia_BL[1:0] == 3'd6 || 
				dia_TL[1:0] + dia_BR[1:0] == 3'd6 || dia_TR[1:0] + dia_BR[1:0] == 3'd6)	
				won_game = 1'b1;
			
			end
		else begin
			if (dia_TL[1:0] + dia_BR[1:0] == 0 || dia_TR[1:0] + dia_BL[1:0] == 0 || 
				dia_TL[1:0] + dia_BR[1:0] == 0 || dia_TR[1:0] + dia_BR[1:0] == 0)	
				won_game = 1'b1;
		end
	
	end
endmodule