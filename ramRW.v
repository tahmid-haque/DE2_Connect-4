module ramRW (
	input clk,
	input winnerCheck,
	input [5:0] extAddress,
	input [1:0] data,
	input wren,
    input resetGame,
    input manual,
    input [5:0] manualAddress,
	output [1:0] q,
    output reg gameOver,
    output reg wCheckComplete,
    output reg [3:0] winnerOut,
    output [6:0] HEX2,
	output [6:0] HEX3,
    output [6:0] HEX4,
    output [6:0] HEX5
	);

    reg [6:0] counter, debugCounter;
    reg [5:0] a1, a2, a3, a4, address, localAdd;
	reg [1:0] a, b, c, d, wPlayer, ldCount, isQRead;
	reg ldComplete, checkFull;

	ram r0(.address(address), .clock(clk), .data(data), .wren(wren), .q(q));
            
    initial begin // initializes the variables
        a <= 2'b00;
        b <= 2'b00;
        c <= 2'b00;
        d <= 2'b00;
        gameOver <= 0;
        wCheckComplete <= 0;
        winnerOut <= 4'd0;
        wPlayer <= 2'b01;
        localAdd <= 6'h7;
        a1 <= 7'd63;
        a2 <= 7'd63;
        a3 <= 7'd63;
        a4 <= 7'd63;
        ldCount <= 2'b00;
        counter <= 7'd0;
        ldComplete <= 0;
        checkFull <= 0;
        isQRead <= 2'b00;
    end
    
	always @(posedge clk) begin
		// hard coded to detet a 4 in a row, column or diagonal by loading in the addresses into a1, a2, a3, a4
		if (winnerCheck) begin
            case (counter)
                7'd0: begin
							 	a1 <= 6'h7;
								a2 <= 6'h8;
								a3 <= 6'h9;
								a4 <= 6'ha;
								end
                7'd1: begin
							 	a1 <= 6'h8;
								a2 <= 6'h9;
								a3 <= 6'ha;
								a4 <= 6'hb;
								end
                7'd2: begin
							 	a1 <= 6'h9;
								a2 <= 6'ha;
								a3 <= 6'hb;
								a4 <= 6'hc;
								end
                7'd3: begin
							 	a1 <= 6'ha;
								a2 <= 6'hb;
								a3 <= 6'hc;
								a4 <= 6'hd;
								end

                7'd4: begin
							 	a1 <= 6'he;
								a2 <= 6'hf;
								a3 <= 6'h10;
								a4 <= 6'h11;
								end
                7'd5: begin
							 	a1 <= 6'hf;
								a2 <= 6'h10;
								a3 <= 6'h11;
								a4 <= 6'h12;
								end
                7'd6: begin
							 	a1 <= 6'h10;
								a2 <= 6'h11;
								a3 <= 6'h12;
								a4 <= 6'h13;
								end
                7'd7: begin
							 	a1 <= 6'h11;
								a2 <= 6'h12;
								a3 <= 6'h13;
								a4 <= 6'h14;
								end

                7'd8: begin
							 	a1 <= 6'h15;
								a2 <= 6'h16;
								a3 <= 6'h17;
								a4 <= 6'h18;
								end
                7'd9: begin
							 	a1 <= 6'h16;
								a2 <= 6'h17;
								a3 <= 6'h18;
								a4 <= 6'h19;
								end
                7'd10: begin
							 	a1 <= 6'h17;
								a2 <= 6'h18;
								a3 <= 6'h19;
								a4 <= 6'h1a;
								end
                7'd11: begin
							 	a1 <= 6'h18;
								a2 <= 6'h19;
								a3 <= 6'h1a;
								a4 <= 6'h1b;
								end

                7'd12: begin
							 	a1 <= 6'h1c;
								a2 <= 6'h1d;
								a3 <= 6'h1e;
								a4 <= 6'h1f;
								end
                7'd13: begin
							 	a1 <= 6'h1d;
								a2 <= 6'h1e;
								a3 <= 6'h1f;
								a4 <= 6'h20;
								end
                7'd14: begin
							 	a1 <= 6'h1e;
								a2 <= 6'h1f;
								a3 <= 6'h20;
								a4 <= 6'h21;
								end
                7'd15: begin
							 	a1 <= 6'h1f;
								a2 <= 6'h20;
								a3 <= 6'h21;
								a4 <= 6'h22;
								end

                7'd16: begin
							 	a1 <= 6'h23;
								a2 <= 6'h24;
								a3 <= 6'h25;
								a4 <= 6'h26;
								end
                7'd17: begin
							 	a1 <= 6'h24;
								a2 <= 6'h25;
								a3 <= 6'h26;
								a4 <= 6'h27;
								end
                7'd18: begin
							 	a1 <= 6'h25;
								a2 <= 6'h26;
								a3 <= 6'h27;
								a4 <= 6'h28;
								end
                7'd19: begin
							 	a1 <= 6'h26;
								a2 <= 6'h27;
								a3 <= 6'h28;
								a4 <= 6'h29;
								end

                7'd20: begin
							 	a1 <= 6'h2a;
								a2 <= 6'h2b;
								a3 <= 6'h2c;
								a4 <= 6'h2d;
								end
                7'd21: begin
							 	a1 <= 6'h2b;
								a2 <= 6'h2c;
								a3 <= 6'h2d;
								a4 <= 6'h2e;
								end
                7'd22: begin
							 	a1 <= 6'h2c;
								a2 <= 6'h2d;
								a3 <= 6'h2e;
								a4 <= 6'h2f;
								end
                7'd23: begin
							 	a1 <= 6'h2d;
								a2 <= 6'h2e;
								a3 <= 6'h2f;
								a4 <= 6'h30;
								end

                7'd24: begin
							 	a1 <= 6'h7;
								a2 <= 6'he;
								a3 <= 6'h15;
								a4 <= 6'h1c;
								end
                7'd25: begin
							 	a1 <= 6'h8;
								a2 <= 6'hf;
								a3 <= 6'h16;
								a4 <= 6'h1d;
								end
                7'd26: begin
							 	a1 <= 6'h9;
								a2 <= 6'h10;
								a3 <= 6'h17;
								a4 <= 6'h1e;
								end
                7'd27: begin
							 	a1 <= 6'ha;
								a2 <= 6'h11;
								a3 <= 6'h18;
								a4 <= 6'h1f;
								end
                7'd28: begin
							 	a1 <= 6'hb;
								a2 <= 6'h12;
								a3 <= 6'h19;
								a4 <= 6'h20;
								end
                7'd29: begin
							 	a1 <= 6'hc;
								a2 <= 6'h13;
								a3 <= 6'h1a;
								a4 <= 6'h21;
								end
                7'd30: begin
							 	a1 <= 6'hd;
								a2 <= 6'h14;
								a3 <= 6'h1b;
								a4 <= 6'h22;
								end

                7'd31: begin
							 	a1 <= 6'he;
								a2 <= 6'h15;
								a3 <= 6'h1c;
								a4 <= 6'h23;
								end
                7'd32: begin
							 	a1 <= 6'hf;
								a2 <= 6'h16;
								a3 <= 6'h1d;
								a4 <= 6'h24;
								end
                7'd33: begin
							 	a1 <= 6'h10;
								a2 <= 6'h17;
								a3 <= 6'h1e;
								a4 <= 6'h25;
								end
                7'd34: begin
							 	a1 <= 6'h11;
								a2 <= 6'h18;
								a3 <= 6'h1f;
								a4 <= 6'h26;
								end
                7'd35: begin
							 	a1 <= 6'h12;
								a2 <= 6'h19;
								a3 <= 6'h20;
								a4 <= 6'h27;
								end
                7'd36: begin
							 	a1 <= 6'h13;
								a2 <= 6'h1a;
								a3 <= 6'h21;
								a4 <= 6'h28;
								end
                7'd37: begin
							 	a1 <= 6'h14;
								a2 <= 6'h1b;
								a3 <= 6'h22;
								a4 <= 6'h29;
								end

                7'd38: begin
							 	a1 <= 6'h15;
								a2 <= 6'h1c;
								a3 <= 6'h23;
								a4 <= 6'h2a;
								end
                7'd39: begin
							 	a1 <= 6'h16;
								a2 <= 6'h1d;
								a3 <= 6'h24;
								a4 <= 6'h2b;
								end
                7'd40: begin
							 	a1 <= 6'h17;
								a2 <= 6'h1e;
								a3 <= 6'h25;
								a4 <= 6'h2c;
								end
                7'd41: begin
							 	a1 <= 6'h18;
								a2 <= 6'h1f;
								a3 <= 6'h26;
								a4 <= 6'h2d;
								end
                7'd42: begin
							 	a1 <= 6'h19;
								a2 <= 6'h20;
								a3 <= 6'h27;
								a4 <= 6'h2e;
								end
                7'd43: begin
							 	a1 <= 6'h1a;
								a2 <= 6'h21;
								a3 <= 6'h28;
								a4 <= 6'h2f;
								end
                7'd44: begin
							 	a1 <= 6'h1b;
								a2 <= 6'h22;
								a3 <= 6'h29;
								a4 <= 6'h30;
								end

                7'd45: begin
							 	a1 <= 6'ha;
								a2 <= 6'h10;
								a3 <= 6'h16;
								a4 <= 6'h1c;
								end
                7'd46: begin
							 	a1 <= 6'hb;
								a2 <= 6'h11;
								a3 <= 6'h17;
								a4 <= 6'h1d;
								end
                7'd47: begin
							 	a1 <= 6'hc;
								a2 <= 6'h12;
								a3 <= 6'h18;
								a4 <= 6'h1e;
								end
                7'd48: begin
							 	a1 <= 6'hd;
								a2 <= 6'h13;
								a3 <= 6'h19;
								a4 <= 6'h1f;
								end

                7'd49: begin
							 	a1 <= 6'h11;
								a2 <= 6'h17;
								a3 <= 6'h1d;
								a4 <= 6'h23;
								end
                7'd50: begin
							 	a1 <= 6'h12;
								a2 <= 6'h18;
								a3 <= 6'h1e;
								a4 <= 6'h24;
								end
                7'd51: begin
							 	a1 <= 6'h13;
								a2 <= 6'h19;
								a3 <= 6'h1f;
								a4 <= 6'h25;
								end
                7'd52: begin
							 	a1 <= 6'h14;
								a2 <= 6'h1a;
								a3 <= 6'h20;
								a4 <= 6'h26;
								end

                7'd53: begin
							 	a1 <= 6'h18;
								a2 <= 6'h1e;
								a3 <= 6'h24;
								a4 <= 6'h2a;
								end
                7'd54: begin
							 	a1 <= 6'h19;
								a2 <= 6'h1f;
								a3 <= 6'h25;
								a4 <= 6'h2b;
								end
                7'd55: begin
							 	a1 <= 6'h1a;
								a2 <= 6'h20;
								a3 <= 6'h26;
								a4 <= 6'h2c;
								end
                7'd56: begin
							 	a1 <= 6'h1b;
								a2 <= 6'h21;
								a3 <= 6'h27;
								a4 <= 6'h2d;
								end

                7'd57: begin
							 	a1 <= 6'h7;
								a2 <= 6'hf;
								a3 <= 6'h17;
								a4 <= 6'h1f;
								end
                7'd58: begin
							 	a1 <= 6'h8;
								a2 <= 6'h10;
								a3 <= 6'h18;
								a4 <= 6'h20;
								end
                7'd59: begin
							 	a1 <= 6'h9;
								a2 <= 6'h11;
								a3 <= 6'h19;
								a4 <= 6'h21;
								end
                7'd60: begin
							 	a1 <= 6'ha;
								a2 <= 6'h12;
								a3 <= 6'h1a;
								a4 <= 6'h22;
								end

                7'd61: begin
							 	a1 <= 6'he;
								a2 <= 6'h16;
								a3 <= 6'h1e;
								a4 <= 6'h26;
								end
                7'd62: begin
							 	a1 <= 6'hf;
								a2 <= 6'h17;
								a3 <= 6'h1f;
								a4 <= 6'h27;
								end
                7'd63: begin
							 	a1 <= 6'h10;
								a2 <= 6'h18;
								a3 <= 6'h20;
								a4 <= 6'h28;
								end
                7'd64: begin
							 	a1 <= 6'h11;
								a2 <= 6'h19;
								a3 <= 6'h21;
								a4 <= 6'h29;
								end

                7'd65: begin
							 	a1 <= 6'h15;
								a2 <= 6'h1d;
								a3 <= 6'h25;
								a4 <= 6'h2d;
								end
                7'd66: begin
							 	a1 <= 6'h16;
								a2 <= 6'h1e;
								a3 <= 6'h26;
								a4 <= 6'h2e;
								end
                7'd67: begin
							 	a1 <= 6'h17;
								a2 <= 6'h1f;
								a3 <= 6'h27;
								a4 <= 6'h2f;
								end
                7'd68: begin
							 	a1 <= 6'h18;
								a2 <= 6'h20;
								a3 <= 6'h28;
								a4 <= 6'h30;
								end
            endcase
            //loads the values into a, b, c, d from the addresses
		// a1, a2, a3, a4
            case (ldCount)
                2'b00:	begin
                            if (isQRead != 2'b11) begin
                                isQRead <= isQRead + 2'b01;
                                localAdd <= a1;
                            end
                            else begin
                                isQRead <= 2'b00;
                                a <= q;
                                localAdd <= a2;
                                ldCount <= 2'b01;
                            end
                        end
				2'b01:	begin
                            if (isQRead != 2'b11) begin
                                isQRead <= isQRead + 2'b01;
                                localAdd <= a2;
                            end
                            else begin
                                isQRead <= 2'b00;
                                b <= q;
                                localAdd <= a3;
                                ldCount <= 2'b10;
                            end
                        end
				2'b10:	begin
                            if (isQRead != 2'b11) begin
                                isQRead <= isQRead + 2'b01;
                                localAdd <= a3;
                            end
                            else begin
                                isQRead <= 2'b00;
                                c <= q;
                                localAdd <= a4;
                                ldCount <= 2'b11;
                            end
                        end
				2'b11:	begin
                            if (isQRead != 2'b11) begin
                                isQRead <= isQRead + 2'b01;
                                localAdd <= a4;
                            end
                            else begin
                                if (!checkFull) d <= q;
							    ldComplete <= 1;
                            end
						end
            endcase
// if abcd equal the same player, that player wins
            if (ldComplete) begin
				if (a == b && b == c && c == d && d == wPlayer) begin
                    wCheckComplete <= 1;
                    gameOver <= 1;
                    debugCounter <= counter;
                    if (wPlayer == 2'b01) winnerOut <= 4'd10;
                    else winnerOut <= 4'd11;
				end
//else resets the variables to do the same check for the next player
                else if (counter == 7'd68) begin                    
                    if (wPlayer == 2'b01) begin
                        localAdd <= a1;
                        wPlayer <= 2'b10;
                        counter <= 7'd0;
                        ldComplete <= 0;
                        isQRead <= 2'b00;
                        ldCount <= 2'd0;
                        a <= 2'b00;
                        b <= 2'b00;
                        c <= 2'b00;
                        d <= 2'b00;
                        a1 <= 7'd63;
                        a2 <= 7'd63;
                        a3 <= 7'd63;
                        a4 <= 7'd63;
                    end
// checks if all the blocks are filled for a tie
                    else begin
                        if (!checkFull) begin
                            localAdd <= 6'h7;
                            checkFull <= 1;
                        end
                        else if (q == 2'b00 && localAdd != 6'd49) begin
                            wCheckComplete <= 1;
                        end
                        else if (localAdd == 6'd49) begin
                            wCheckComplete <= 1;
                            winnerOut <= 4'd8;
                            gameOver <= 1;
                        end
                        else begin
                            localAdd <= localAdd + 6'd1;
                        end
                    end
                end
//resets variables
                else begin
                    counter <= counter + 7'd1;
                    ldComplete <= 0;
                    isQRead <= 2'b00;
                    ldCount <= 2'd0;
                    a <= 2'b00;
                    b <= 2'b00;
                    c <= 2'b00;
                    d <= 2'b00;
                    a1 <= 7'd63;
                    a2 <= 7'd63;
                    a3 <= 7'd63;
                    a4 <= 7'd63;
                    localAdd <= 7'd63;
                end
			end
        end
//resets variables
        else begin
            a <= 2'b00;
            b <= 2'b00;
            c <= 2'b00;
            d <= 2'b00;
            wPlayer <= 2'b01;
            isQRead <= 2'b00;
            wCheckComplete <= 0;
            localAdd <= a1;
            a1 <= 7'd63;
            a2 <= 7'd63;
            a3 <= 7'd63;
            a4 <= 7'd63;
            ldCount <= 2'b00;
            counter <= 7'd0;
            ldComplete <= 0;
            checkFull <= 0;
            if (!gameOver) winnerOut <= 4'd0;
        end
        if (resetGame) gameOver <= 0;
	end

	always @(*) begin
        if (manual) begin
            address = manualAddress; 
        end
		else if (winnerCheck) begin
			address = localAdd;
		end
		else begin
			address = extAddress;
		end
	end

    hex hex_2(debugCounter[3], debugCounter[2], debugCounter[1], debugCounter[0]);
    hex hex_3(1'b0, debugCounter[6], debugCounter[5], debugCounter[4]);
    hex hex_4(address[3], address[2], address[1], address[0]);
    hex hex_5(1'b0, 1'b0, address[5], address[4]);
	hex hex_2r(winnerOut[3], winnerOut[2], winnerOut[1], winnerOut[0], HEX2);
	hex hex_3r(winnerOut[3], winnerOut[2], winnerOut[1], winnerOut[0], HEX3);
	hex hex_4r(winnerOut[3], winnerOut[2], winnerOut[1], winnerOut[0], HEX4);
	hex hex_5r(winnerOut[3], winnerOut[2], winnerOut[1], winnerOut[0], HEX5);
endmodule