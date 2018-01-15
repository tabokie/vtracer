`timescale 1ns / 1ps

module my_div(
	input clk,
	input [divisorBITS-1:0] divisor,
	input [dividendBITS-1:0] dividend,
	output [dividendBITS-1:0]quotient,
	output [addBITS-1:0]fractional
);
	parameter divisorBITS=10;
	parameter dividendBITS=20;
	parameter addBITS=divisorBITS+dividendBITS-1;

	wire [divisorBITS-1:0] divisor_u;
	assign divisor_u = (divisor[divisorBITS-1]==1'b1) ? (~divisor+1) : divisor;
	wire [dividendBITS-1:0] dividend_u;
	assign dividend_u = (dividend[dividendBITS-1]==1'b1) ? (~dividend+1) : dividend;
	wire [dividendBITS-1:0]quotient_mid[dividendBITS-1:0];
	wire [dividendBITS-1:0]quotient_temp[dividendBITS-1:0];
	wire [addBITS-1:0] difference[dividendBITS-1:0];
	
	genvar i;
	wire [addBITS-1:0] divisor_int [dividendBITS-1:0];
	wire [addBITS-1:0] dividend_int [dividendBITS-1:0];	
	wire [addBITS-1:0] stage_divisor_int_out [dividendBITS-1:0];
	wire [addBITS-1:0] register_dividend_int_out[dividendBITS-1:0];
	wire [addBITS-1:0] register_divisor_int_out[dividendBITS-1:0];
	wire [dividendBITS-1:0] register_quotient_int_out[dividendBITS-1:0];
	wire [dividendBITS-1:0] stage_quotient_int_in[dividendBITS-1:0];
	wire [dividendBITS-1:0] register_quotient_int_in[dividendBITS-1:0];

	assign divisor_int[dividendBITS-1]=divisor_u;
	assign dividend_int[dividendBITS-1]=dividend_u;
	assign stage_quotient_int_in[dividendBITS-1] = 'b0;

	Stage #(.divisorBITS(divisorBITS),.dividendBITS(dividendBITS)) S1 (divisor_int[dividendBITS-1],dividend_int[dividendBITS-1],dividendBITS-1,stage_quotient_int_in[dividendBITS-1],quotient_mid[dividendBITS-1],difference[dividendBITS-1],stage_divisor_int_out[dividendBITS-1]); // first instance of the stage 
	Register #(.divisorBITS(divisorBITS),.dividendBITS(dividendBITS)) R (stage_divisor_int_out[dividendBITS-1],difference[dividendBITS-1],quotient_mid[dividendBITS-1],register_divisor_int_out[dividendBITS-1],register_dividend_int_out[dividendBITS-1],register_quotient_int_out[dividendBITS-1],clk);// first instance of register
	
	generate
	for (i=dividendBITS-2;i>=0; i=i-1)begin
		Stage #(.divisorBITS(divisorBITS),.dividendBITS(dividendBITS)) S (register_divisor_int_out[i+1],register_dividend_int_out[i+1],i,register_quotient_int_out[i+1],quotient_mid[i],difference[i],stage_divisor_int_out[i]); // using a generate loop to create instances, connecting each stage appropriately
		Register #(.divisorBITS(divisorBITS),.dividendBITS(dividendBITS)) R (stage_divisor_int_out[i],difference[i],quotient_mid[i],register_divisor_int_out[i],register_dividend_int_out[i],register_quotient_int_out[i],clk); // register module instantiation
	end
	endgenerate 

	assign quotient=(divisor[divisorBITS-1]^dividend[dividendBITS-1] == 1'b1) ? ~register_quotient_int_out[0] + 1 : register_quotient_int_out[0]; // final register slice quotient value
	assign fractional=register_dividend_int_out[0]; // final register slice quotient value


endmodule




// module my_div(clk, ena, z, d, q, s);

// 	//
// 	// parameters
// 	//
// 	parameter z_width = 20;
// 	parameter d_width = 10;

// 	//
// 	// inputs & outputs
// 	//
// 	input clk;               // system clock
// 	input ena;               // clock enable

// 	input  [z_width -1:0] z; // divident
// 	input  [d_width -1:0] d; // divisor
// 	output [z_width -1:0] q; // quotient
// 	output [z_width -1:0] s; // remainder

// 	//
// 	// functions
// 	//
// 	function sc;
// 	  input [z_width:0] si;
// 	  input [d_width:0] di;
// 	begin
// 	    sc = si[z_width] ~^ di[d_width];
// 	end
// 	endfunction

// 	function [z_width:0] gen_q;
// 	  input [z_width:0] q;
// 	  input             q0;
// 	begin
// 	    gen_q = {(q << 1), q0};
// 	end
// 	endfunction

// 	function [z_width:0] gen_s;
// 	  input [z_width:0] si;
// 	  input [z_width:0] di;
// 	  input             sel;
// 	begin
// 	    if(sel)
// 	      gen_s = {si[z_width-1:0], 1'b0} - di;
// 	    else
// 	      gen_s = {si[z_width-1:0], 1'b0} + di;
// 	end
// 	endfunction

// 	//
// 	// variables
// 	//
// 	reg [z_width:0] q_pipe  [z_width:0];
// 	reg [z_width:0] s_pipe  [z_width:0];
// 	reg [z_width:0] d_pipe  [z_width:0];
// 	reg [z_width:0] qb_pipe;

// 	//
// 	// perform parameter checks
// 	//
// 	// synopsys translate_off
// 	initial
// 	begin
// 	  if(d_width > z_width)
// 	    $display("div.v parameter error (d_width > z_width). Divisor width larger than divident width.");
// 	end
// 	// synopsys translate_on

// 	integer n;

// 	// generate divisor (d) pipe
// 	always @(d)
// 	  d_pipe[0] <= {d[d_width -1], d, {(z_width-d_width){1'b0}} };

// 	always @(posedge clk)
// 	  if(ena)
// 	    for(n=1; n < z_width; n=n+1)
// 	       d_pipe[n] <= #1 d_pipe[n-1];

// 	// generate sign comparator pipe
// 	always
// 	  begin
// 	    #1;
// 	    for(n=0; n < z_width; n=n+1)
// 	       qb_pipe[n] <= sc(s_pipe[n], d_pipe[n]);
// 	  end

// 	// generate internal remainder pipe
// 	always@(z)
// 		s_pipe[0] <= {z[z_width -1], z};

// 	always @(posedge clk)
// 	  if(ena)
// 	    for(n=1; n < z_width; n=n+1)
// 	       s_pipe[n] <= #1 gen_s(s_pipe[n-1], d_pipe[n-1], qb_pipe[n-1]);

// 	// generate quotient pipe
// 	always @(qb_pipe[0])
// 	  q_pipe[0] <= #1 { {(z_width){1'b0}}, qb_pipe[0]};

// 	always @(posedge clk)
// 	  if(ena)
// 	    for(n=1; n < z_width; n=n+1)
// 	       q_pipe[n] <= #1 {q_pipe[n-1], qb_pipe[n]};

// 	wire [z_width:0] last_q;
// 	assign last_q = q_pipe[z_width -1];

// 	always @(posedge clk)
// 	  if(ena)
// 	    q_pipe[z_width] <= #1 {!last_q[z_width-1], last_q[z_width-2:0], 1'b1};

// 	// assign outputs
// 	assign q = q_pipe[z_width];
// 	assign s = s_pipe[z_width];
// endmodule

// module my_div(
// 	input clk,
// 	input rst,
// 	input [LENGTH-1:0] dividend,
// 	input [LENGTH-1:0] divisor,
// 	input start,
// 	output [LENGTH-1:0] quotient,
// 	output [LENGTH-1:0] remainder,
// 	output ready,
// 	output busy,
// 	output finish
// )


// endmodule