module diagonal_win(player, location, height, early_win,dia_TL, dia_TR, dia_BL, dia_BR, won_game);
	input player;
	input [2:0] location, height;
	input early_win;
	input [2:0] dia_TL, dia_TR, dia_BL, dia_BR;
	
	output won_game;
	
	assign won_game = 0;
	
	always @(*) begin
	 if (early_win) won_game = 1'b1;
	end
		
	always @(*) begin //if any diagonal value is 3
		if (player) begin
			if (dia_TL > 2'd2 || dia_TR> 2'd3 || dia_BL> 2'd3 || dia_BR > 2'd3)
				won_game = 1'b1;
			end
		else begin
			if (dia_TL < 2'd1 || dia_TR < 2'd1 || dia_BL < 2'd1 || dia_BR < 2'd1)
				won_game = 1'b1;
		end
	end

	always @(*) begin
	
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
endmodule