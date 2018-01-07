module user_sqrt_20(
	input [19:0] x_in,
	input clk,
	output [19:0] x_out,
	output done_sig
);
	
	assign x_out[19:11] = 9'b0;
	sqrt_20 ins(
	  .x_in(x_in), // input [19 : 0] x_in
	  .x_out(x_out[10:0]), // output [10 : 0] x_out
	  .clk(clk) // input clk
	);

	reg change_sig = 1'b0;
	always @(x_out)begin
		change_sig = ~change_sig;
	end
	reg change_delay;
	always @(posedge clk)begin
		change_delay <= change_sig;
	end
	assign done_sig = change_sig ^ change_delay;

endmodule

