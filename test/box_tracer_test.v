`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:54:18 01/09/2018
// Design Name:   ray_tracer_box
// Module Name:   E:/code/verilog/first_shooter/formal_on_sword/box_tracer_test.v
// Project Name:  first_shooter_on_sword
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ray_tracer_box
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module box_tracer_test;

	// Inputs
	reg clk;
	reg rst;
	reg [27:0] init;
	reg [30:0] dir;
	reg [55:0] object_in;

	// Outputs
	wire [9:0] t_out;
	wire [30:0] normal;

	// Instantiate the Unit Under Test (UUT)
	ray_tracer_box uut (
		.clk(clk), 
		.rst(rst), 
		.init(init), 
		.dir(dir), 
		.object_in(object_in), 
		.t_out(t_out), 
		.normal(normal)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		init = 0;
		dir = {11'd16,11'd20,9'd3};
		object_in = {10'd16,10'd32,10'd20,10'd36,8'd0,8'd30};

		// Wait 100 ns for global reset to finish
		#100;
      forever begin
			clk = ~clk;
			#5;
		end
		// Add stimulus here

	end
      
endmodule

