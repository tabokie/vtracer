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
	wire [30:0] view;
	wire [11:0] color;
	wire [6:0] i_show;
	wire [5:0] k_show;
	wire [7:0] j_show;
	wire [9:0] t_show;

	wire [19:0] d_mold_show;
    wire [19:0] delta_show;
    wire [19:0] div_res;
    wire [19:0] final_show;
	// Instantiate the Unit Under Test (UUT)
	ray_tracer_host uut (
		.clk(clk), 
		.rst(rst), 
		.in_bus(in_bus), 
		.col_addr(col_addr), 
		.row_addr(row_addr), 
		.dout(dout), 
		.collision_sig(collision_sig)
		,.view_show(view)
		,.color_show(color)
		,.i_show(i_show)
		,.k_show(k_show)
		,.j_show(j_show)
		,.t_show(t_show)
		,.d_mold_show(d_mold_show)
        ,.delta_show(delta_show)
        ,.div_res(div_res)
        ,.final_show(final_show)
	);
	integer i = 0;
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
      	// in_bus = {12'b0,48'b111111111111_00010000_0000000000_0000100000_00000000,9'b0_00000011,31'b00000000000_00000000001_000000000,28'b0};
		// Add stimulus here
		forever begin
			clk = ~clk;
			#5;
			i = i+1;
			if(i==100)begin
      			rst = 0;
			end
			if(i==104)begin
				rst = 1;
      			in_bus = {12'b0,48'b111111111111_00010000_0000000000_0000100000_00000000,9'b0_00000011,31'b00000000000_00000000001_000000000,28'b0};
			end
		end
	end
      
endmodule

