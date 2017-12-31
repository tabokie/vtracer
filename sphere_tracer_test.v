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
	reg rst;
	// Outputs
	wire [9:0] t_out;

	// test output
	wire [19:0] dp;
	wire [19:0] dd;
	wire [19:0] pp;
	wire [19:0] rr;
	wire [19:0] sqrt_res;
	wire [19:0] final;

	// Instantiate the Unit Under Test (UUT)
	ray_tracer_sphere uut (
		.clk(clk),
		.rst(rst),
		.init(init), 
		.dir(dir), 
		.object_in(object_in), 
		.t_out(t_out)
		// test output
		// ,
		// .dp(dp),
		// .dd(dd),
		// .pp(pp),
		// .rr(rr),
		// .sqrt_res(sqrt_res),
		// .final_res(final)
	);
	integer i;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst=1;
		init = 0;
		dir = 31'b00000000000_00000000100_000000000;
		object_in = 48'b111111111111_00001000_0000000000_0000100000_00000000;

		// Wait 100 ns for global reset to finish
		#100;
		rst=0;
		#5;
		rst=1;
      for(i=0;i<100;i=i+1)begin
			clk = ~clk;
			#5;
		end
		// Add stimulus here

	end
      
endmodule

