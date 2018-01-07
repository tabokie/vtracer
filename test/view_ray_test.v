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
	reg rst;
	reg [30:0] view_normal;
	reg [7:0] view_dist;
	reg [12:0] view_loc;

	// Outputs
	wire [30:0] view_out;

	wire [5:0] i_show;
	wire [19:0] d_length_show;
	wire [19:0] div_show;
	wire [19:0] pool1_show;
	wire [19:0] pool2_show;
	wire [19:0] pool3_show;

	// Instantiate the Unit Under Test (UUT)
	view_ray uut (
		.clk(clk),
		.rst(rst),
		.view_normal(view_normal), 
		.view_dist(view_dist), 
		.view_loc(view_loc), 
		.view_out(view_out)
		// test
		,.i_show(i_show)
		,.d_length_show(d_length_show)
		,.div_show(div_show)
		,.pool1_show(pool1_show)
		,.pool2_show(pool2_show)
		,.pool3_show(pool3_show)
	);

	integer j;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		view_normal = 0;
		view_dist = 0;
		view_loc = 0;

		// Wait 100 ns for global reset to finish
      	#5;
      	rst = 0;
		// Add stimulus here
		
		for(j=0;j<=1000;j=j+1)begin
			clk = ~clk;
			if(j==9)begin
				view_normal = 31'b00000000000_00000000001_000000000;
				view_dist = 3;
				view_loc = 13'b0; 
			end
			if(j==10)begin
				rst=1;
			end
			if(j==200)begin
				view_loc = {7'd40,6'd30}; // output : 00000000001_00000000011_111111111
			end
			if(j==400)begin
				view_loc = {7'd15,6'd1}; // output : 0000010100_00000000011_111100010
			end
			#10;
		end

	end

      
endmodule

