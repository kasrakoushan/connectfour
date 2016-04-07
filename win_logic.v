//logic module

module win_logic(location,height, player_register, onoff_register, player, wongame);
	input [2:0] location, height;
	input [41:0] player_register, onoff_register;
	input player;
	output wongame;
	
	wire [2:0]early_win;
	wire [5:0] vertical_register,vertical_register_o;  
	wire [6:0] horizontal_register, horizontal_register_o;
	wire [2:0] dia_TL, dia_TR, dia_BL, dia_BR;
	assign early_win[0] = 0;
	
	register_decoder_win(player, location, height, player_register, onoff_register, vertical_register, 
						vertical_register_o, horizontal_register,  horizontal_register_o,
						dia_TL, dia_TR, dia_BL, dia_BR)
	
	vertical_win vwin(vertical_register, vertical_register_o, player, early_win[0], early_win[1],wongame);
	horizontal_register_win hwin(horizontal_register, horizontal_register_o, player, early_win[1], early_win[2],wongame);;
	diagonal_win dwin(location, height, player_register, onoff_register, player, early_win[2], wongame);

endmodule

