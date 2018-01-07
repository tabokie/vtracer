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
	reg [12:0] write_addr;
	reg [12:0] read_addr;
	reg [11:0] din;

	// Outputs
	wire [11:0] dout;

	// Instantiate the Unit Under Test (UUT)
	dual_port_ram #(.WIDTH(13),.LENGTH(12)) uut (
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
		rst = 1;
		write_addr = 0;
		read_addr = 0;
		din = 1;
		#5;
		rst = 0;
		#5
		rst = 1;
		// Wait 100 ns for global reset to finish
		#100;
      for(i=0;i<1000;i=i+1)begin
			clk = ~clk;
			#5;
			if(i==100)begin
				din = 10;
			end
		end
		// Add stimulus here

	end
      
endmodule

