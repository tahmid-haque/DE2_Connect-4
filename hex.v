module hex(a, b, c, d, seg);	
	input a,b,c,d;
    output [6:0] seg;
	
	assign seg[0] = (~a & ~b & ~c & d) | (~a & b & ~c & ~d) | (a & ~b & c & d) | (a & b & ~c & d);
	assign seg[1] = (b & c & ~d) | (a & c & d) | (a & b & ~d) | (~a & b & ~c & d);
	assign seg[2] = (a & b & ~d) | (~a & ~b & c & ~d) | (a & b & c);
	assign seg[3] = (~a & ~b & ~c & d) | (~a & b & ~c & ~d) | (b & c & d) | (a & ~b & c & ~d);
	assign seg[4] = (~a & b & ~c) | (~a & d) | (~b & ~c & d);
	assign seg[5] = (~a & ~b & d) | (~a & ~b & c) | (~a & c & d) | (a & b & ~c & d);
	assign seg[6] = (~a & ~b & ~c) | (~a & b & c & d) | (a & b & ~c & ~d);
endmodule 