module vertical_win(player_register, onoff_register, player, early_win1, early_win2wongame);
	input [6:0] player_register, onoff_register;
	input player, early_win1;
	output reg early_win, wongame;
	
	always @(*) begin
		if (player && ~early_win1) begin
			case(player_register)
				7'b0001111: begin wongame = 1'b1; early_win2 = 1'b1; end
				7'b0011110: begin wongame = 1'b1; early_win = 1'b1; end
				7'b0111100,7'b0111101: begin wongame = 1'b1; early_win2 = 1'b1; end
				default: begin wongame = 1'b0; early_win2 = 1'b0; end
			endcase
		end
		else begin
		case(player_register&& ~early_win1)
				7'b000000:  if (onoff_register == 6'b001111) begin wongame = 1'b1; early_win2 = 1'b1; end
							else begin wongame = 1'b0; early_win = 1'b0;end
				7'b000001:  if (onoff_register ==6'b011111) begin wongame = 1'b1; early_win2 = 1'b1; end
							else begin wongame = 1'b0; early_win = 1'b0;end
				7'b000010, 7'b000011:  if (onoff_register == 6'b111111) begin wongame = 1'b1; early_win2 = 1'b1; end
							else begin wongame = 1'b0; early_win2 = 1'b0;end
				default: begin wongame = 1'b0; early_win2 = 1'b0; end
			endcase
		end
	end
	
	
	//takes location, and adds upper 3 and lower 3
	
endmodule