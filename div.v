module div(
	input clk,
	input rst,
	input [LENGTH-1:0] dividend,
	input [LENGTH-1:0] divisor,
	output reg [LENGTH-1:0] quo
	// test
	,
	output [WIDTH-1:0] cur_show,
	output [LENGTH*2-1:0] pool_show,
	output rst_show
);
	parameter LENGTH = 20;
	parameter WIDTH = 6;// twice the length

	// sensitive rst
	reg first_rst = 1;
	reg delay_rst = 0;
	wire operand_rst;
	always @(posedge clk)begin
		delay_rst <= first_rst;
	end
	always @(dividend or divisor)begin
		first_rst <= ~first_rst;
	end
	assign operand_rst = ~(delay_rst ^ first_rst);
	// local rst: sensitive to operands
	wire local_rst;
	assign local_rst = operand_rst && rst;
		assign rst_show = local_rst;


	reg [WIDTH-1:0] cur;
		assign cur_show = cur;
	reg [LENGTH*2-1:0] pool;
		assign pool_show = pool;
	reg [LENGTH-1:0] res;
	reg halt = 0;
	always @(posedge clk or negedge local_rst)begin
		if(!local_rst)begin
			cur <= LENGTH*2-1;
			pool <= {0,dividend};
			res <= 0;
			quo <= 0;
			halt <= 0;
		end
		else begin
			if(cur >= LENGTH - 1)begin
				if(pool[cur -: LENGTH] >= divisor)begin
					pool[cur -: LENGTH] = pool[cur -: LENGTH] - divisor;
					res[cur-LENGTH+1] = 1;
					cur = cur-1;
				end
				cur = cur - 1;
			end
			else if(!halt) begin
				quo <= res;
				halt <= 1;
			end
		end
	end

endmodule
