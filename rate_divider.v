module rate_divider(speed, clk, clear_b, enable);
	input clk, clear_b;
	input [1:0] speed;
	output enable;
	
	reg [27:0] rate;
	
	always @(posedge clk) 
	begin
		if (clear_b == 1'b0) 		
			rate <= 0; 
		else if (rate == 0)
			case(speed[1:0])	
				2'b00: rate <= 0;					
				2'b01: rate <= 49999999;				
				2'b10: rate <= 2777777;
				2'b11: rate <= 6249999;				
			endcase
		else 	
			rate <= rate - 1'b1;
	end
	assign enable = (rate == 0) ? 1 : 0;
endmodule