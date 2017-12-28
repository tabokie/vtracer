`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:25:06 12/28/2017
// Design Name:   dual_port_ram
// Module Name:   E:/code/verilog/first_shooter/d_first_shooter/ram_test.v
// Project Name:  d_first_shooter
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: dual_port_ram
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ram_test;

	// Inputs
	reg clk;
	reg rst;
	reg [3:0] write_addr;
	reg [3:0] read_addr;
	reg [7:0] din;

	// Outputs
	wire [7:0] dout;

	// Instantiate the Unit Under Test (UUT)
	dual_port_ram uut (
		.clk(clk), 
		.rst(rst), 
		.write_addr(write_addr), 
		.read_addr(read_addr), 
		.din(din), 
		.dout(dout)
	);
	integer i;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		write_addr = 0;
		read_addr = 0;
		din = 1;
		
		rst = 1;
		// Wait 100 ns for global reset to finish
		#100;
      for(i=0;i<1000;i=i+1)begin
			clk = ~clk;
			#5;
		end
		// Add stimulus here

	end
      
endmodule

