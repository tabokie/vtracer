`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:02:06 12/26/2017 
// Design Name: 
// Module Name:    signed_to_20b_signed 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
// link to wire type
module signed_to_20b_signed(
	input [LENGTH-1:0] in,
	output reg [19:0] out
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
