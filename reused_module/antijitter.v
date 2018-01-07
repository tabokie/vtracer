module AntiJitter(
	input clk, input I, output reg O
);
	parameter WIDTH = 20;
	reg [WIDTH-1:0] cnt = 0;

	always @ (posedge clk)
	begin
		if(I)
		begin
			if(&cnt)
				O <= 1'b1;
			else
				cnt <= cnt + 1'b1;
		end
		else
		begin
			if(|cnt)
				cnt <= cnt - 1'b1;
			else
				O <= 1'b0;
		end
	end

endmodule