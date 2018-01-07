module ray_tracer_box_test;

	// Inputs
	reg [27:0] init;
	reg [30:0] dir;
	reg [55:0] object_in;
	reg clk;
	reg rst;
	// Outputs
	wire [9:0] t_out;
	wire [59:0] t_list;
	wire [59:0] t_final;
	wire [19:0] mold;

	// Instantiate the Unit Under Test (UUT)
	ray_tracer_box uut (
		.clk(clk),
		.rst(rst),
		.init(init), 
		.dir(dir), 
		.object_in(object_in), 
		.t_out(t_out)
		,.t_list_show(t_list),
		.t_final_show(t_final),
		.mold_show(mold)
	);

	integer i;
	initial begin
		// Initialize Inputs
		clk = 0;
		rst=1;
		init = 0;
		dir = 31'b00000000000_00000000100_000000000;
		dir = 31'b00000000001_00000000111_000000001;
		object_in = {10'd0,10'd32,10'd20,10'd36,8'd0,8'd30};

		// Wait 100 ns for global reset to finish
		#100;
		rst=0;
      for(i=0;i<5000;i=i+1)begin
			clk = ~clk;
			if(i==99)begin
				dir = 31'b00000000001_00000100000_000000001;
			end
			if(i==100)begin
				rst = 1;
			end
			if(i==200)begin
				dir = 31'b1111110100000000000011000011100;
			end
			#5;
		end
		// Add stimulus here

	end
      
endmodule

