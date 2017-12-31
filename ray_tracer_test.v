`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:48:56 12/28/2017
// Design Name:   ray_tracer
// Module Name:   E:/code/verilog/first_shooter/d_first_shooter/ray_tracer_test.v
// Project Name:  d_first_shooter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ray_tracer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ray_tracer_test;

	// Inputs
	reg clk;
	reg rst;
	reg [127:0] in_bus;
	reg [27:0] init;
	reg [30:0] dir;

	// Outputs
	wire [11:0] dout;
	wire collision_sig;
	// test out
	wire [79:0] t_show;
	wire [2:0] min_show;

	// Instantiate the Unit Under Test (UUT)
	ray_tracer uut (
		.clk(clk), 
		.rst(rst),
		.in_bus(in_bus), 
		.init(init), 
		.dir(dir), 
		.dout(dout), 
		.collision_ret(collision_sig)
		// test out
		,
		.t_show(t_show),
		.min_show(min_show)
	);
	integer i;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		in_bus = {12'b0,48'b111111111111_00001000_0000000000_0000100000_00000100,68'b0};
		init = 0;
		dir=0;
		// Wait 100 ns for global reset to finish
		#5;
		rst = 0;
		#50;
		rst=1;
        for(i=0;i<1000;i=i+1)begin
        	clk = ~clk;
        	#5;
        	if(i==20)begin
				dir = 31'b00000000000_00000000100_000000000;
        	end
        	if(i==50)begin
        		dir = 0;
        	end
        	if(i==80)begin
				dir = 31'b00000000000_00000000100_000000000;
        	end
        end
		// Add stimulus here

	end
      
endmodule

