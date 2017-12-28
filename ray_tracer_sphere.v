`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:18:54 12/23/2017 
// Design Name: 
// Module Name:    ray_tracer_sphere 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module ray_tracer_sphere(
	input clk,
	input [27:0] init,
	input [30:0] dir,
	input [47:0] object_in, // 12(color)-8(r)-28(center) = 48
	output reg[9:0] t_out
);

	// sphere trace formula:
	// denote init as e, dir as d, sphere as c
	// and p as e-c
	// t = [-d*p-sqrt( (d*p)^2 - d^2*(p^2-r^2)) ] / d^2
	// d*p(twice)/d^2(twice)/p^2/r^2 is used scalar

	// signed init
	wire [30:0] signed_init = {1'b0,init[27:18],1'b0,init[17:8],1'b0,init[7:0]};

	// prepare p(e-c)
	wire [27:0] c;
	assign c = object_in[27:0];
	wire [19:0]p_x;
	signed_to_20b_signed #(.LENGTH(11)) int0(.in(signed_init[30:20] - c[27:18]),.out(p_x));
	wire [19:0]p_y;
	signed_to_20b_signed #(.LENGTH(11)) int1(.in(signed_init[19:9] - c[17:8]),.out(p_y));
	wire [19:0]p_z;
	signed_to_20b_signed #(.LENGTH(9)) int2(.in(signed_init[8:0] - c[7:0]),.out(p_z));

	// prepare d
	wire [19:0]d_x;
	signed_to_20b_signed #(.LENGTH(11)) int3(.in(signed_init[30:20]),.out(d_x));
	wire [19:0]d_y;
	signed_to_20b_signed #(.LENGTH(11)) int4(.in(signed_init[19:9]),.out(d_y));
	wire [19:0]d_z;
	signed_to_20b_signed #(.LENGTH(9)) int5(.in(signed_init[8:0]),.out(d_z));

	// prepare r
	wire [19:0]r;
	assign r[19:8] = 0;
	assign r[7:0] = object_in[35:28];
	

	wire [19:0]dp;
	assign dp = d_x*p_x+d_y*p_y+d_z*p_z;
	wire [19:0]dd; 
	assign dd = d_x*d_x+d_y*d_y+d_z*d_z;
	wire [19:0]pp;
	assign pp = p_x*p_x+p_y*p_y+p_z*p_z;
	wire [19:0]rr;
	assign rr = r*r;

	wire [19:0]sqrt_res;
	assign sqrt_res[19:11] = 0;
	sqrt_20 ins(.x_in(dp*dp-dd*(pp-rr)),.x_out(sqrt_res[10:0]),.clk(clk));

	reg [19:0]final_res;
	always @(sqrt_res)begin
		final_res = (- dp - sqrt_res) / dd;
	end
	
	always @(final_res)begin
		case(final_res[19])
		1'b1:t_out = 10'b1111111111;
		1'b0:t_out = final_res[9:0];
		endcase
	end

endmodule


