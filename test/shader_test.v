`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:03:40 01/09/2018
// Design Name:   single_shader
// Module Name:   E:/code/verilog/first_shooter/formal_on_sword/shader_test.v
// Project Name:  first_shooter_on_sword
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: single_shader
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module shader_test;

	// Inputs
	reg clk;
	reg rst;
	reg [27:0] light;
	reg [27:0] init;
	reg [30:0] dir;
	reg [9:0] t;
	reg [30:0] normal;
	reg [9:0] normal_mold;

	// Outputs
	wire [11:0] color;

	// Instantiate the Unit Under Test (UUT)
	single_shader uut (
		.clk(clk), 
		.rst(rst), 
		.light(light), 
		.init(init), 
		.dir(dir), 
		.t(t), 
		.normal(normal), 
		.normal_mold(normal_mold), 
		.color(color)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		light = 0;
		init = 0;
		dir = {11'd1,11'd1,9'd0};
		t = 19;
		normal = {-11'd1,-11'd1,9'd0};
		normal_mold = 1;
		#5;
		rst = 0;
		#5;
		rst = 1;
		// Wait 100 ns for global reset to finish
		#100;
      forever begin
			clk = ~clk;
			#5;
		end
		// Add stimulus here

	end
      
endmodule

