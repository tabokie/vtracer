// latency : 2

module mold(
	input clk,
	input [19:0] x,
	input [19:0] y,
	input [19:0] z,
	output [19:0] mold,
);
	wire [19:0] x2;
	assign x2 = x*x;
	wire [19:0] y2;
	assign y2 = y*y;
	wire [19:0] z2;
	assign z2 = z*z;
	wire [19:0] sum; 
	assign sum = x2+y2+z2;
	sqrt_20 ins(
	  .x_in(sum), // input [19 : 0] x_in
	  .x_out(mold[15:0]), // output [15 : 0] x_out
	  .clk(clk) // input clk
	);

endmodule