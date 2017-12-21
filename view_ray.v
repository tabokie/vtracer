module view_ray(
	input [27:0] view_normal, // d
	input [9:0] view_dist, // d0
	input [12:0] view_loc, // (x,y) 6-7
	output [27:0] view_out
)

	reg [27:0] view_reg; // 10-10-8 :: x-y-z
	wire [19:0] dx;
	wire [19:0]dy;
	wire [19:0]dz;
	assign dx[9:0] = view_normal[27:18];
	assign dy[9:0] = view_normal[17:8];
	assign dz[9:0] = view_normal[7:0];
	reg [19:0] d_length;
	mold #(.x(dx),.y(dy),.z(dx),.mold(d_length));

	wire [19:0] expanded_view_dist;
	assign expanded_view_dist[9:0] = view_dist;
	wire [19:0] expanded_view_x;
	assign expanded_view_x[6:0] = - 7'b0111111 + view_loc[6:0];
	wire [19:0] expanded_view_y;
	assign expanded_view_y[5:0] = 6'b011111 + view_loc[12:7];

	wire [19:0] view_x = expanded_view_dist / d_length * dx + expanded_view_x / d_length * dy;
	wire [19:0] view_y = expanded_view_dist / d_length * dy + expanded_view_x / d_length * dx;
	wire [19:0] view_z = expanded_view_y;

// return 4*(|d0|/|d|*d + |x|/|d-1|*d-1 + (0,0,y))/4
// d-1 = (y,x,0) 
    assign view_out = {view_x[9:0],view_y[9:0],view_z[7:0]};

endmodule

module mold(
	input [19:0] x;
	input [19:0] y;
	input [19:0] z;
	output [19:0] mold;
)

	wire [19:0] x2 = x*x;
	wire [19:0] y2 = y*y;
	wire [19:0] z2 = z*z;
	wire [19:0] sum = x2+y2+z2;
	sqrt_20 #(.d_in(sum),.d_out(mold));

endmodule

// module sqrt_20(
// )

// endmodule