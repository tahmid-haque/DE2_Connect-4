module datapath (
	input clk,
	input [1:0] keyRead,
	input execute,
	input resetGame,
	input manual,
	input [5:0] manualAddress,
	input winnerCheck,
	output writeEn,
	output reg actionComplete,
	output [2:0] colour_out,
	output [7:0] x_out,
	output [6:0] y_out,
	output gameOver,
	output wCheckComplete,
	output reg resetComplete,
	output [3:0] winnerOut,
	output [6:0] HEX2,
	output [6:0] HEX3,
	output [6:0] HEX4,
	output [6:0] HEX5,
	output [6:0] HEX6,
	output [17:0] LEDR,
	output [8:0] LEDG
	);

	reg [5:0] address, counter;
	reg [2:0] column, row;
	reg	[1:0] data;
	reg player, drawEnable, wren, isKeyRead, init, findAddress, colFull, isQSent, rewriteCursor;
	wire drawComplete;
	wire [1:0] q;

	initial begin
		row <= 3'd6;
		drawEnable <= 0;
		address <= (row * 3'd7) + column;
		counter <= 6'd0;
		data <= 2'b01;
		wren <= 0;
		findAddress <= 0;
		actionComplete <= 0;
		resetComplete <= 0;
		isKeyRead <= 0;
		column <= 3'd0;
		player <= 0;
		init <= 0;
		isQSent <= 0;
		colFull <= 0;
		rewriteCursor <= 0;
	end

	draw dr0(.clk(clk), 
			 .column(column), 
			 .row(row), 
			 .enable(drawEnable),
			 .player(player),
			 .resetGame(resetGame),
			 .writeEn(writeEn),
			 .x_out(x_out), 
			 .y_out(y_out),
			 .colour_out(colour_out), 
			 .drawComplete(drawComplete));

	ramRW rw(.clk(clk),	
			 .winnerCheck(winnerCheck),
			 .extAddress(address),
			 .data(data),
			 .wren(wren),
			 .resetGame(resetGame),
			 .manual(manual),
			 .manualAddress(manualAddress),
			 .q(q),
			 .gameOver(gameOver),
			 .wCheckComplete(wCheckComplete),
			 .winnerOut(winnerOut),
			 .HEX2(HEX2),
			 .HEX3(HEX3),
			 .HEX4(HEX4),
			 .HEX5(HEX5));

	led_sequencer l0(.clk(clk),
					 .gameOver(gameOver),
					 .LEDR(LEDR),
					 .LEDG(LEDG));

	hex hex_6(1'b0, 1'b0, q[1], q[0]);
	hex hex_6r(winnerOut[3], winnerOut[2], winnerOut[1], winnerOut[0], HEX6);

	always @(posedge clk) begin
		if (execute) begin
			if (!isKeyRead) begin
				case (keyRead)
					2'b00:  begin
								isKeyRead <= 1;
								row <= 3'd0;
								drawEnable <= 1;
							end
					2'b01:	begin
								if (column != 3'd6) column <= column + 3'd1;
								else column <= 3'd0;
								isKeyRead <= 1;
								row <= 3'd0;
								drawEnable <= 1;
							end
					2'b10: 	begin
								if (column != 3'd0) column <= column - 3'd1;
								else column <= 3'd6;
								isKeyRead <= 1;
								row <= 3'd0;
								drawEnable <= 1;
							end
					2'b11:	findAddress <= 1;
				endcase
			end
			
			if (findAddress) begin
				if (!isQSent) begin
					isQSent <= 1;
				end
				else if (q == 2'b00) begin
					wren <= 1;
					isKeyRead <= 1;
					drawEnable <= 1;
					findAddress <= 0;
					isQSent <= 0;
				end
				else begin
					if (row > 3'd1) begin
						row <= row - 3'd1;
						address <= ((row - 3'd1) * 3'd7) + column;
						isQSent <= 0;
					end
					else colFull <= 1;
				end
			end

			if (resetGame) begin
				if (!init) begin // prepares the variables to use for reseting
					address <= 6'd0;
					counter <= 6'd0;
					wren <= 1;
					data <= 2'b00;
					init <= 1;
				end
				else begin
					if (counter != 6'd63) begin
// resets all memeory addresses of the ram
						address <= counter;
						counter <= counter + 6'd1;
						wren <= 1;
						data <= 2'b00;
						row <= 3'd0;
						column <= 3'd0;
					end
					else begin
						if (drawComplete && drawEnable) 
// resets the board image by drawing white blocks over the colored blocks
begin
							drawEnable <= 0;
							if (column == 3'd6) begin
								if (row == 3'd7) resetComplete <= 1;
								else begin 
									column <= 3'd0;
									row <= row + 3'd1;
								end
							end
							else begin
								column <= column + 3'd1;
							end
						end
						else begin
							drawEnable <= 1;
						end
					end
				end
			end
			else if (drawComplete || colFull) begin // reset variables
				if (wren) player <= !player;
				actionComplete <= 1;
				drawEnable <= 0;
				if (resetGame) resetComplete <= 1;
				wren <= 0;
				findAddress <= 0;
				colFull <= 0;
			end
		end
		else begin // reset variables
			row <= 3'd6;
			drawEnable <= 0;
			address <= (row * 3'd7) + {3'b000, column};
			counter <= 6'd7;
			data <= {1'b0, player} + 2'b01;
			wren <= 0;
			actionComplete <= 0;
			resetComplete <= 0;
			isKeyRead <= 0;
			init <= 0;
			findAddress <= 0;
			colFull <= 0;
			rewriteCursor <= 0;
		end
	end
endmodule