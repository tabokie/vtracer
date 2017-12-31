`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:52:16 12/29/2017
// Design Name:   ray_tracer_host
// Module Name:   E:/code/verilog/first_shooter/d_first_shooter/ray_tracer_host_test.v
// Project Name:  d_first_shooter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ray_tracer_host
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ray_tracer_host_test;

	// Inputs
	reg clk;
	reg rst;
	reg [127:0] in_bus;

	// Outputs
	wire [6:0] col_addr;
	wire [5:0] row_addr;
	wire [11:0] dout;
	wire [3:0] collision_sig;

	// test out
	wire [6:0] col_cnt;
	wire [5:0] row_cnt;
	wire [30:0] direction;
	wire [11:0] dbuffer;
	wire [2:0] i_show;
	wire [3:0] j_show;

	// Instantiate the Unit Under Test (UUT)
	ray_tracer_host uut (
		.clk(clk), 
		.rst(rst), 
		.in_bus(in_bus), 
		.col_addr(col_addr), 
		.row_addr(row_addr), 
		.dout(dout), 
		.collision_sig(collision_sig)
		// test output
		,
		.col_before(col_cnt),
		.row_before(row_cnt),
		.direction(direction),
		.dbuffer(dbuffer),
		.i_show(i_show),
		.j_show(j_show)
	);
	integer i;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		in_bus = 0;
		#5;
		rst=0;
		// Wait 100 ns for global reset to finish
		#30;
		rst = 1;
        in_bus = {12'b0,48'b111111111111-00001000-0000000000-0000100000-00010000,40'b0-00000011,31'b0011111111100111111111000000000,28'b0};
		// Add stimulus here
		for(i=0;i<1000;i=i+1)begin
			clk = ~clk;
			#5;
		end
	end
      
endmodule

