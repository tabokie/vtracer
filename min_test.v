`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:40:38 12/22/2017
// Design Name:   min
// Module Name:   E:/code/verilog/first_shooter/d_first_shooter/min_test.v
// Project Name:  d_first_shooter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: min
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module min_test;

	// Inputs
	reg [79:0] in_bus;

	// Outputs
	wire [2:0] out;

	// Instantiate the Unit Under Test (UUT)
	min uut (
		.in_bus(in_bus), 
		.out(out)
	);

	integer i;
	initial begin
		// Initialize Inputs
		in_bus = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		for(i=0;i<1000;i=i+1)begin
			in_bus[79:8] = in_bus[79:8] + 72'b1;
			#10;
		end
	end
      
endmodule

