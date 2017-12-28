`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:02:37 12/28/2017
// Design Name:   vga
// Module Name:   E:/code/verilog/first_shooter/d_first_shooter/vga_test.v
// Project Name:  d_first_shooter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vga
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module vga_test;

	// Inputs
	reg vga_clk;
	reg clr;
	reg [11:0] din;

	// Outputs
	wire [6:0] col_addr;
	wire [5:0] row_addr;
	wire hs;
	wire vs;
	wire [3:0] r;
	wire [3:0] g;
	wire [3:0] b;

	// Instantiate the Unit Under Test (UUT)
	vga uut (
		.vga_clk(vga_clk), 
		.clr(clr), 
		.din(din), 
		.col_addr(col_addr), 
		.row_addr(row_addr), 
		.hs(hs), 
		.vs(vs), 
		.r(r), 
		.g(g), 
		.b(b)
	);
	
	integer i;
	initial begin
		// Initialize Inputs
		vga_clk = 0;
		clr = 0;
		din = 0;
		#5;
		// Wait 100 ns for global reset to finish
		clr = 1;
		#50;
      clr = 0;
		// Add stimulus here
		for(i=0;i<1000;i=i+1)begin
			vga_clk = ~vga_clk;
			#5;
		end
	end
      
endmodule

