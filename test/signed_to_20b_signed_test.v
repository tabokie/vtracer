`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:50:16 12/26/2017
// Design Name:   signed_to_20b_signed
// Module Name:   E:/code/verilog/first_shooter/d_first_shooter/signed_to_20b_signed_test.v
// Project Name:  d_first_shooter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: signed_to_20b_signed
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module signed_to_20b_signed_test;

	// Inputs
	reg [9:0] in;

	// Outputs
	wire [19:0] out;

	// Instantiate the Unit Under Test (UUT)
	signed_to_20b_signed #(.LENGTH(10)) uut (
		.in(in), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		in = 0;

		// Wait 100 ns for global reset to finish
		#100;
      in = 10'b1001011100;
		// Add stimulus here

	end
      
endmodule

