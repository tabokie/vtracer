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
	wire [19:0] d_mold_show;
	wire [19:0] delta_show;
	wire [19:0] div_res;
	wire [19:0] final_show;

	// Instantiate the Unit Under Test (UUT)
	ray_tracer_sphere uut (
		.clk(clk),
		.rst(rst),
		.init(init), 
		.dir(dir), 
		.object_in(object_in), 
		.t_out(t_out)
		,.d_mold_show(d_mold_show)
		,.delta_show(delta_show)
		,.div_res_show(div_res)
		,.final_show(final_show)
	);

	integer i;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst=1;
		init = 0;
		dir = 31'b00000000000_00000000100_000000000;
		dir = 31'b00000000001_00000000111_000000001;
		object_in = 48'b111111111111_00010000_0000000000_0000100000_00000000;

		// Wait 100 ns for global reset to finish
		#100;
		rst=0;
      for(i=0;i<5000;i=i+1)begin
			clk = ~clk;
			if(i==99)begin
				dir = 31'b00000000001_00000100000_000000001;
			end
			if(i==100)begin
				rst = 1;
			end
			if(i==200)begin
				dir = 31'b1111110100000000000011000011100;
			end
			#5;
		end
		// Add stimulus here

	end
      
endmodule

