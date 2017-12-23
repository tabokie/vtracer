module ray_tracer_sphere(
	input [27:0] init,
	input [27:0] dir,
	input [49:0] object_in, // 12(color)-10(r)-28(center) = 50
	output [9:0] t_out
);

	wire [27:0] c;
	assign c = object_in[27:0];
	wire [19:0] r;
	assign r[19:10] = 10'b0;
	assign r[9:0] = object_in[37:28];

	wire [19:0]d_x;
	assign d_x[19:10] = 10'b0;
	assign d_x[9:0] = dir[27:18];
	wire [19:0]d_y;
	assign d_y[19:10] = 10'b0;
	assign d_y[9:0] = dir[17:8];
	wire [19:0]d_z;
	assign d_z[19:10] = 10'b0;
	assign d_z[9:0] = dir[7:0];
	wire [19:0]eminusc_x;
	assign eminusc_x[19:10] = 10'b0;
	assign eminusc_x[9:0] = init[27:18] - c[27:18];
	wire [19:0]eminusc_y;
	assign eminusc_y[19:10] = 10'b0;
	assign eminusc_y[9:0] = init[17:8] - c[17:8];
	wire [19:0]eminusc_z;
	assign eminusc_z[19:10] = 10'b0;
	assign eminusc_z[9:0] = init[7:0] - c[7:0];


endmodule

