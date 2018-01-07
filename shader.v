`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:02:06 12/26/2017 
// Design Name: 
// Module Name:    single_shader
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
`define scale 20'd16
`define a 6'd0
`define b 6'd1
`define c 6'd2
`define d 6'd3
module single_shader(
	input clk,
	input [30:0] normal,
	input [30:0] orient,
	output reg [11:0] color
);
	// get normal and light-line

	// pooling 1 //
	reg [19:0] normal_mold_reg;
	reg [19:0] orient_mold_reg;
	// pooling 2  //
	reg [19:0] dividend_reg;
	reg [19:0] divisor_reg;
	// pooling 3  //
	reg [19:0] scaled_cos_reg;


	reg [5:0] i;
	always @(posedge clk or negedge rst)begin
		if(!rst)begin
			i<= 6'b0;
		end
		else begin
			case(i)
			`a:begin
				normal_mold_reg <= normal_mold;
				orient_mold_reg <= orient_mold;
			end
			`b:begin
				dividend_reg <= dividend;
				divisor_reg <= divisor;
			end
			`c:begin
				scaled_cos_reg <= scaled_cos;
			end
			`d:begin
				color <= (scaled_cos_reg[19]==1'b1) ? 12'h0 : {3{scaled_cos_reg[7:4]}};
			end
			default :begin
				i <= i+6'b1;
			end
			endcase
		end
	end


	wire [19:0] nx;
	signed_to_20b_signed #(.LENGTH(11)) int0(.in(normal[30:20]),.out(nx));
	wire [19:0] ny;
	signed_to_20b_signed #(.LENGTH(11)) int1(.in(normal[19:9]),.out(ny));
	wire [19:0] nz;
	signed_to_20b_signed #(.LENGTH(9)) int2(.in(normal[8:0]),.out(nz));
	wire [19:0] normal_mold;
	mold mold0(.clk(clk),.x(nx),.y(ny),.z(nz),.mold(normal_mold));

	wire [19:0] ox;
	signed_to_20b_signed #(.LENGTH(11)) int3(.in(orient[30:20]),.out(ox));
	wire [19:0] oy;
	signed_to_20b_signed #(.LENGTH(11)) int4(.in(orient[19:9]),.out(oy));
	wire [19:0] oz;
	signed_to_20b_signed #(.LENGTH(9)) int5(.in(orient[8:0]),.out(oz));
	wire [19:0] orient_mold;
	mold mold1(.clk(clk),.x(ox),.y(oy),.z(oz),.mold(orient_mold));

	wire [19:0] dividend;
	wire [19:0] divisor;
	assign dividend = `scale*normal*orient;
	assign divisor = normal_mold*orient_mold;

	wire [19:0] scaled_cos;
	ip_div_20 div_ins(.clk(clk),.rfd(),
		.dividend(dividend_reg),.divisor(divisor_reg),
		.quotient(scaled_cos),.fractional());
		
endmodule