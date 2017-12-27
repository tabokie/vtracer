// \input Normal vector(vector)
// \input View dist(min_dist)
// \input Canvas location(2-dimension coord)
// \output View ray vector(vector)
module view_ray(
	input clk,
	input [30:0] view_normal, // d
	input [7:0] view_dist, // d0
	input [12:0] view_loc, // (x,y) 7-6
	output [30:0] view_out
 );

	// ray generate formula:
	// |d0|/|d|*d + |x|/|d^-1|*d^-1 + (0,0,y)

	// convert to large int
	wire [19:0] dx;
	signed_to_20b_signed #(.LENGTH(11)) int0(.in(view_normal[30:20]),.out(dx));
	wire [19:0] dy;
	signed_to_20b_signed #(.LENGTH(11)) int1(.in(view_normal[19:9]),.out(dy));
	wire [19:0] dz;
	signed_to_20b_signed #(.LENGTH(9)) int2(.in(view_normal[8:0]),.out(dz));
	// calculate |d|
	wire [19:0] d_length;
	mold mold0(.clk(clk),.x(dx),.y(dy),.z(dz),.mold(d_length));
	// prepare |d0|
	wire [19:0] long_view_dist;
	assign long_view_dist = {12'b0,view_dist};
	//  and x,y
	wire [19:0] view_x;
	assign view_x[19:7] = 0;
	assign view_x[6:0] = 7'b1000001 + view_loc[12:6];
	wire [19:0] view_y;
	assign view_y[19:6] = 0;
	assign view_y[5:0] = 6'b011111 - view_loc[5:0];

	wire [19:0] view_out_x = (long_view_dist * dx + view_x * dy) / d_length;
	wire [19:0] view_out_y = (long_view_dist * dy + view_x * dx) / d_length;
	wire [19:0] view_out_z = view_y;

   	assign view_out = {view_out_x[10:0],view_out_y[10:0],view_out_z[8:0]};


endmodule