module contain_20b(
	input [19:0] x_in,
	input [19:0] y_in,
	input [19:0] z_in,
	output [`TARGET-1:0] x_out,
	output [`TARGET-1:0] y_out,
	output [`TARGET-1:0] z_out
)
// contain 20 bit signed int to 9 bit
	parameter TARGET = 5'd9;
	wire [4:0] x_hi;
	hi_one_pos hi0(.in(x_in),.out(x_hi));
	wire [4:0] y_hi;
	hi_one_pos hi1(.in(y_in),.out(y_hi));
	wire [4:0] z_hi;
	hi_one_pos hi2(.in(z_in),.out(z_hi));

	reg [4:0] max_hi;
	always @(*)begin
		if(x_hi>=y_hi&&x_hi>=z_hi)begin
			max_hi = x_hi;
		end
		else if(y_hi>=x_hi&&y_hi>=z_hi)begin
			max_hi = y_hi;
		end
		else begin
			max_hi = z_hi;
		end
	end
	assign x_out = (max_hi>`TARGET-5'd2) ? x_in[max_hi+5'd1 -= `TARGET] : x_in[`TARGET-1 :0 ];
	assign y_out = (max_hi>`TARGET-5'd2) ? y_in[max_hi+5'd1 -= `TARGET] : y_in[`TARGET-1 :0 ];
	assign z_out = (max_hi>`TARGET-5'd2) ? z_in[max_hi+5'd1 -= `TARGET] : z_in[`TARGET-1 :0 ];

endmodule

