`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:31:45 01/01/2018
// Design Name:   ip_div
// Module Name:   E:/code/verilog/first_shooter/test_newsrc_newboard/ip_div_test.v
// Project Name:  test_newsrc_newboard
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ip_div
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ip_div_test;

	// Inputs
	reg clk;
	reg [19:0] dividend;
	reg [19:0] divisor;

	// Outputs
	wire rfd;
	wire [19:0] quotient;
	wire [19:0] fractional;

	// Instantiate the Unit Under Test (UUT)
	ip_div uut (
		.rfd(rfd), 
		.clk(clk), 
		.dividend(dividend), 
		.quotient(quotient), 
		.divisor(divisor), 
		.fractional(fractional)
	);
	integer i;
	initial begin
		// Initialize Inputs
		clk = 0;
		dividend = 100;
		divisor = 2;

		// Wait 100 ns for global reset to finish
		#100;
      for(i=0;i<1000;i=i+1) begin
			clk = ~clk;
			divisor = divisor + 1;
			#5;
		end
		
		// Add stimulus here

	end
      
endmodule

