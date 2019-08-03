module connect_4
	(
		CLOCK_50,						//	On Board 50 MHz
		// Your inputs and outputs here
		KEY,
		HEX0,
		HEX1,
		HEX2,
		HEX3,
		HEX4,
		HEX5,
		HEX6,
		SW,
		LEDR,
		LEDG,
		// The ports below are for the VGA output.  Do not change.
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
	);

	input CLOCK_50;				//	50 MHz
	input [3:0] KEY;
	input [17:0] SW;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6;
	output [8:0] LEDG;
	output [17:0] LEDR;

	// Declare your inputs and outputs here
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	assign resetn = KEY[0];
	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire writeEn;
	
	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "7x6grid.mif";
			
	// Put your code here. Your code should produce signals x,y,colour and writeEn/plot
	// for the VGA controller, in addition to any other functionality your design may require.
    wire right, left, place, execute, actionComplete, winnerCheck, gameOver, wCheckComplete, resetGame, resetComplete;
	wire [1:0] key;
	wire [3:0] winner;

	assign right = ~KEY[1];
	assign left = ~KEY[3];
	assign place = ~KEY[2];
	
	control c0(
		.clk(CLOCK_50),
		.actionComplete(actionComplete),
		.left(left),
		.right(right),
		.place(place),
		.resetn(resetn),
		.gameOver(gameOver),
		.wCheckComplete(wCheckComplete),
		.winner(winner),
		.resetComplete(resetComplete),
		.winnerCheck(winnerCheck),
		.keyOut(key),
		.HEX0(HEX0),
		.HEX1(HEX1),
		.execute(execute),
		.resetGame(resetGame)
		);

	datapath d0(
		.clk(CLOCK_50),
		.keyRead(key),
		.execute(execute),
		.resetGame(resetGame),
		.manual(SW[9]),
		.manualAddress(SW[5:0]),
		.winnerCheck(winnerCheck),
		.writeEn(writeEn),
		.actionComplete(actionComplete),
		.colour_out(colour),
		.x_out(x),
		.y_out(y),
		.gameOver(gameOver),
		.wCheckComplete(wCheckComplete),
		.resetComplete(resetComplete),
		.winnerOut(winner),
		.HEX2(HEX2),
		.HEX3(HEX3),
		.HEX4(HEX4),
		.HEX5(HEX5),
		.HEX6(HEX6),
		.LEDR(LEDR[17:0]),
		.LEDG(LEDG[8:0])
		);
endmodule