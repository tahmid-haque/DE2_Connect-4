module draw (
	input clk,
	input [2:0] column,
	input [2:0] row,
	input enable,
	input player,
	input resetGame,
	output reg writeEn,
	output [7:0] x_out,
	output [6:0] y_out,
	output [2:0] colour_out,
	output reg drawComplete
	);

	reg [7:0] x, x_offset, x_limit;
	reg [6:0] y, y_offset, y_limit;
	reg [2:0] colour;
	reg isFirstDrawn, init;

	initial begin
		x <= 8'd25;
		y <= 7'd10;
		x_offset <= 8'd0;
		y_offset <= 7'd0;
		x_limit <= 8'd14;
		y_limit <= 7'd14;
		drawComplete <= 0;
		isFirstDrawn <= 0;
		init <= 0;
		writeEn <= 0;
	end

	always @(posedge clk) begin
		if (enable) begin
			if (!init) begin
				init <= 1;
				if (row == 3'd0) begin
					x_limit <= 8'd110;
					x <= 8'd25;
				end
				else begin
					x <= 8'd25 + (5'd16 * {2'b0, column});
					x_limit <= 8'd14;
				end
				y <= 7'd10 + (5'd16 * {2'b0, row});
				x_offset <= 8'd0;
				y_offset <= 7'd0;
				y_limit <= 7'd14;
				drawComplete <= 0;
				isFirstDrawn <= 0;
				writeEn <= 1;
			end
			else if (x_offset == x_limit) begin
				if (y_offset == y_limit) begin
					if (row == 3'd0 && !isFirstDrawn) begin	
						x <= 8'd25 + (5'd16 * {2'b0, column});
						x_limit <= 8'd14;
						x_offset <= 8'd0;
						isFirstDrawn <= 1;
					end
					else drawComplete <= 1;
					y_offset <= 7'd0;
				end
				else begin
					y_offset <= y_offset + 7'd1;
				end
				x_offset <= 8'd0;
			end
			else begin
				x_offset <= x_offset + 8'd1;
			end
		end
		else begin 
			x <= 8'd25 + (5'd16 * {2'b0, column});
			y <= 7'd10 + (5'd16 * {2'b0, row});
			x_offset <= 8'd0;
			y_offset <= 7'd0;
			x_limit <= 8'd14;
			y_limit <= 7'd14;
			drawComplete <= 0;
			isFirstDrawn <= 0;
			init <= 0;
			writeEn <= 0;
		end
	end

	always @(*) begin
		if (row == 3'd0 && !isFirstDrawn) colour <= 3'b111;
		else if (row == 3'd0 || !resetGame) colour <= player ? 3'b100 : 3'b110;
		else if (resetGame) colour <= 3'b111;
	end

	assign x_out = x + x_offset;
	assign y_out = y + y_offset;
	assign colour_out = colour;
endmodule