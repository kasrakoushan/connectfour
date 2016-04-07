//logic module

module win_logic(location,height, player_register, onoff_register, player, wongame);
	input [2:0] location, height;
	input [41:0] player_register, onoff_register;
	input player;
	output wongame;
	
	wire early_win;
	assign early_win = 0;
	
	vertical_win vwin(location, height, player_register, onoff_register, player, early_win, wongame);
	horizontal_win hwin(location, height, player_register, onoff_register, player, early_win, wongame);
	diagonal_win dwin(location, height, player_register, onoff_register, player, early_win, wongame);

endmodule

module vertical_win(location, height, early_win, wongame);
	input [2:0] location, height;
	output early_win, wongame;
	//takes location, and adds upper 3 and lower 3
	
endmodule;