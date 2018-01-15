module ray_tracer_box(
	input clk,
	input rst,
	input [27:0] init,
	input [30:0] dir,
	input [55:0] object_in,
	output [9:0] t_out,
	output reg[30:0] normal
);

	// uint
	wire [19:0] x_lo;
	assign x_lo = {10'b0,object_in[55:46]};
	wire [19:0] x_hi;
	assign x_hi = {10'b0,object_in[45:36]};
	wire [19:0] y_lo;
	assign y_lo = {10'b0,object_in[35:26]};
	wire [19:0] y_hi;
	assign y_hi = {10'b0,object_in[25:16]};
	wire [19:0] z_lo;
	assign z_lo = {12'b0,object_in[15:8]};
	wire [19:0] z_hi;
	assign z_hi = {12'b0,object_in[7:0]};
	wire [19:0] init_x;
	assign init_x = {10'b0,init[27:18]};
	wire [19:0] init_y;
	assign init_y = {10'b0,init[17:8]};
	wire [19:0] init_z;
	assign init_z = {12'b0,init[7:0]};
	wire [19:0] dir_x;
	assign dir_x = { {10{dir[30]}},dir[29:20] };
	wire [19:0] dir_y;
	assign dir_y = { {10{dir[19]}},dir[18:9] };
	wire [19:0] dir_z;
	assign dir_z = { {12{dir[8]}},dir[7:0] };


	// 6 t solver
	wire [59:0] t_list;
	wire [79:0] t_final;
	assign t_final[79:60] = {20{1'b1}};

	// t_i = (x_? - init_x)*2^8 / dir_x
	// y = init_y + dir_y * t_i
	// z = init_z + dir_z * t_i
	// if not y in [lo,hi] and z in [lo,hi]
	// t = max_t

	// for t_i in list, t_final = min{t_i}
	// return t*dir_mold

	wire [19:0] dir_mold;
	mold mold0(.clk(clk),.x(dir_x),.y(dir_y),.z(dir_z),.mold(dir_mold));

	wire [19:0] quo0;
	reg [19:0] dividend_0;
	reg [19:0] y0;
	reg [19:0] z0;
	always @(posedge clk)begin
		dividend_0 <= x_lo + ~init_x + 20'b1;
		y0 <= init_y + dir_y*{10'b0,t_list[9:0]};
		z0 <= init_z + dir_z*{10'b0,t_list[9:0]};
	end
	my_div #(.divisorBITS(11),.dividendBITS(20)) div_ins0(.clk(clk),
		.dividend(dividend_0),.divisor(dir_x[10:0]),
		.quotient(quo0),.fractional());
	assign t_list[9:0] = (quo0[19]==1'b1 || dir_x==20'b0) ? 10'b1111111111 : quo0[9:0];
	assign t_final[9:0] = (y0 >= y_lo && y0 <= y_hi && z0 >= z_lo && z0 <= z_hi) ? t_list[9:0] : 10'b1111111111;


	wire [19:0] quo1;
	reg [19:0] dividend_1;
	reg [19:0] y1;
	reg [19:0] z1;
	always @(posedge clk)begin
		dividend_1 <= x_hi + ~init_x + 20'b1;
		y1 <= init_y + dir_y*{10'b0,t_list[19:10]};
		z1 <= init_z + dir_z*{10'b0,t_list[19:10]};
	end
	my_div #(.divisorBITS(11),.dividendBITS(20)) div_ins1(.clk(clk),
		.dividend(dividend_1),.divisor(dir_x[10:0]),
		.quotient(quo1),.fractional());
	assign t_list[19:10] = (quo1[19]==1'b1|| dir_x==20'b0) ? 10'b1111111111 : quo1[9:0];
	assign t_final[19:10] = (y1 >= y_lo && y1 <= y_hi && z1 >= z_lo && z1 <= z_hi) ? t_list[19:10] : 10'b1111111111;



	wire [19:0] quo2;
	reg [19:0] dividend_2;
	reg [19:0] x2;
	reg [19:0] z2;
	always @(posedge clk)begin
		dividend_2 <= y_lo + ~init_y + 20'b1;
		x2 <= init_x + dir_x*{10'b0,t_list[29:20]};
		z2 <= init_z + dir_z*{10'b0,t_list[29:20]};
	end
	my_div #(.divisorBITS(11),.dividendBITS(20)) div_ins2(.clk(clk),
		.dividend(dividend_2),.divisor(dir_y[10:0]),
		.quotient(quo2),.fractional());
	assign t_list[29:20] = (quo2[19]==1'b1|| dir_y==20'b0 )? 10'b1111111111 : quo2[9:0];
	assign t_final[29:20] = (x2 >= x_lo && x2 <= x_hi && z2 >= z_lo && z2 <= z_hi) ? t_list[29:20] : 10'b1111111111;


	wire [19:0] quo3;
	reg [19:0] dividend_3;
	reg [19:0] x3;
	reg [19:0] z3;
	always @(posedge clk)begin
		dividend_3 <= y_hi + ~init_y + 20'b1;
		x3 <= init_x + dir_x*{10'b0,t_list[39:30]};
		z3 <= init_z + dir_z*{10'b0,t_list[39:30]};
	end
	my_div #(.divisorBITS(11),.dividendBITS(20)) div_ins3(.clk(clk),
		.dividend(y_lo + ~init_y + 20'b1),.divisor(dir_y[10:0]),
		.quotient(quo3),.fractional());
	assign t_list[39:30] = (quo3[19]==1'b1|| dir_y==20'b0 ) ? 10'b1111111111 : quo3[9:0];
	assign t_final[39:30] = (x3 >= x_lo && x3 <= x_hi && z3 >= z_lo && z3 <= z_hi) ? t_list[39:30] : 10'b1111111111;

	wire [19:0] quo4;
	reg [19:0] dividend_4;
	reg [19:0] x4;
	reg [19:0] y4;
	always @(posedge clk)begin
		dividend_4 <= z_lo + ~init_z + 20'b1;
		x4 <= init_x + dir_x*{10'b0,t_list[49:40]};
		y4 <= init_y + dir_y*{10'b0,t_list[49:40]};
	end
	my_div #(.divisorBITS(11),.dividendBITS(20)) div_ins4(.clk(clk),
		.dividend(z_hi + ~init_z + 20'b1),.divisor(dir_z[10:0]),
		.quotient(quo4),.fractional());
	assign t_list[49:40] = (quo4[19]==1'b1|| dir_z==20'b0 ) ? 10'b1111111111 : quo4[9:0];
	assign t_final[49:40] = (x4 >= x_lo && x4 <= x_hi && y4 >= y_lo && y4 <= y_hi) ? t_list[49:40] : 10'b1111111111;

	wire [19:0] quo5;
	reg [19:0] dividend_5;
	reg [19:0] x5;
	reg [19:0] y5;
	always @(posedge clk)begin
		dividend_5 <= z_hi + ~init_z + 20'b1;
		x5 <= init_x + dir_x*{10'b0,t_list[59:50]};
		y5 <= init_y + dir_y*{10'b0,t_list[59:50]};
	end
	my_div #(.divisorBITS(11),.dividendBITS(20)) div_ins5(.clk(clk),
		.dividend(z_lo + ~init_z + 20'b1),.divisor(dir_z[10:0]),
		.quotient(quo5),.fractional());
	assign t_list[59:50] = (quo5[19]==1'b1|| dir_z==20'b0 ) ? 10'b1111111111 : quo5[9:0];
	assign t_final[59:50] = (x5 >= x_lo && x5 <= x_hi && y5 >= y_lo && y5 <= y_hi) ? t_list[59:50] : 10'b1111111111;

	// assign t_final[59:30] = {30{1'b1}};

	wire [2:0] min_id;
	min #(.WIDTH(3),.LENGTH(10)) min0(.in_bus(t_final),.out(min_id));

	assign t_out = t_final[(min_id+1)*10-1 -: 10]*dir_mold;
	always @(*)begin
		case(min_id)
		3'd0:normal = {-11'b1,11'b0,9'b0};
		3'd1:normal = {11'b1,11'b0,9'b0};
		3'd2:normal = {11'b0,-11'b1,9'b0};
		3'd3:normal = {11'b0,11'b1,9'b0};
		3'd4:normal = {11'b0,11'b0,-9'b1};
		3'd5:normal = {11'b0,11'b0,9'b1};
		endcase
	end

endmodule

