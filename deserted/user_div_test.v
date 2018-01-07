`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:58:57 01/05/2018
// Design Name:   user_div
// Module Name:   E:/code/verilog/first_shooter/test_newsrc_newboard/user_div_test.v
// Project Name:  test_newsrc_newboard
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: user_div
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module user_div_test;

	// Inputs
	reg clk;
	reg [19:0] dividend;
	reg [19:0] divisor;

	// Outputs
	wire [19:0] quotient;
	wire done_sig;

	// Instantiate the Unit Under Test (UUT)
	user_div uut (
		.clk(clk), 
		.dividend(dividend), 
		.divisor(divisor), 
		.quotient(quotient), 
		.done_sig(done_sig)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		dividend = 10;
		divisor = 3;

		// Wait 100 ns for global reset to finish
		#100;
      forever begin
			clk = ~clk;
			#5;
		end
		// Add stimulus here

	end
      
endmodule

