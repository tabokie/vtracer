`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:43:26 12/22/2017
// Design Name:   mold
// Module Name:   E:/code/verilog/first_shooter/d_first_shooter/mold_test.v
// Project Name:  d_first_shooter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mold
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mold_test;

	// Inputs
	reg clk;
	reg [19:0] x;
	reg [19:0] y;
	reg [19:0] z;

	// Outputs
	wire [19:0] mold;

	// Instantiate the Unit Under Test (UUT)
	mold uut (
		.clk(clk), 
		.x(x), 
		.y(y), 
		.z(z), 
		.mold(mold)
	);
integer i;
	initial begin
		// Initialize Inputs
		clk = 0;
		x = 0;
		y = 0;
		z = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
		for(i=0;i<=1000;i=i+1)begin
			clk = ~clk;
			#5
			x=x+1'b1;
		end

	end
      
endmodule

