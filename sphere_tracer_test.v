`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:14:01 12/28/2017
// Design Name:   ray_tracer_sphere
// Module Name:   E:/code/verilog/first_shooter/d_first_shooter/sphere_tracer_test.v
// Project Name:  d_first_shooter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ray_tracer_sphere
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sphere_tracer_test;

	// Inputs
	reg [27:0] init;
	reg [30:0] dir;
	reg [47:0] object_in;
	reg clk;

	// Outputs
	wire [9:0] t_out;

	// Instantiate the Unit Under Test (UUT)
	ray_tracer_sphere uut (
		.clk(clk),
		.init(init), 
		.dir(dir), 
		.object_in(object_in), 
		.t_out(t_out)
	);
	integer i;
	initial begin
		// Initialize Inputs
		clk = 0;
		init = 0;
		dir = 0;
		object_in = 48'b111111111111-00001000-0000000000-0000100000-00010000;

		// Wait 100 ns for global reset to finish
		#100;
      for(i=0;i<100;i=i+1)begin
			clk = ~clk;
			#5;
		end
		// Add stimulus here

	end
      
endmodule

