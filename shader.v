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
// lantency : 34 clk

`define DIR_SCALE 0
`define COS_SCALE 4
`define MOLD_LATE 6'd8
`define DIV_LATE 6'd20
`define GLOBAL_INTERVAL 6'd36

module single_shader(
	input clk,
	input rst,
	input [27:0] light,
	input [27:0] init,
	input [30:0] dir,
	input [9:0] t, 
	input [30:0] normal,
	input [9:0] normal_mold,
	output reg [11:0] color
);

	// pooling 1 : get a //
	reg [19:0] dt_x;
	reg [19:0] dt_y;
	reg [19:0] dt_z;


	reg [19:0] ax;
	reg [19:0] ay;
	reg [19:0] az;


	// pooling 2 : get l-a // 
	reg [19:0] la_x;
	reg [19:0] la_y;
	reg [19:0] la_z;
	

	// pooling 3 : get |l-a| //
	reg [19:0] la_mold_reg;	
	wire [19:0] la_mold;

	// pooling 4 : get (l-a)*n //
	reg [19:0] dividend_x;
	reg [19:0] dividend_y;
	reg [19:0] dividend_z;
	

	// pooling 5 : get (l-a)*n //
	reg [19:0] dividend;

	// pooling 6 : divider //
	reg[19:0] divisor;
	wire [19:0] divisor_unscaled;
	assign divisor_unscaled = la_mold_reg * normal_mold;

	wire [19:0] scaled_cos;
	reg [19:0] scaled_cos_reg;
	

	wire [19:0] dir_square;
	wire [4:0] pos;
	assign zero = 11'b0;
	assign dir_square = {{10{dir[30]}},dir[29:20]}*{{10{dir[30]}},dir[29:20]} + {{10{dir[19]}},dir[18:9]}*{{10{dir[19]}},dir[18:9]}+{{12{dir[8]}},dir[7:0]}*{{12{dir[8]}},dir[7:0]};
	hi_one_pos hi(.in(dir_square),.out(pos));

	reg [5:0] i;
	always @(posedge clk or negedge rst)begin
		if(!rst)begin
			i<= 6'b0;
		end
		else begin
			case(i)
			6'b0:begin
				dt_x <= {{10{dir[30]}},dir[29:20]} * {10'b0,t};
				dt_y <= {{10{dir[19]}},dir[18:9]} * {10'b0,t};
				dt_z <= {{12{dir[8]}},dir[7:0]} * {10'b0,t};

				i <= i + 6'd1;				
			end
			6'b1:begin
				ax <= dt_x[19]==1'b1 ? {10'b0,init[27:18]} + ~((~dt_x+20'b1)>>pos/2)+20'b1 : {10'b0,init[27:18]} + dt_x>>(pos/2);// + {{(`DIR_SCALE+1){dt_x[19]}},dt_x[18:`DIR_SCALE]};
				ay <= dt_y[19]==1'b1 ? {10'b0,init[17:8]} + ~((~dt_y+20'b1)>>pos/2)+20'b1 : {10'b0,init[17:8]} + dt_y>>(pos/2);
				az <= dt_z[19]==1'b1 ? {12'b0,init[7:0]} + ~((~dt_z+20'b1)>>pos/2)+20'b1 : {12'b0,init[7:0]} + dt_z>>(pos/2);

				i <= i + 6'd1;				
			end
			6'd2:begin
				la_x <= {10'b0,light[27:18]} + ~ax + 20'b1;
				la_y <= {10'b0,light[27:18]} + ~ay + 20'b1;
				la_z <= {10'b0,light[27:18]} + ~az + 20'b1;

				i <= i + 6'd1;				
			end
			6'd3:begin
				dividend_x <= la_x * {{10{normal[30]}},normal[29:20]};
				dividend_y <= la_y * {{10{normal[19]}},normal[18:9]};
				dividend_z <= la_z * {{12{normal[8]}},normal[7:0]};

				i <= i + 6'd1;				
			end
			6'd4:begin
				dividend <= dividend_x + dividend_y + dividend_z;		

				i <= i + 6'd1;					
			end
			6'd3+`MOLD_LATE:begin
				la_mold_reg <= la_mold;

				i <= i + 6'd1;				
			end
			6'd4+`MOLD_LATE:begin
				divisor <= {{(`COS_SCALE+1){divisor_unscaled[19]}},divisor_unscaled[18:`COS_SCALE]};
				
				i <= i + 6'd1;
			end
			6'd5 +`MOLD_LATE + `DIV_LATE:begin
				scaled_cos_reg <= scaled_cos;

				i <= i + 6'd1;
			end
			// end in 34 clk
			6'd6 + `MOLD_LATE + `DIV_LATE:begin
				color <= (scaled_cos_reg[19]==1'b1) ? 12'h0 : {3{scaled_cos_reg[3:0]}};

				// merged routine
				i <= 6'd6 + `MOLD_LATE;
			end
			`GLOBAL_INTERVAL:begin
				i <= 6'd0;// new input
			end
			default :begin
				i <= i+6'b1;
			end
			endcase
		end
	end

	mold mold0(.clk(clk),.x(la_x),.y(la_y),.z(la_z),.mold(la_mold));

	my_div #(.divisorBITS(20),.dividendBITS(20)) div_ins(.clk(clk),
		.dividend(dividend),.divisor(divisor),
		.quotient(scaled_cos),.fractional());
		
endmodule