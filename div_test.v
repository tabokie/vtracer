`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:32:42 12/29/2017
// Design Name:   div
// Module Name:   E:/code/verilog/first_shooter/d_first_shooter/div_test.v
// Project Name:  d_first_shooter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: div
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module div_test;

	// Inputs
	reg clk;
	reg rst;
	reg [19:0] dividend;
	reg [19:0] divisor;

	// Outputs
	wire [19:0] quo;

	// test
	wire [5:0] cur;
	wire [39:0] pool;
	wire local_rst;

	// Instantiate the Unit Under Test (UUT)
	div uut (
		.clk(clk), 
		.rst(rst), 
		.dividend(dividend), 
		.divisor(divisor), 
		.quo(quo)
		// test
		,
		.cur_show(cur),
		.pool_show(pool),
		.rst_show(local_rst)
	);
	integer i;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		dividend = 19;
		divisor = 4;
		#5;
		rst = 0;
		// Wait 100 ns for global reset to finish
		#10;
		rst = 1;
		// Add stimulus here
		for(i=0;i<30;i=i+1)begin
			clk = ~clk;
			#5;
		end
	end
      
endmodule

