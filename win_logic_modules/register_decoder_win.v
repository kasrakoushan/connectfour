module register_decoder_win(player, location, height, player_register, onoff_register, vertical_register, 
						vertical_register_o, horizontal_register,  horizontal_register_o,
						dia_TL, dia_TR, dia_BL, dia_BR);
	input player;
	input [2:0] location, height;
	input [41:0] player_register, onoff_register;
	
	output [5:0] vertical_register,vertical_register_o;  
	output [6:0] horizontal_register, horizontal_register_o;
	output reg [2:0] dia_TL, dia_TR, dia_BL, dia_BR;
	
	//playerboard assignments (a 6 bit slice of playerboard) -VERTICALLY
	assign vertical_register[5] =player_register[(2'd2 ^location)-1]; 
	assign vertical_register[4] =player_register[(2'd2 ^location) ];
	assign vertical_register[3] =player_register[(2'd2 ^location) + 1];
	assign vertical_register[2] =player_register[(2'd2 ^location) + 2];
	assign vertical_register[1] =player_register[(2'd2 ^location) + 3];
	assign vertical_register[0] =player_register[(2'd2 ^location) + 4];
	
	//onoffboard assignments (a 6 bit slice of onoffboard) - VERTICALLY
	assign vertical_register_o[5] =onoff_register[(2'd2 ^location) - 1]; 
	assign vertical_register_o[4] =onoff_register[(2'd2 ^location) ];
	assign vertical_register_o[3] =onoff_register[(2'd2 ^location) + 1];
	assign vertical_register_o[2] =onoff_register[(2'd2 ^location) + 2];
	assign vertical_register_o[1] =onoff_register[(2'd2 ^location) + 3];
	assign vertical_register_o[0] =onoff_register[(2'd2 ^location) + 4];
	
	//playerboard assignments -HORIZONTALLY (MORE COMPLICATED)	
	assign horizontal_register[6] = player_register[( height)];
	assign horizontal_register[5] = player_register[(3'd6 *(1)) + (height) ];
	assign horizontal_register[4] = player_register[(3'd6 *(2)) + (height) ];
	assign horizontal_register[3] = player_register[(3'd6 *(3)) + (height) ];
	assign horizontal_register[2] = player_register[(3'd6 *(4)) + (height) ];
	assign horizontal_register[1] = player_register[(3'd6 *(5)) + (height) ];
	assign horizontal_register[0] = player_register[(3'd6 *(6)) + (height) ];
	
	assign horizontal_register_o[6] = onoff_register[( height)];
	assign horizontal_register_o[5] = onoff_register[(3'd6 *(1)) + (height) ];
	assign horizontal_register_o[4] = onoff_register[(3'd6 *(2)) + (height) ];
	assign horizontal_register_o[3] = onoff_register[(3'd6 *(3)) + (height) ];
	assign horizontal_register_o[2] = onoff_register[(3'd6 *(4)) + (height) ];
	assign horizontal_register_o[1] = onoff_register[(3'd6 *(5)) + (height) ];
	assign horizontal_register_o[0] = onoff_register[(3'd6 *(6)) + (height) ];
	
	
	//diagonal processes will return a triplet of all 1s iff the spot is occupied and has correct values
	
	
	always @(*) begin
	//TL assignment
	if (location > 2'd2 && height < 2'd3) begin	
		if (onoff_register[3'd6*(location-1'd1) + height + 1'd1]) dia_TL[0] = 
						player_register[3'd6*(location-1'd1) + height + 1'd1];
					else dia_TL[0] = ~player ;
		if (onoff_register[3'd6*(location-2'd2) + height + 2'd2]) dia_TL[1] = 
						player_register[3'd6*(location-2'd2) + height + 2'd2];
					else dia_TL[1] = ~player ;
		if (onoff_register[3'd6*(location-2'd3) + height + 2'd3]) dia_TL[2] = 
					player_register[3'd6*(location-2'd3) + height + 2'd3];
					else dia_TL[2] = ~player ;
		end
	else 
		dia_TL[0]= ~player;
		dia_TL[2]= ~player;
		dia_TL[1]= ~player;
		
	if (location < 3'd5 && height < 2'd3) begin	
		if (onoff_register[3'd6*(location+1'd1) + height + 1'd1]) dia_TR[0] = 
							player_register[3'd6*(location+1'd1) + height + 1'd1];
					else dia_TR[0] = ~player ;
		if (onoff_register[3'd6*(location+1'd1) + height + 1'd1]) dia_TR[1] = 
							player_register[3'd6*(location+2'd2) + height + 2'd2];
					else dia_TR[1] = ~player ; 
		if (onoff_register[3'd6*(location+1'd1) + height + 1'd1]) dia_TR[2] = 
							player_register[3'd6*(location+2'd3) + height + 2'd3];
					else dia_TR[2] = ~player;  
		end
	else 
		dia_TR[0]= ~player;
		dia_TR[2]= ~player;
		dia_TR[1]= ~player;
		
	if (location > 2'd2 && height > 2'd2) begin	
		if (onoff_register[3'd6*(location-1'd1) + height - 1'd1]) dia_BL[0] = 
						player_register[3'd6*(location-1'd1) + height - 1'd1];
					else dia_BL[0] = ~player;
		if (onoff_register[3'd6*(location-2'd2) + height - 2'd2]) dia_BL[1] = 
						player_register[3'd6*(location-2'd2) + height - 2'd2];
					else dia_BL[1] = ~player;
		if (onoff_register[3'd6*(location-2'd3) + height - 2'd3]) dia_BL[2] = 
						player_register[3'd6*(location-2'd3) + height - 2'd3];
					else dia_BL[2] = ~player;
		end
	else 
		dia_BL[0]= ~player;
		dia_BL[2]= ~player;
		dia_BL[1]= ~player;
		
	if (location > 3'd5 && height > 2'd2) begin	
		if (onoff_register[3'd6*(location+1'd1) + height - 1'd1]) dia_BR[0] = 
						player_register[3'd6*(location+1'd1) + height - 1'd1];
					else dia_BR[1] = ~player;
		if (onoff_register[3'd6*(location+2'd2) + height - 2'd2]) dia_BR[1] = 
						player_register[3'd6*(location+2'd2) + height - 2'd2];
					else dia_BR[1] = ~player;
		if (onoff_register[3'd6*(location+2'd3) + height - 2'd3]) dia_BR[2] = 
						player_register[3'd6*(location+2'd3) + height - 2'd3];
					else dia_BR[2] = ~player;
		end
	else 
		dia_BR[0]= ~player;
		dia_BR[2]= ~player;
		dia_BR[1]= ~player;
	
	end



endmodule