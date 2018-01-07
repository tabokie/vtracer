`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:26:42 01/07/2018
// Design Name:   my_div
// Module Name:   E:/code/verilog/first_shooter/test_newsrc_newboard/my_div_test.v
// Project Name:  test_newsrc_newboard
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: my_div
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module my_div_test;

	// Inputs
	reg clk;
	reg ena;
	reg [19:0] z;
	reg [9:0] d;

	// Outputs
	wire [19:0] q;
	wire [19:0] s;

	// Instantiate the Unit Under Test (UUT)
	my_div uut (
		.clk(clk), 
		.dividend(z), 
		.divisor(d), 
		.quotient(q), 
		.fractional(s)
	);

	integer i;
	initial begin
		// Initialize Inputs
		clk = 0;
		ena = 1;
		z = 0;
		d = 0;

		// Wait 100 ns for global reset to finish
		#100;
      for(i=0;i<=1000;i=i+1)begin
			clk = ~clk;
			if(i==100)begin
				z = -20'd17;
				d = 10'd3;
			end
			if(i==150)begin
				z = 20'd57;
				d = 10'd6;
			end
			if(i==180)begin
				z = 20'd100;
				d = 10'd9;
			end
			#5;
			
		end
		// Add stimulus here

	end
      
endmodule

