module hi_one_pos(
	input [19:0] in,
	input reg [4:0] out
)
	wire [19:0] unsigned_in;
	assign unsigned_in = (in[19]==1'b1) ? (~in+20'b1) : in;

	always @(*)begin
		// 19 bit
		if(unsigned_in&&20'd262144 != 20'd0)out = 5'd19;
		// 18 bit
		else if(unsigned_in&&20'd131072!= 20'd0)out = 5'd18;
		else if(unsigned_in&&20'd65536!= 20'd0)out = 5'd17;
		else if(unsigned_in&&20'd32768!= 20'd0)out = 5'd16;
		else if(unsigned_in&&20'd16384!= 20'd0)out = 5'd15;
		else if(unsigned_in&&20'd8192!= 20'd0)out = 5'd14;
		else if(unsigned_in&&20'd4096!= 20'd0)out = 5'd13;
		else if(unsigned_in&&20'd2048!= 20'd0)out = 5'd12;
		else if(unsigned_in&&20'd1024!= 20'd0)out = 5'd11;
		else if(unsigned_in&&20'd512!= 20'd0)out = 5'd10;
		else out = 5'd9;
	end

endmodule