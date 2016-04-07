module horizontal_win(player_register, onoff_register, player, early_win1, early_win2, wongame);
	input [6:0] player_register, onoff_register; //snipped player and onoff board states
	input player, early_win1; //player, and a condition to allow win propagation
	output reg early_win2, wongame; //second win propagation condition, and actual won game value
	
	always @(*) begin
		if ~early_win1 begin //win propagation check
			if (player ) begin //player check, player 0 inverts 1s and 0s
				case(player_register) //finite number of states
					7'b0001111: begin wongame = 1'b1; early_win2 = 1'b1; end
					7'b0011110: begin wongame = 1'b1; early_win = 1'b1; end
					7'b0111100,7'b0111101: begin wongame = 1'b1; early_win2 = 1'b1; end
					default: begin wongame = 1'b0; early_win2 = 1'b0; end
				endcase
			end
			else begin
			case(player_register) //analog of above for 0 sequences
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
	else begin wongame = 0; early_win2 = 0; end //propagation of early win and won game
	end
	
	
endmodule