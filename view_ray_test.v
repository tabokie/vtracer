`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:04:26 12/26/2017
// Design Name:   view_ray
// Module Name:   E:/code/verilog/first_shooter/d_first_shooter/view_ray_test.v
// Project Name:  d_first_shooter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: view_ray
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module view_ray_test;

	// Inputs
	reg clk;
	reg [30:0] view_normal;
	reg [7:0] view_dist;
	reg [12:0] view_loc;

	// Outputs
	wire [30:0] view_out;
	
	// Instantiate the Unit Under Test (UUT)
	view_ray uut (
		.clk(clk),
		.view_normal(view_normal), 
		.view_dist(view_dist), 
		.view_loc(view_loc), 
		.view_out(view_out),
	);
	
	integer i;
	initial begin
		// Initialize Inputs
		clk = 0;
		view_normal = 0;
		view_dist = 0;
		view_loc = 0;

		// Wait 100 ns for global reset to finish
      
		// Add stimulus here
		
		for(i=0;i<=1000;i=i+1)begin
			clk = ~clk;
			if(i==10)begin
				view_normal = 31'b0011111111100111111111000000000;
				view_dist = 3;
				view_loc = 13'b0111110111111;  
			end
			#10;
		end

	end

      
endmodule

