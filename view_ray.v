`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:54:49 12/23/2017 
// Design Name: 
// Module Name:    view_ray 
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
`include "vga_scan_param_h.v"
`define MOLD_LATE 6'd7
`define GLOBAL_INTERVAL 6'd36
`define TOTAL_LATE 6'd31
// latency : 34 (d1+d2+3)
// pipeline allowed : 25 (d2+1)
// \input Normal vector(vector)
// \input View dist(min_dist)
// \input Canvas location(2-dimension coord)
// \output View ray vector(vector)
module view_ray(
	input clk,
	input rst,
	input [30:0] view_normal, // d
	input [7:0] view_dist, // d0
	input [12:0] view_loc, // (x,y) 7-6
	output [30:0] view_out

 );

	// ray generate formula:
	// |d0|/|d|*d + |x|/|d^-1|*d^-1 + (0,0,y)

	// pooling 1 //
	reg [19:0] dx_reg_1 = 20'b0;
	reg [19:0] dy_reg_1 = 20'b0;
	reg [19:0] dz_reg_1 = 20'b0;
	reg [19:0] view_dist_reg_1 = 20'b0;
	reg [19:0] view_x_reg_1 = 20'b0;
	reg [19:0] view_y_reg_1 = 20'b0;
		// assign pool1_show = view_x_reg_1;

	// pooling 2 //
	reg [19:0] sum0_reg_2 = 20'b0;
	reg [19:0] sum1_reg_2 = 20'b0;
	reg [19:0] view_y_reg_2 = 20'b0;
		// assign pool2_show = sum0_reg_2;

	// pooling 3 //
	reg [19:0] view_out_x  = 20'b0;
	reg [19:0] view_out_y  = 20'b0;
	reg [19:0] view_out_z  = 20'b0;
		// assign pool3_show = view_out_x;

	// state machine
	reg [5:0] i;
		// assign i_show = i;
	always @(posedge clk or negedge rst)begin
		if(!rst)begin
			i <= 6'b0;
		end
		else begin
		 	case(i)
		 	`TOTAL_LATE + 6'd2:begin
		 		// third pooling
				view_out_x <= d_length==0 ? {20{1'b1}} : x_div_res;
				view_out_y <= d_length==0 ? {20{1'b1}} : y_div_res;
				view_out_z <= d_length==0 ? {20{1'b1}} : view_y_reg_2;

				// and second
				sum0_reg_2 <= sum0;
				sum1_reg_2 <= sum1;
				view_y_reg_2 <= view_y_reg_1;

		 		i <= i + 6'd1;
		 	end
		 	6'd0,`GLOBAL_INTERVAL+6'd1:begin
		 		// first pooling read
				dx_reg_1 <= dx;
				dy_reg_1 <= dy;
				dz_reg_1 <= dz;
				view_dist_reg_1 <= long_view_dist;
				view_x_reg_1 <= view_x;
				view_y_reg_1 <= view_y;
				i <= 6'b1;
			end
		 	`MOLD_LATE+6'd1:begin
		 		// second pooling read
				sum0_reg_2 <= sum0;
				sum1_reg_2 <= sum1;
				view_y_reg_2 <= view_y_reg_1;
				i <= i + 6'd1;
			end
			default:begin
				i <= i + 6'd1;
			end
		 	endcase
		end
	end


	// Combinational Part : Data preapre //
	// convert to large int
	wire [19:0] dx;
	signed_to_20b_signed #(.LENGTH(11)) int0(.in(view_normal[30:20]),.out(dx));
	wire [19:0] dy;
	signed_to_20b_signed #(.LENGTH(11)) int1(.in(view_normal[19:9]),.out(dy));
	wire [19:0] dz;
	signed_to_20b_signed #(.LENGTH(9)) int2(.in(view_normal[8:0]),.out(dz));
	// prepare |d0|
	wire [19:0] long_view_dist;
	assign long_view_dist = {12'b0,view_dist};
	//  and x,y
	wire [19:0] view_x;
	signed_to_20b_signed #(.LENGTH(7)) int3(.in(~{1'b0,`COL_MID} + 7'b1 + {1'b0,view_loc[12:6]}),.out(view_x));
	wire [19:0] view_y;
	signed_to_20b_signed #(.LENGTH(6)) int4(.in({1'b0,`ROW_MID} + ~{1'b0,view_loc[5:0]} + 6'b1),.out(view_y));


	// solver in pooling 1 //
	// calculate |d| using mold
	wire [19:0] d_length;
	mold mold0(.clk(clk),.x(dx_reg_1),.y(dy_reg_1),.z(dz_reg_1),.mold(d_length));
		// assign d_length_show = d_length;
	// calculate dividend
	reg [19:0] product0 = 20'b0;
	reg [19:0] product1 = 20'b0;
	reg [19:0] product2 = 20'b0;
	reg [19:0] product3 = 20'b0;
	wire [19:0] sum0;
	wire [19:0] sum1;
	always @(posedge clk)begin
		product0 <= view_dist_reg_1 * dx_reg_1;
		product1 <= view_x_reg_1 * dy_reg_1;
		product2 <= view_dist_reg_1 * dy_reg_1;
		product3 <= view_x_reg_1 * dx_reg_1;
	end
	assign sum0 = product0 + product1;
	assign sum1 = product2 + ~product3 + 20'b1;

	// solver in pooling 2 //
	wire [19:0] x_div_res;
	wire [19:0] y_div_res;
	ip_div_20 div_ins0(.clk(clk),.rfd(),
		.dividend(sum0_reg_2),.divisor(d_length),
		.quotient(x_div_res),.fractional());
	ip_div_20 div_ins1(.clk(clk),.rfd(),
		.dividend(sum1_reg_2),.divisor(d_length),
		.quotient(y_div_res),.fractional());
	// my_div #(.divisorBITS(11),.dividendBITS(20)) div_ins0(.clk(clk),
	// 	.dividend(sum0_reg_2),.divisor({1'b0,d_length[9:0]}),
	// 	.quotient(x_div_res),.fractional());
	// my_div #(.divisorBITS(11),.dividendBITS(20)) div_ins1(.clk(clk),
	// 	.dividend(sum1_reg_2),.divisor({1'b0,d_length[9:0]}),
	// 	.quotient(y_div_res),.fractional());


	assign view_out = {view_out_x[10:0],view_out_y[10:0],view_out_z[8:0]};

endmodule


