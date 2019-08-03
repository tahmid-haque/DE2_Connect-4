module led_sequencer(
    input clk,
    input gameOver,
    output [17:0] LEDR,
    output [8:0] LEDG
    );

    wire redClk, greenClk;
    reg [17:0] red;
    reg [7:0] green;
    reg oppositeRed, oppositeGreen;

    rate_divider rd1(.speed(2'b10),
					 .clk(clk),
					 .clear_b(1'b1),
					 .enable(redClk));
    
    rate_divider rd2(.speed(2'b11),
					 .clk(clk),
					 .clear_b(1'b1),
					 .enable(greenClk));

    always @(posedge redClk) begin
        if (gameOver) begin
            if (!oppositeRed) begin
                red <= red >> 18'd1;
                if (red == 18'b000000000000000010) oppositeRed <= 1;
            end
            else begin
                red <= red << 18'd1;
                if (red == 18'b010000000000000000) oppositeRed <= 0;
            end
        end
        else begin 
            red <= 18'b100000000000000000;
            oppositeRed <= 0;
        end
    end  

    always @(posedge greenClk) begin
        if (gameOver) begin
            if (!oppositeGreen) begin
                green <= green << 18'd1;
                if (green == 8'b01000000) oppositeGreen <= 1;
            end
            else begin
                green <= green >> 18'd1;
                if (green == 8'b00000010) oppositeGreen <= 0;
            end
        end
        else begin 
            green <= 8'b00000001;
            oppositeGreen <= 0;
        end
    end   

    //assign LEDR[17:0] = gameOver ? 18'b111111111111111111 : 18'd0;
    //assign LEDG[7:0] = gameOver ? 8'd0 : 8'b11111111;
    assign LEDR[17:0] = gameOver ? red : 18'd0;
    assign LEDG[7:0] = gameOver ? green : 8'd0;
    assign LEDG[8] = gameOver;

endmodule