module user_div(
	input clk,
	input [19:0] dividend,
	input [19:0] divisor,
	output [19:0] quotient,
	output done_sig
);

	ip_div div_ins0(.clk(clk),.rfd(),
		.dividend(dividend),.divisor(divisor),
		.quotient(quotient),.fractional());

	reg change_sig = 1'b0;
	always @(quotient)begin
		change_sig = ~change_sig;
	end
	reg change_delay;
	always @(posedge clk)begin
		change_delay <= change_sig;
	end
	assign done_sig = change_sig ^ change_delay;

endmodule
