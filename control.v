module control (
	input clk,
	input actionComplete,
	input left,
	input right,
	input place,
	input resetn,
	input gameOver,
	input wCheckComplete,
	input [3:0] winner,
	input resetComplete,
	output reg winnerCheck,
	output reg [1:0] keyOut,
	output [6:0] HEX0,
	output [6:0] HEX1,
	output reg execute,
	output reg resetGame
	);

	reg [3:0] current_state, next_state; 
	reg [1:0] keyRead;
	reg isKeyRead;

	initial begin
		execute <= 0;
		keyOut <= 2'b00;
		winnerCheck <= 0;
		isKeyRead <= 0;
		resetGame <= 0;
		current_state <= 3'd0;
		next_state <= EXECUTE_RESET;
	end

	localparam  EXECUTE_RESET		= 4'd0,
				NO_KEY_READ    		= 4'd1,
				WINNER_CHECK		= 4'd3,
                WAIT_KEY_RELEASE	= 4'd5,
                EXECUTE_KEY        	= 4'd7,
				WAIT_RESET_RELEASE	= 4'd9,
				WAIT_FOR_RESET		= 4'd11,
				UPDATE_CURSOR		= 4'd15;

	always@(*)
    begin: state_table 
        case (current_state)
			NO_KEY_READ: 		begin
									if (!resetn) next_state = WAIT_RESET_RELEASE;
									else next_state = isKeyRead ? WAIT_KEY_RELEASE : NO_KEY_READ; 
								end
			WAIT_KEY_RELEASE: 	next_state = !isKeyRead ? EXECUTE_KEY : WAIT_KEY_RELEASE;
			EXECUTE_KEY: 		next_state = actionComplete ? ((keyOut == 2'b00) ? WINNER_CHECK : UPDATE_CURSOR) : EXECUTE_KEY;
			UPDATE_CURSOR:		next_state = EXECUTE_KEY;
			WINNER_CHECK: 		begin
									if (gameOver) next_state = WAIT_FOR_RESET;
									else next_state = wCheckComplete ? NO_KEY_READ : WINNER_CHECK;
								end
			WAIT_FOR_RESET: 	next_state = !resetn ? WAIT_RESET_RELEASE : WAIT_FOR_RESET;
			WAIT_RESET_RELEASE: next_state = resetn ? EXECUTE_RESET : WAIT_RESET_RELEASE;
			EXECUTE_RESET: 		next_state = resetComplete ? NO_KEY_READ : EXECUTE_RESET;
            default: next_state = EXECUTE_RESET;
        endcase
    end 

	hex hex_0(current_state[3], current_state[2], current_state[1], current_state[0]);
	hex hex_0r(winner[3], winner[2], winner[1], winner[0], HEX0);
	hex hex_1(winner[3], winner[2], winner[1], winner[0], HEX1);

	always@(*)
	begin
		execute = 0;
		winnerCheck = 0;
		isKeyRead = 0;
		resetGame = 0;

		case (current_state)
			NO_KEY_READ: begin
				if (!left && right && !place) begin
					keyRead = 2'b01;
					isKeyRead = 1;
				end
				else if (left && !right && !place) begin
					keyRead = 2'b10;
					isKeyRead = 1;
				end
				else if (!left && !right && place) begin
					keyRead = 2'b11;
					isKeyRead = 1;
				end
			end
			WAIT_KEY_RELEASE: begin
				if (!left && !right && !place) begin
					keyOut = keyRead;
				end
				else isKeyRead = 1;
			end
			EXECUTE_KEY: begin
				execute = 1;
			end
			UPDATE_CURSOR: begin
				keyOut = 2'b00;
			end
			WINNER_CHECK: begin
				keyOut = 2'b00;
				execute = 1;
				winnerCheck = 1;
			end
			EXECUTE_RESET: begin
				resetGame = 1;
				keyOut = 2'b00;
				execute = 1;
			end
		endcase
	end

	always@(posedge clk) current_state <= next_state;
endmodule