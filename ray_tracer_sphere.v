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
// // latency : 37
// // pipeline allowed : 25 (d2+1)
// `define DIV_LATE 24 // 24
// `define SQRT_LATE 7 // 7

// latency : 52
// pipeline allowed : 37 (d2+1)
`define DIV_LATE 36 
// 24
`define SQRT_LATE 10 
// 7

module ray_tracer_sphere(
	input clk,
	input rst,
	input [27:0] init,
	input [30:0] dir,
	input [47:0] object_in, // 12(color)-8(r)-28(center) = 48
	output reg[9:0] t_out
	// ,output [31:0] d_mold_show
	// ,output [31:0] delta_show
	// ,output [31:0] div_res_show
	// ,output [31:0] final_show 
);
	// assign d_mold_show = d_mold_reg;
	// assign delta_show = delta;
	// assign div_res_show = div_res;
	// assign final_show = final_res;

	// sphere trace formula:
	// denote init as e, dir as d, sphere as c
	// and p as e-c
	// t = [-d*p-sqrt( (d*p)^2 - d^2*(p^2-r^2)) ] / d^2
	// d*p(twice)/d^2(twice)/p^2/r^2 is used scalar

	// Combinational Part //
	// signed init
	wire [30:0] signed_init = {1'b0,init[27:18],1'b0,init[17:8],1'b0,init[7:0]};

	// prepare p(e-c)
	wire [30:0] c;
	assign c = {1'b0,object_in[27:18],1'b0,object_in[17:8],1'b0,object_in[7:0]};
	wire [31:0]p_x;
	signed_expansion #(.LENGTH(11)) int0(.in(signed_init[30:20] + ~c[30:20] + 11'b1),.out(p_x));
	wire [31:0]p_y;
	signed_expansion #(.LENGTH(11)) int1(.in(signed_init[19:9] + ~c[19:9] + 11'b1),.out(p_y));
	wire [31:0]p_z;
	signed_expansion #(.LENGTH(9)) int2(.in(signed_init[8:0] + ~c[8:0] + 9'b1),.out(p_z));

	// prepare d
	wire [31:0]d_x;
	signed_expansion #(.LENGTH(11)) int3(.in(dir[30:20]),.out(d_x));
	wire [31:0]d_y;
	signed_expansion #(.LENGTH(11)) int4(.in(dir[19:9]),.out(d_y));
	wire [31:0]d_z;
	signed_expansion #(.LENGTH(9)) int5(.in(dir[8:0]),.out(d_z));

	// prepare r
	wire [31:0]r;
	assign r[31:8] = 12'd0;
	assign r[7:0] = object_in[35:28];
	
	//  pooling 1  //
	reg [31:0] dp_x_reg = 32'b0;
	reg [31:0] dp_y_reg = 32'b0;
	reg [31:0] dp_z_reg = 32'b0;
	reg [31:0] dd_x_reg = 32'b0;
	reg [31:0] dd_y_reg = 32'b0;
	reg [31:0] dd_z_reg = 32'b0;
	reg [31:0] pp_x_reg = 32'b0;
	reg [31:0] pp_y_reg = 32'b0;
	reg [31:0] pp_z_reg = 32'b0;
	reg [31:0] rr_reg = 32'b0;
	//  pooling 2  //
	reg [31:0] dp_reg = 32'b0;
	reg [31:0] dd_reg = 32'b0;
	reg [31:0] pp_reg = 32'b0;
	//  pooling 3  //
	reg [31:0] dp_2_reg = 32'b0;
	reg [31:0] ddpp_reg = 32'b0;
	reg [31:0] ddrr_reg = 32'b0;
	reg dd_sig_reg_1 = 1'b0;
	//  pooling 4  //
	reg [31:0] delta = 32'b0;
	//  pooling 5  //
	reg delta_sig_reg_1 = 1'b0;
	//  pooling 6 (d_mold sqrt)  //
	reg [31:0] d_mold_reg = 32'b0;
	//  pooling 7 (dividend sqrt)  //
	reg [31:0] dividend = 32'b0;
	//  pooling 8  //
	reg dd_sig_reg_2 = 1'b0;
	reg delta_sig_reg_2 = 1'b0;
	//  pooling 9  //
	reg [31:0] final_res = 32'b0;

	reg [5:0] i;
	always @(posedge clk or negedge rst)begin
		if(!rst)begin
			i <= 6'd0;	
		end
		else begin
			case(i)
			6'd0:begin
				dp_x_reg <= d_x*p_x;
				dp_y_reg <= d_y*p_y;
				dp_z_reg <= d_z*p_z;
				
				dd_x_reg <= d_x*d_x;
				dd_y_reg <= d_y*d_y;
				dd_z_reg <= d_z*d_z;

				pp_x_reg <= p_x*p_x;
				pp_y_reg <= p_y*p_y;
				pp_z_reg <= p_z*p_z;

				rr_reg <= r*r;
				i <= i + 6'd1;
			end
			6'd1:begin
				dp_reg <= dp_x_reg + dp_y_reg + dp_z_reg;
				dd_reg <= dd_x_reg + dd_y_reg + dd_z_reg;
				pp_reg <= pp_x_reg + pp_y_reg + pp_z_reg;
				i <= i + 6'd1;
			end
			6'd2:begin
				dp_2_reg <= dp_reg * dp_reg;
				ddpp_reg <= dd_reg * pp_reg;
				ddrr_reg <= dd_reg * rr_reg;

				dd_sig_reg_1 <= (dd_reg==32'b0)?1'b1:1'b0;
				i <= i + 6'd1;
			end
			6'd3:begin
				delta <= dp_2_reg + ddrr_reg + ~(ddpp_reg) + 32'b1;
				i <= i + 6'd1;
			end
			6'd4:begin
				delta_sig_reg_1 <= delta[19];
				i <= i + 6'd1;
			end
			6'd2 + `SQRT_LATE:begin
				d_mold_reg <= d_mold;
				i <= i + 6'd1;
			end
			//sqrt
			6'd4 + `SQRT_LATE:begin
				dividend <= ~dp_reg + ~sqrt_res + 32'd2	;
				i <= i + 6'd1;
			end
			// new input
			6'd1 + `DIV_LATE:begin
				dp_x_reg <= d_x*p_x;
				dp_y_reg <= d_y*p_y;
				dp_z_reg <= d_z*p_z;
				
				dd_x_reg <= d_x*d_x;
				dd_y_reg <= d_y*d_y;
				dd_z_reg <= d_z*d_z;

				pp_x_reg <= p_x*p_x;
				pp_y_reg <= p_y*p_y;
				pp_z_reg <= p_z*p_z;

				rr_reg <= r*r;

				i <= i + 6'd1;
			end
			6'd2 + `DIV_LATE:begin
				dp_reg <= dp_x_reg + dp_y_reg + dp_z_reg;
				dd_reg <= dd_x_reg + dd_y_reg + dd_z_reg;
				pp_reg <= pp_x_reg + pp_y_reg + pp_z_reg;
				i <= i + 6'd1;
			end
			6'd3 + `DIV_LATE:begin
				dp_2_reg <= dp_reg * dp_reg;
				ddpp_reg <= dd_reg * pp_reg;
				ddrr_reg <= dd_reg * rr_reg;
				// dp_reg_2 <= dp_reg_1;

				dd_sig_reg_1 <= (dd_reg==32'b0)?1'b1:1'b0;
				i <= i + 6'd1;
			end
			6'd4 + `DIV_LATE:begin
				delta <= dp_2_reg + ddrr_reg + ~(ddpp_reg) + 32'b1;
				i <= i + 6'd1;
			end
			6'd5 + `DIV_LATE:begin
				delta_sig_reg_1 <= delta[31];
				i <= i + 6'd1;
			end
			6'd3 + `DIV_LATE + `SQRT_LATE:begin
				d_mold_reg <= d_mold;
				i <= i + 6'd1;
			end
			// div
			6'd5 + `DIV_LATE + `SQRT_LATE:begin
				final_res <= (dd_sig_reg_2==1'b1) ? {32{1'b1}} : div_res;

				dd_sig_reg_2 <= dd_sig_reg_1;

				// merge with sqrt
				dividend <= ~dp_reg + ~sqrt_res + 32'd2	;

				i <= i + 6'd1;
			end
			6'd6 + `DIV_LATE + `SQRT_LATE:begin
				t_out <= (final_res[31:10] != 22'b0 || delta_sig_reg_2==1'b1) ? 10'b1111111111 : final_res[9:0];
				delta_sig_reg_2 <= delta_sig_reg_1;

				i <= 6'd6 + `SQRT_LATE;
			end
			default:begin
				i <= i + 6'd1;
			end
			endcase
		end
	end


	/*  7 clk  */
	wire [31:0] d_mold;
	assign d_mold[31:17] = 15'd0;
	sqrt_32 sqrt_ins0(.x_in(dd_reg),.x_out(d_mold[16:0]),.clk(clk));

	/*	 6 clk	*/
	wire [31:0] sqrt_res;
	assign sqrt_res[31:17] = 15'd0;
	sqrt_32 sqrt_ins1(.x_in(delta),.x_out(sqrt_res[16:0]),.clk(clk));

	/*  24 clk  */
	wire [31:0] div_res;
	ip_div div_ins(.clk(clk),.rfd(),
		.dividend(dividend),.divisor(d_mold_reg),
		.quotient(div_res),.fractional());

endmodule


