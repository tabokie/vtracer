`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:12:21 12/27/2017
// Design Name:   top
// Module Name:   E:/code/verilog/first_shooter/d_first_shooter/top_test.v
// Project Name:  d_first_shooter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module top_test;

	// Inputs
	reg clk;
	reg rst;
	reg PS2C;
	reg PS2D;

	// Outputs
	wire hs;
	wire vs;
	wire [3:0] r;
	wire [3:0] g;
	wire [3:0] b;
	// test
	wire [12:0] tracer;
	wire [12:0] vga;
	wire [11:0] vga_in;
	wire [11:0] tracer_out;
	//wire [31:0] local_clk;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk(clk), 
		.rst(rst), 
		.PS2C(PS2C), 
		.PS2D(PS2D), 
		.hs(hs), 
		.vs(vs), 
		.r(r), 
		.g(g), 
		.b(b)
		// test
		,
		.tracer_show(tracer),
		.vga_show(vga),
		.tracer_out_show(tracer_out),
		.vga_in_show(vga_in)
		//.local_clk(local_clk)
	);
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		PS2C = 0;
		PS2D = 0;
		#5
		// Wait 100 ns for global reset to finish
		rst = 0;
		#50;
		rst = 1;
      forever begin
			clk = ~clk;
			#5;
		end
		// Add stimulus here

	end
      
endmodule

