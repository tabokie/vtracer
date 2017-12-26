// link to wire type
module signed_to_20b_signed(
	input [LENGTH-1:0] in,
	output reg[19:0] out
);

	parameter LENGTH = 10;

	always @(in) begin
		out[LENGTH-2:0] = in[LENGTH-2:0];
		case(in[LENGTH-1])
		1'b1:out[19:LENGTH-1] = -1;
		1'b0:out[19:LENGTH-1] = 0;
		endcase
	end

endmodule




/*
module signed_expansion(
	input [IN_LEN-1:0] in,
	output [OUT_LEN-1:0] out
);
	
	parameter IN_LEN = 10;
	parameter OUT_LEN = 20;

	out[IN_LEN-2:0] = in[IN_LEN-2:0];
	always @(*)begin
		case(in[IN_LEN-1])
		1'b1:out[OUT_LEN-1:IN_LEN-1] = -1;
		1'b0:out[OUT_LEN-1:IN_LEN-1] = 0;
		endcase
	end

endmodule

module signed_compact(
	input
)

module signed_to_20b_unsigned(
	input [LENGTH-1:0] in,
	output [19:0] out
);

	parameter LENGTH = 10;

	assign out[19:LENGTH-1] = 0;

	always @(*) begin
		if(in[LENGTH-1]==1'b1)begin
			out[LENGTH-2:0] = ~(in[LENGTH-2:0]-1);
			out[19] = 1'b1;
		end
	end

endmodule
*/