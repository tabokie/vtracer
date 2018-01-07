`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:57:40 12/26/2017 
// Design Name: 
// Module Name:    two_d_normalize 
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
// specially for vector (x,y,0)
module two_d_normalize(
    input clk,
    input [7:0] d,
    input [21:0] dir,
    output reg [10:0] normalized_x,
    output reg [10:0] normalized_y
);
    wire [19:0] nmold;
    wire [19:0] nx;
    signed_to_20b_signed #(.LENGTH(11)) int0(.in(dir[21:11]),.out(nx));
    wire [19:0] ny;
    signed_to_20b_signed #(.LENGTH(11)) int1(.in(dir[10:0]),.out(ny));
    mold mold0(.clk(clk),.x(nx),.y(ny),.z(20'b0),.mold(nmold));

    wire [19:0] norx;
    assign norx = nx*d/nmold;
    wire [19:0] nory;
    assign nory = ny*d/nmold;

    always @(*)begin
        normalized_x[9:0] = nx[9:0];
        normalized_x[10] = norx[19]==1'b1 ? 1'b1 : 1'b0;
        normalized_y[9:0] = ny[9:0];
        normalized_x[10] = nory[19]==1'b1 ? 1'b1 : 1'b0;
    end
endmodule